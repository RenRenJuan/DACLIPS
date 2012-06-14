//#include "stdafx.h"
#include <cassert>
#include <cstdarg>
#include <cstdlib>
#include <iostream>
#include <boost/thread.hpp>
#include <boost/asio.hpp>
#include <boost/bind.hpp>
#include <boost/date_time/posix_time/posix_time.hpp>
#include <boost/interprocess/shared_memory_object.hpp>
#include <boost/interprocess/mapped_region.hpp>


#include "Listener.h"
#include "EventSender.h"
#include "TimeStampedEvent.h"
#include "PolymorphEvent.h"
 
#include <map>
#include <utility>
#include <map>
#include <string>
#include <queue>

#define  DEVICE

class dvDataLayer;
class mdEmbedded;
bool  aucDevice();

#include "mdcommon.h"  

#define DV_NAME             "OpenAUC Embedded"
#define DV_VERSION          "1.0"

#ifdef _WIN32_WINNT
#include <SDKDDKVer.h>

#ifdef DV_DLL_MAIN

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
                                         )
{
  BOOL rc=TRUE;

        switch (ul_reason_for_call)
        {
        case DLL_PROCESS_ATTACH:
             rc=aucDevice();
             break;
        case DLL_THREAD_ATTACH:
        case DLL_THREAD_DETACH:
        case DLL_PROCESS_DETACH:
             break;
        }
        return rc;
}

#endif

#else  
#define DllExport
#define APIENTRY
#endif

#include "mdBehavior.h"
#include "mdObservable.h"
#include "mdState.h"

#include "deviceDaemonConfig.h"
#include "dvLogger.h"

// Sum of below should not exceed MAX_FRAMESIZE in telemetry.h

#define N_OBSERVABLES 80
#define N_ODES        20

typedef 
struct DV_TELEMETRY_DATA {
   char                                   id[16]; // "auc_dv_global"  
   int                                nObs,nODEs;
   std::string                obs[N_OBSERVABLES];
   std::string                      odes[N_ODES];
   mdObsPOD          observations[N_OBSERVABLES];
   mdODEPOD                      opsdata[N_ODES];
} 
 auc_dv_global;

typedef std::map<std::string,mdObservable *>              ObservationsByName;
typedef std::map<std::string,mdOperationalDataElement *>  ODEsPerName;

class dvQueryMD;
class dvIncoming;

typedef struct {
  dvQueryMD        *call;
  dvIncoming   *response;
}
 mdDialog;

class DllExport mdEmbeddedAPI;

#ifdef DV_DLL
#ifdef DV_DLL_MAIN

         auc_dv_global              *gm;
         boost::asio::io_service    io_;
         boost::thread             *bgThreadGroup;
         boost::thread             *dataLayer;
         dvLogger                   theseLogs;
         deviceDaemonConfig        *thisConfig;
         mdDialog                   thisCmdQry;
         mdDialog                   thisObsQry;
         mdDialog                   thisODEQry;
         mdEmbedded                *thisDevice;
         mdError                   *mdErrors;
         mdEmbeddedAPI             *mdDDAPI=NULL;

  extern void runDeviceDaemon();
  extern void shutdown();

         InstructionSet             mySCPI;
         ObservationsByName         myObs;
         ODEsPerName                myODEs;

#else

  extern auc_dv_global             *gm;
  extern boost::asio::io_service    io_;
  extern boost::thread             *bgThreadGroup;
  extern boost::thread             *dataLayer;
  extern dvLogger                   theseLogs;
  extern deviceDaemonConfig        *thisConfig;;
  extern mdDialog                   thisCmdQry;
  extern mdDialog                   thisObsQry;
  extern mdDialog                   thisODEQry;
  extern mdEmbedded                *thisDevice;
  extern mdError                   *mdErrors;
  extern mdEmbeddedAPI             *mdDDAPI;

  extern InstructionSet             mySCPI;
  extern ObservationsByName         myObs;
  extern ODEsPerName                myODEs;

#endif

#include "dvEvents.h"
#include "deviceDaemon.h"

#endif
 
#ifdef DV_DRV
#ifdef DV_DRV_MAIN

         auc_dv_global              *gm;
         dvLogger                   theseLogs; // Only 1 here but shared
         mdError                   *mdErrors;
         mdEmbeddedAPI             *mdDDAPI=NULL;

         ObservationsByName         myObs;
         ODEsPerName                myODEs;

#else
// As distributed the device driver program is a 
// single source module but the following provided for convenience.

 extern  auc_dv_global              *gm;
 extern  dvLogger                   theseLogs; // Only 1 here but shared
 extern  mdError                   *mdErrors;
 extern  mdEmbeddedAPI             *mdDDAPI=NULL;
 extern  ObservationsByName         myObs;
 extern  ODEsPerName                myODEs;

#endif
#endif

#ifdef DV_DLL
class DllExport mdEmbeddedAPI {
#else
class           mdEmbeddedAPI {
#endif
public:

  std::string mdAddress;
  std::string mdPort;
  std::string cdAddress;
  std::string cdPort;

  bool          *cdConnected, shutdown;
  boost::thread *data_layer,*telemetry;
  
  int mdHeartbeat, telemetryRefresh;

  mdEmbeddedAPI(const char *ma, const char *mp, const char *ca, 
                const char *cp) : mdAddress(ma), mdPort(mp), cdAddress(ca), cdPort(cp)
  { mdHeartbeat = MD_HEARTBEAT; telemetryRefresh = MD_REFRESH; 
    shutdown    = false;  
    data_layer  = telemetry = NULL;
  };

void                      mdCmdResult(int mdErrCode);
int                       mdRegisterCommandCallback(void (f)(char *,char *),const  char *canonicalSCPI);
mdOperationalDataElement *mdRegisterODE(const char *name);
mdObservable             *mdRegisterObservable(const char *name); 
bool                      mdResume();
bool                      mdYield();
void                      setSingleton(auc_dv_global *sm);
dvLogger                 *log;
};


