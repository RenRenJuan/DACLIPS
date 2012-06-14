;**************************************************************************
; File: CCP.clp (C.C.P. stand for Clips Constraint Programming)
; Content: Generic Clips Module for Constraints Programming
; Authors: Jean-Marc Labat and Michel Futtersack
; Version: 1.0 (September 1997)
; Contact: Jean-Marc.Labat,Michel.Futtersack@lip6.fr
;**************************************************************************

;######################## MODULE MAIN ###########################

(defmodule MAIN
(export deftemplate ?ALL))

(deftemplate MAIN::pb
(slot state (default start))
(slot level (default 0))
(slot current-hypothesis (default no))
)

(deftemplate MAIN::var
(slot name)
(slot level (default 0))
(multislot possible-values)
(slot value)
)

(deftemplate MAIN::solution
(slot number (default 1))
(multislot var-val)
)

(deffacts MAIN::initial-pb
(pb)
(solution)
(level_search 0)
)

(deffunction MAIN::yes-or-no-p (?question)
(bind ?x bogus)
(while (and (neq ?x yes) (neq ?x y) (neq ?x no) (neq ?x n))
(format t "%s(Yes or No) " ?question)
(bind ?x (lowcase (sym-cat (read)))))
(if (or (eq ?x yes) (eq ?x y)) then TRUE else FALSE))

