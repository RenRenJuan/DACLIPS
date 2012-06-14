;**************************************************************************
; File:            CCP.clp  (C.C.P. stand for Clips Constraints Programming)
; Content:         Generic Clips Module for Constraints Programming
; Author:          Michel Futtersack
; Version:         1.0.3  (May 1999)  Version compatible JESS
; Contact:         Michel.Futtersack@math-info.univ-paris5.fr
;**************************************************************************


;*******************  templates   *****************************************
 
(deftemplate   pb
   (slot  state (default start))
   (slot  level  (default 0))
   (slot  current-hypothesis (default no))
)


(deftemplate   var
   (slot  name)
   (slot  level (default 0))
   (slot  value)
   (slot depending-on)
   (multislot  possible-values)
)

(deftemplate   solution
   (slot number (default 1))
   (slot printed (default no))
   (multislot var-val)
)

;****************************  Functions   *********************************

(deffunction   yes-or-no-p (?question)
  (bind ?x bogus)
  (while (and (neq ?x yes) (neq ?x y) (neq ?x no) (neq ?x n))
     (format t "%s(Yes or No) " ?question)
     (bind ?x (lowcase (sym-cat (read)))))
  (if (or (eq ?x yes) (eq ?x y)) then TRUE else FALSE))

;*****************************  Facts    ***********************************

(deffacts   initial-pb
   (pb)
   (solution)
   (level_search 0)
   (phase MAIN)
)
;******************************  Rules   ***********************************



;............................. phase MAIN  .................................

