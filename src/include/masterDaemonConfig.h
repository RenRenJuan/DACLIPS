#ifndef MD_CONFIG
#define MD_CONFIG

typedef struct MDCLIENT {
  md_device     devType;
  int       mdStdDevIdx;
} mdLiveClient;


typedef std::map<int,mdLiveClient*>       ClientsByHandle; 
typedef std::map<int,mdDataClient*>   DataClientsByHandle;
typedef std::map<int,mdInstrument*>   InstrumentsByHandle;

class masterDaemonConfig {

  friend class mdState;

public:

  bool                           daemonized; 
  bool                                 halt;
  bool                         shuttingDown;
  bool                             shutdown;
  const char     *configPath,**err,*logPath,
                             *xmlrpcLogpath;
  mdClientServer      *cliever[MAX_CLIEVER];
  mdMachine           *machine[MAX_CLIEVER];

  ClientsByHandle                allClients;
  DataClientsByHandle               clients;
  InstrumentsByHandle           instruments;
                     
  date                      epoch(MD_EPOCH);
  int     debugThreshold,nClients,nClievers,
           telemetryPort,thisMachineContext,  
                                 xmlrpcPort;
  pid_t         daemonProcess, shellProcess;
  std::string             cfg_path,log_path;
  std::string         clievers[MAX_CLIEVER];

  masterDaemonConfig();

  int         loadMachineConfiguration(int machineClass);

  xmlrpc_env  xmlrpc_c;
  xmlrpc_c::registry api_registry;

};

#endif
