#ifndef MD_OBSERVABLES
#define MD_OBSERVABLES

class mdResponse;
 
using namespace boost::gregorian; 
using namespace boost::posix_time;

class observable_time : time_period {

public:
  ptime         instantiated; // Time the observable was created as an object.
  time_duration    duration1; // e.g. inner bound for an interval 
  time_duration    duration2; //  ""  outer   ""   ""
  ptime               event1; // e.g. start of an interval
  ptime               event2; //  ""  end     ""   ""

  observable_time(date d) : time_period(ptime(d),ptime(d,microseconds(1000)))
  {
  instantiated = second_clock::local_time();
  }

  void setEventTolerance();
  void setEventStart();
  void setEventEnd();

};

typedef struct {
  char                   focusType;   // i, d, or s     
  md_units               units;        
  bool                   hasBounds;
  bool                   hasSource;
  bool                   isPrivate;   // true -> only owning device can access
  bool                   realtime;    // if true datalayer can update this
  bool                   outOfLimits;                  
  double                 rValue;                    
  double                 rValueTarget;
  double                 rValueHigh;
  double                 rValueLow;
  int                    intValue;
  int                    intValueTarget;
  int                    intValueLow;
  int                    intValueHigh;
  unsigned short         sValSize;
  char                   sVal;
} mdObsPOD;

/*! \brief mdObservable
 *         Low level Data Encapsulation.
 *
 *  Each actual data item named in xxxx corresponds to a single instance.
 *  The items corresponding to the Phase I specification are created 
 *  when device 0 connects. Any device may create subsequently create
 *  additional items as needed.
 */
  
class mdObservable {
  time_t                 lastChange;
  observable_time        ot(date());
  bool                   _shared;
public: 
  mdObsPOD              *obs;
  void                  *mand;
  std::string            sValue;

                          mdObservable();
                          mdObservable(mdObsPOD *sharedMem);
                         ~mdObservable() {}
  std::string             create(int deviceHandle,std::string& sig,std::string& dataname);
  unsigned short          pack(char *framePrt);
#ifndef INCLDV
  void                    source(mdResponse *mdr);
#endif
  void                    unpack(char **framePtr);
#ifdef XMLRPC_C
  xmlrpc_c::value        *shipIt(xmlrpc_c::cstruct outbound,std::string name);
  std::string             setWith(xmlrpc_c::cstruct incoming);
#endif

};

typedef std::map<std::string,mdObservable>  ObservablesByName;

#endif