(defrule   all-solutions?
        (phase MAIN)
  ?pb<- (pb (state start))
=>
  (if (yes-or-no-p "Do you want all the solutions ? ")
     then  (build  
            "(defrule    pb-solved
                  ?p   <-(phase MAIN)
                  (pb  (state solved))
                  ?sol <- (solution (number ?nb))
                =>
                  (printout t \"the problem is solved\" crlf)
                  (assert (solution (number (+ ?nb 1))(printed no) (var-val)))
                  (retract ?p)
                  (assert (phase SEARCH))
              )
            ")
      else  (build  
            "(defrule    pb-solved
                  ?p   <-(phase MAIN)
                  ?f <- (pb (state solved))
                  ?sol <- (solution (number ?nb))
                =>
                  (printout t \"the problem is solved\" crlf)
                  (assert (solution (number (+ ?nb 1))(printed no) (var-val)))
                  (if (yes-or-no-p \"Do you want another solution ? \")
                    then (assert (phase SEARCH)) (retract ?p)
                    else (modify ?f (level 0) (state blocked)) 
                  )
              )
             ")
   )
   (modify ?pb (state in-progress))
)


(defrule   analysis
   ?p <- (phase MAIN)
   ?f <- (pb (state in-progress))
=>
         (modify ?f (state new-depth))
         (retract ?p)
         (assert (phase SEARCH ))
)

(defrule   save-solution
; if all the variables have got a value at the deapest level of the search
; then save the solution in a list of bindings (<variable> <value>)
          (declare (salience 10))
          (phase MAIN)
          (level_search ?n)
          (not (level_search  ?n1&:(> ?n1 ?n)))
          (not (var (level ?n) (value nil)))
          (var (name ?x) (value ?val&~nil))
    ?s <- (solution (var-val $?list&:(not (member$ ?x $?list))))
    ?f <- (pb (level ?n))
=>
          (modify ?s (var-val (insert$ $?list 1  (create$ ?x ?val))))
          (modify ?f (state solved))
)

(defrule   no-more-solution
         (declare (salience 10))
         (phase MAIN)
         (level_search  0)
   ?f <- (solution (number ?nb) (var-val))
         (pb (state blocked) (level 0))
=>
         (if (= ?nb 1) then (printout t "I found no solution" crlf)
                       else (printout t "No more solution" crlf crlf)
                            (retract ?f)
                            (printout t "I found " (- ?nb 1) " solution(s)" crlf crlf)
         )
)

(defrule   print-solution
; the default printing method
      (phase MAIN)
      (pb (state blocked) (level 0))
 ?s<- (solution (number ?n) (printed no) (var-val $?list&:(> (length$ $?list) 0)))
=>
      (printout t crlf "Solution number " ?n " : "  crlf)
      (bind ?length (length$ $?list))
      (bind ?i 1)
      (while (< ?i ?length) (printout t (nth$ ?i $?list) " : " (nth$ (+ ?i 1) $?list) crlf) (bind ?i (+ ?i 2)))
      (modify ?s (printed yes))
)


(defrule   to_customized_printing
; branch to rules for specific printing 
; add this rule only if you have specific printing rules in the PROPAG file
    (declare (salience -10))
    (phase MAIN)
    (pb (state blocked)(level 0))
=>
    (printout t crlf crlf)
    (assert (phase PROPAG))
)

;...............................  phase SEARCH  ..............................

(defrule  generate-new-depth
         (phase SEARCH)
         (level_search ?n)
         (not (level_search  ?n1&:(> ?n1 ?n)))
         (pb (level ?n) (state new-depth))
=>
         (assert (pb (level (+ ?n 1)) (state choice-var)(current-hypothesis nil)))
         (assert (level_search (+ ?n 1)))
)


(defrule   choice-var1
; make an hypothesis at a new level of the search.
         (phase SEARCH)
         (level_search ?n)
   ?g <- (pb (level ?n)(state choice-var)(current-hypothesis nil))
         (var (name ?x) (level ?x1) (value nil) (possible-values $?nb1))
         (not (var (name ?x) (level ?x2&:(> ?x2 ?x1))) )
=>
         (modify ?g  (current-hypothesis ?x))
)

(defrule   choice-var2
; Choose the most constrained variable (i.e. the ones which has the less possible values)
         (phase SEARCH)
         (level_search ?n)
   ?g <- (pb (level ?n)(state choice-var)(current-hypothesis ?x&~nil))
         (var (name ?x) (level ?x1) (value nil) (possible-values $?nb1))
         (not (var (name ?x) (level ?x2&:(> ?x2 ?x1))) )
         (var (name ?y&~?x) (value nil)(level ?m)(possible-values $?nb2&:(< (length$ ?nb2) (length$ $?nb1))))
         (not (var (name ?y) (level ?m1&:(> ?m1 ?m))))
=>
         (modify ?g (current-hypothesis ?y))
)

(defrule  choice-var-to-choice-val
         (declare (salience -10))
         (phase SEARCH)
         (level_search ?n)
   ?g <- (pb (level ?n)(state choice-var))
=>
         (modify ?g (state choice-val))
)


(defrule   choice-val
; choose a value among the possible values of the chosen variable (the first available in the list...we should improve this choice !!)
   ?p <- (phase SEARCH)
   ?ls<- (level_search ?n)
   ?g <- (pb (level ?n)(state choice-val)(current-hypothesis ?x))
   ?f <- (var (name ?x) (level ?l) (value nil) (possible-values $?vals))
         (not (var (name ?x) (level ?ll&:(> ?ll ?l))) )
=>
         (modify ?g (state in-progress))
         (assert (var (name ?x) (level ?n) (value (nth$ 1 $?vals))(possible-values (rest$ $?vals)) (depending-on ?ls)))
         (retract ?p)
         (assert (phase PROPAG))
)

(defrule   instanciation
; if a not yet instanciated variable has only one possible value then provide it with this value
; then set the focus to PROPAG for evaluating the consequences of this forced instanciation
; then return to SEARCH
   ?p <- (phase SEARCH)
   ?ls<- (level_search  ?n) 
   ?f <- (var (name ?x) (level ?n) (value nil) (possible-values $?list&:(= (length$ $?list) 1)))
         (pb (state in-progress) (level ?n))
=>
         (modify ?f (value (nth$ 1 $?list))(possible-values)(depending-on ?ls))
         (retract ?p)
         (assert (phase PROPAG))
)

(defrule   impasse
; if there exists a not yet instanciated variable which has no more possible values then you got an impasse
          (declare (salience 10))
          (phase SEARCH)
          (level_search ?n)
   ?pb <- (pb (level ?n) (state in-progress))
          (var (level ?n)(value nil) (possible-values))
=>
          (modify ?pb (state blocked))
)


(defrule   delete-the-propagations
; if the problem solving process is blocked with the current hypothesis ?x
; or if we are looking for another solution, we have to delete all the propagations
; depending on the last chosen value
           (declare (salience 100))
           (phase SEARCH)
   ?s   <- (level_search  ?n)
   ?pb  <- (pb (level ?n) (state blocked|solved) (current-hypothesis ?x))
   ?var <- (var (name ?y&~?x) (depending-on ?s))
 =>
           (retract ?var)
)


(defrule   backtrack-on-value
; if the problem solving process is blocked with the current hypothesis ?x
; or if we are looking for another solution, we have to choose another value for
; the hypothesis.
; We stay at the same level of search but BE CAREFUL !!! we have to delete all the facts
; depending on the current value of the hypothesis ?x
; thanks to the logical dependencies it suffices to retract the fact ?s
; then to restore it (with a new time-tag)
   ?p   <- (phase SEARCH)
   ?s   <- (level_search  ?n)
   ?pb  <- (pb (level ?n) (state blocked|solved) (current-hypothesis ?x))
   ?var <- (var (name ?x) (level ?n) (value ?v&~nil) (possible-values $?list))
 =>
           (retract ?s)
           (assert (level_search ?n))
           (modify ?var  (value (nth$ 1 $?list))(possible-values (rest$ $?list)))
           (modify ?pb (state in-progress))
           (retract ?p)
           (assert (phase PROPAG))
)

(defrule   backtrack-on-variable
; if the problem solving process is blocked and no other value is available for the
; current hypothesis then we have to return to a previous level of the search
; where the problem solving process was not blocked. The next step will be the choice of another
; value for the current hypothesis of this previous level
             (phase SEARCH)
   ?s     <- (level_search ?n)
   ?pb    <- (pb (level ?n) (state blocked|solved)(current-hypothesis ?x))
   ?pbbis <- (pb (level ?m&:(= ?m (- ?n 1))) (state ~blocked))
   ?var   <- (var (name ?x) (level ?n) (possible-values))
=>
             (retract ?s)
             (retract ?pb)
             (retract ?var)
             (modify ?pbbis  (state blocked))
)

(defrule return-to-MAIN
     (declare (salience -1000))
?p<- (phase SEARCH)
 =>
     (retract ?p)
     (assert (phase MAIN))
)

