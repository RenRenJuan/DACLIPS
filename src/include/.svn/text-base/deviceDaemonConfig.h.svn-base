#ifndef DEVICE_CONFIG
#define DEVICE_CONFIG

using namespace boost::gregorian; 
using namespace boost::posix_time;

class deviceDaemonConfig { 
public:

  bool                      cdConnected,terminateRequest,yield;
  char                      configPath[256],logPath[256],work[32];
  date                      epoch(MD_EPOCH);
  int                       debugThreshold,
                            telemetryPort;      // talks to central server with this
  md_device                 thisDeviceType;     // must be MACHINE or MDDEV_INSTRUMENT
  std::string               cdAddress;
  unsigned short            cdPort;
  std::string               mdAddress;
  std::string               mdPort;
  std::string               deviceName;         // the distinguishing name of this particular device
  std::string               telemetryPortStr;

  deviceDaemonConfig() { cdConnected      = terminateRequest = yield = false;
                         mdAddress        = std::string(MD_DEFAULT_IP);
                         debugThreshold   = MAX_DEBUG;
                         thisDeviceType   = MACHINE; // Change for optics, other instruments.
                         deviceName       = (thisDeviceType == MACHINE) ?  std::string(MD_TYPE) : std::string("INSTRUMENT");
#ifdef _WIN32_WINNT
                         strcpy(configPath,".\\");
                         strcpy(logPath,"c:\\openauc\\logs");
#else
                         strcpy(configPath,"./");
                         strcpy(logPath,"/tmp");                         
#endif
                         telemetryPort    = 4242;
                         sprintf(work,"%d",telemetryPort);
                         telemetryPortStr = std::string(work);
                       }

  int loadMachineConfiguration();

};

#endif
