#ifndef CLIEVER_CONFIG
#define CLIEVER_CONFIG

using namespace boost::gregorian; 
using namespace boost::posix_time;

class mdDataSource {

   bool         enabled;
   std::string fullName;
   int             port;
   int               ip;

};

typedef std::map<std::string,mdDataSource*> localSourcesByClaimedName;

class clientDaemonConfig { 
public:

  bool                      runCommander;
  bool                      terminateRequest;
  char                      configPath[256],logPath[256],origCmd[32];
  pid_t                     clipsProcess;
  pid_t                     daemonProcess;
  pid_t                     shellProcess;
  std::string               mdAddress;
  std::string               deviceName;
  std::string               telemetryPortStr;
  int                       cluster,        
                            debugThreshold,
                            instruments[MAX_INSTRUMENTS];                        
  int                       telemetryPort;      // talks to central server with this
  date                      epoch(CD_EPOCH);
  localSourcesByClaimedName localDevices;

  clientDaemonConfig() { terminateRequest = false;
                         mdAddress        = std::string(MD_DEFAULT_IP);
                         strcpy(configPath,"./");
                         deviceName       = std::string("TEST");
                          debugThreshold  = MAX_DEBUG;
                         strcpy(logPath,"/tmp");                         
                         runCommander     = true;
                         memset(instruments,0,sizeof(instruments));
                       }

  int loadMachineConfiguration();

};

typedef 
struct CD_GLOBAL {
   char                            id[7];    
   pid_t                      daemon_pid;
   bool                     cmdrShutdown;
   bool                         graceful;
} 
 auc_cd_global;

#endif
