#ifndef MASTER_DAEMON
#define MASTER_DAEMON

#include <msgpack.hpp>

/*! \brief masterDaemon
 *         server core.
 *
 *  Contains the data layer and the XMLRPC API.
 */

#ifdef MD_CORE

class masterDaemon *thisService;

#else

extern class masterDaemon *thisService;

#endif

using boost::asio::ip::udp;


class masterDaemon : public mdProcess,
                     public Listener<mdAttention>, 
                     public Listener<mdCDPulse>, 
                     public Listener<mdClientBirth>, 
                     public Listener<mdClientDeath>, 
                     public Listener<mdIncoming>,
                     public Listener<mdResponse>,
                     public Listener<mdTelemetryFrame>,
                     public Listener<mdDeviceCommand> {
public:
 
    bool                                  shuttingDown;

    boost::asio::io_service                        io_;

    int  arCycles,
         dataClients[MAX_DATACLIENTS],
         instruments[MAX_INSTRUMENTS],         
         nClievers,                       
         sentCommands;

   masterDaemonConfig                             *cfg;
   mdDGChannel                                 *bg,*fg;   

   std::string                   clievers[MAX_CLIEVER];

   masterDaemon();
  ~masterDaemon() {}

   masterDaemon(masterDaemonConfig *cmdCfg) { int  i;
     thisService     = this;
     cfg             = cmdCfg;
     nClievers       = 0;
     shuttingDown    = false;
     memset(dataClients,0,sizeof(dataClients));
     memset(instruments,0,sizeof(instruments));
   }
  
    int              getDeviceHandle(int deviceMajor,std::string &deviceMinor) {}; 
    int              initBaseAPI(void);
    int              initDataLayer(void);
    int              releaseDevice(int handle) {return( -1);}
    int              validateHandleForCmds(int handle) {return(-1);}
    void             dispatch(mdWQitem*);
    void             dispatch(const mdIncoming&);    
    void             listen();
    xmlrpc_c::value* fetchCommands(std::string subSystem) {};

    virtual void processEvent(const mdAttention &ev);
    virtual void processEvent(const mdCDPulse &ev);
    virtual void processEvent(const mdClientBirth &ev);
    virtual void processEvent(const mdClientDeath &ev);
    virtual void processEvent(const mdIncoming &ev);
    virtual void processEvent(const mdResponse &ev);
    virtual void processEvent(const mdTelemetryFrame &ev);
    virtual void processEvent(const mdDeviceCommand &ev);
  
    void  run();

};

#endif