(defrule MAIN::all-solutions?
?pb<- (pb (state start))
=>
(if (yes-or-no-p "Do you want all the solutions ? ")
then (build
"(defrule MAIN::pb-solved
(pb (state solved))
?sol <- (solution (number ?nb))
=>
(printout t \"the problem is solved\" crlf)
(duplicate ?sol (number (+ ?nb 1))(var-val))
(focus SEARCH))
")
else (build
"(defrule MAIN::pb-solved
?f <- (pb (state solved))
?sol <- (solution (number ?nb))
=>
(printout t \"the problem is solved\" crlf)
(duplicate ?sol (number (+ ?nb 1))(var-val))
(if (yes-or-no-p \"Do you want another solution ? \")
then (focus SEARCH)
else (modify ?f (level 0) (state blocked)) ))
")
)
(modify ?pb (state in-progress))
)


(defrule MAIN::analysis
?f <- (pb (state in-progress))
=>
(modify ?f (state new-depth))
(focus SEARCH PROPAG SEARCH MAIN)
)

(defrule MAIN::save-solution
; if all the variables have got a value at the deapest level of the search
; then save the solution in a list of bindings (<variable> <value>)
(declare (salience 10))
(level_search ?n)
(not (level_search ?n1&:(> ?n1 ?n)))
(forall (var (name ?x))
(var (name ?x)(value ?v&~nil)))

(var (name ?x) (value ?val&~nil))
?s <- (solution (var-val $?list&:(not (member$ ?x $?list))))
?f <- (pb (level ?n))
=>
(modify ?s (var-val (insert$ $?list 1 (create$ ?x ?val))))
(modify ?f (state solved))
)

(defrule MAIN::no-more-solution
(declare (salience 10))
(level_search 0)
?f <- (solution (number ?nb) (var-val))
(pb (state blocked) (level 0))
=>
(if (= ?nb 1) then (printout t "I found no solution" crlf)
else (printout t "No more solution" crlf crlf)
(retract ?f)
(printout t "I found " (- ?nb 1) " solution(s)" crlf crlf)
)
)


(defrule MAIN::print-solution
; the default printing method
(pb (state blocked) (level 0))
(solution (number ?n) (var-val $?list&:(> (length$ $?list) 0)))
=>
(printout t crlf "Solution number " ?n " : " crlf)
(bind ?length (length$ $?list))
(bind ?i 1)
(while (< ?i ?length) (printout t (nth$ ?i $?list) " : " (nth$ (+ ?i 1) $?list) crlf) (bind ?i (+ ?i 2)))
)

; add the following rule if you have specific printing rules in the PROPAG ; module

;(defrule MAIN::to_customized_printing
;; branch to rules for specific printing in the PROPAG module
; (declare (salience -10))
; (pb (state blocked)(level 0))
;=>
; (printout t crlf crlf)
; (focus PROPAG)
;)


;################# MODULE SEARCH ####################################


(defmodule SEARCH
(import MAIN deftemplate ?ALL))


(defrule SEARCH::generate-new-depth
(level_search ?n)
(not (level_search ?n1&:(> ?n1 ?n)))
?f <- (pb (level ?n) (state new-depth))
=>
(duplicate ?f (level (+ ?n 1)) (state choice-var)(current-hypothesis nil))
(assert (level_search (+ ?n 1)))
)


(defrule SEARCH::choice-var-val
; make an hypothesis at a new level of the search. Choose the most constrained
; variable (i.e. the ones which has the less possible values) and choose a value among
; its possible values (the first available in the list...we should improve this choice !!)
(logical (level_search ?n))
?g <- (pb (level ?n)(state choice-var)(current-hypothesis nil))
?f <- (var (name ?x) (level ?x1) (value nil) (possible-values $?nb1))
(not (var (name ?x) (level ?x2&:(> ?x2 ?x1))) )
(forall (and (var (name ?y&~?x) (value nil)(level ?m))
(not (var (name ?y) (level ?m1&:(> ?m1 ?m)))))
(var (name ?y)(level ?m)(possible-values $?nb2&:(>= (length$ ?nb2) (length$ $?nb1)))))

=>
(modify ?g (state in-progress) (current-hypothesis ?x))
(duplicate ?f (level ?n) (value (nth$ 1 $?nb1))(possible-values (rest$ $?nb1)))
(focus PROPAG)
)



;.Examine the current state : forced instanciation or impasse or backtrack

(defrule SEARCH::instanciation
; if a not yet instanciated variable has only one possible value then provide it with this value
; then set the focus to PROPAG for evaluating the consequences of this forced instanciation
; then return to SEARCH
(logical (level_search ?n))
?f <- (var (name ?x) (level ?n) (value nil) (possible-values $?list&:(= (length$ $?list) 1)))
(pb (state in-progress) (level ?n))
=>
(modify ?f (value (nth$ 1 $?list))(possible-values))
(focus PROPAG SEARCH)
)

(defrule SEARCH::impasse
; if there exists a not yet instanciated variable which has no more possible values then you got an impasse
(declare (salience 10))
(logical (level_search ?n))
?pb <- (pb (level ?n) (state in-progress))
(exists (var (level ?n)(value nil) (possible-values)))
=>
(modify ?pb (state blocked))
)

(defrule SEARCH::backtrack-on-value
; if the problem solving process is blocked with the current hypothesis ?x
; or if we are looking for another solution, we have to choose another value for
; the hypothesis.
; We stay at the same level of search but BE CAREFUL !!! we have to delete all the facts
; depending on the current value of the hypothesis ?x
; thanks to the logical dependencies it suffices to retract the fact ?s
; then to restore it (with a new time-tag)
?s <- (level_search ?n)
?pb <- (pb (level ?n) (state blocked|solved) (current-hypothesis ?x))
?var <- (var (name ?x) (level ?n) (value ?v&~nil) (possible-values $?list&:(<> (length$ $?list) 0)))
=>
(retract ?s)
(assert (level_search ?n))
(modify ?var (value (nth$ 1 $?list))(possible-values (rest$ $?list)))
(modify ?pb (state in-progress))
(focus PROPAG)
)

(defrule SEARCH::backtrack-on-variable
; if the problem solving process is blocked and no other value is available for the
; current hypothesis then we have to return to a previous level of the search
; where the problem solving process was not blocked. The next step will be the choice of another
; value for the current hypothesis of this previous level
?s <- (level_search ?n)
?pb <- (pb (level ?n) (state blocked|solved)(current-hypothesis ?x))
?pbbis <- (pb (level ?m&:(= ?m (- ?n 1))) (state ~blocked))
?var <- (var (name ?x) (level ?n) (possible-values $?list&:(= (length$ $?list) 0)))
=>
(retract ?s)
(retract ?pb)
(retract ?var)
(modify ?pbbis (state blocked))
) 