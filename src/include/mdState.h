#ifndef MD_STATE
#define MD_STATE

/*! \brief mdState
 *         Root class of Data Model.
 *
 *  mdState applies the State pattern (GoF p. 305).
 */

typedef struct {
  bool             bitValue;
  double           realValue;
  int              intValue;
  bool             hasSource;                
  bool             realtime;                 // if true data layer can update
  char             referenceType;            // uses XMLRPC-C signature conventions
  unsigned short   sValSize;
  char             sVal;
}
 mdODEPOD;

class mdOperationalDataElement {
  time_t           datetimeValue;
 public:
  mdODEPOD        *ode;
  void            *mand;
  std::string      stringValue;

  void             set(int value)            {ode->intValue     = value;}
  void             set(std::string value)    {stringValue       = value;}
  void             set(double value)         {ode->realValue    = value;}
  void             set(bool value)           {ode->bitValue     = value;}
  void             set(time_t value)         {datetimeValue     = value;}
  int              getInt()                  {return ode->intValue;}
  double           getReal()                 {return ode->realValue;}
  std::string      getString()               {return stringValue;}
  bool             getBit()                  {return ode->bitValue;}
  time_t           getTime()                 {return datetimeValue;}

#ifdef MD_MAND
  DACLIPS::Fact    *fact;
#endif

  unsigned short   pack(char *framePtr);
#ifndef INCLDV
  void             source(mdResponse *mdr);
#endif
  void             unpack(char **framePtr);

                   mdOperationalDataElement();
                   mdOperationalDataElement(mdODEPOD *shared);
                  ~mdOperationalDataElement() {}
};

typedef std::map<std::string, mdOperationalDataElement>  ODEsByName;

class mdState {
public:

  int                      deviceType; 

  mdOperationalDataElement deviceODE;
  mdObservable             deviceObservation;

  mdState()  {observables[std::string("device")] = deviceObservation;
              localODEs[std::string("_device")]  = deviceODE;
             }

  ~mdState() {}
  std::string         create(int deviceHandle,std::string& sigNComment,std::string &dataName);

#ifdef XMLRPC_C
  xmlrpc_c::value  *  get(int deviceHandle,std::string &dataName);
  std::string         set(int deviceHandle,xmlrpc_c::cstruct &inbound);
  void                registerData(const char *dataName,const mdIncoming &thisOne);
#endif

  ObservablesByName   observables;
  ODEsByName          localODEs;

};

#endif
