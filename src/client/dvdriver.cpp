/*
 * Stub driver for development of specific
 * personality of an OpenAUC/GDOLMS embedded
 * device interface. Uses mddevice.dll/.so
 * to communicate with the rest of the system.
 * 
 * This example is written as a command line
 * program but I expect most of the code for
 * a production device would be in a DLL.
 *
 * All of the facilities of the embedded MD
 * client are exercised here so it's simply
 * a matter of adding specific data feeders
 * and command processors.
 *
 */

#define DV_DRV
#define DV_DRV_MAIN


 int nObs,nODEs,nSCPI;

#include "md_device.h"

using namespace boost::interprocess;
using namespace std;

#ifndef _WIN32_WINNT
void setSignals();
void signal_handler(int);
#endif

int problem=OK;

void additionalUserMsgs() {

    // stub to add user error msgs

    mdErrors->additionalUserMsg(1000,"Replace me with your text");

}
void stubCmdProcessor(char *cmd,char *fullText) {

   int rc = OK; // from a value set in additionalUserMsgs

    // cmd contains the registered command, fullText the complete text of the sent command.
    // when done processing, the command processor must use mdCmdResult and set rc if any
    // exceptions need to be relayed back to the MD system.
   
   mdDDAPI->mdCmdResult(rc);

}
bool regMySCPI() {

  int    rc=OK;

  if (!rc) { rc=mdDDAPI->mdRegisterCommandCallback(stubCmdProcessor,"RST"); nSCPI++; }
  // Repeat above for each command this device can handle

  if (rc) mdDDAPI->log->logN(1,"Error registering cmd cb: %s.",mdErrors->what());

  return (rc == OK);

}
int regMyData() {

  bool doConfTests=false,rules=false; // Set this to true if rule based operation in effect.
  mdObservable             *obs=NULL; // i.e. if the MD was started with 'auc-kb' not 'auc-md'.
  mdOperationalDataElement *ode=NULL;
  int                          rc=OK; 

  // "device" and "_device" are are predefined for every normal device 
  // (the MD, CD, and data clients excluded). If the OpenAUC MD server
  // is auc-kb then the additional ones below are predefined in the 
  // knowledgebase. They can also be defined thru a data client using
  // XMLRPC. Attempts to register a data element not predefined for
  // the device will fail.
  

  if (doConfTests) {

   if (obs=mdDDAPI->mdRegisterObservable("bogus"))
   {mdDDAPI->log->logN(0,"MD accepted an invalid observation.");
    goto done;
   }
   if (ode=mdDDAPI->mdRegisterODE("_bogus"))
   {mdDDAPI->log->logN(0,"MD accepted an invalid operational datum.");
    goto done;
   }
   mdDDAPI->log->logN(0,"Data Element registration API tested OK.");
  
  }

  if (!obs && (obs=mdDDAPI->mdRegisterObservable("device")))      {myObs["device"] = obs; nObs++;}
  if (rules) {
  if  (obs && (obs=mdDDAPI->mdRegisterObservable("pressure")))    {myObs["pressure"] = obs; nObs++;}
  if  (obs && (obs=mdDDAPI->mdRegisterObservable("temperature"))) {myObs["temperature"] = obs; nObs++;} 
  // Repeat above line for each observation
  }
  if (!obs) mdDDAPI->log->logN(1,"Error registering observable: %s.",mdErrors->what());
  
  if (!ode && (ode=mdDDAPI->mdRegisterODE("_device")))            {myODEs["_device"]   = ode; nODEs++;}
  if (rules) {
  if (!ode && (ode=mdDDAPI->mdRegisterODE("_powered")))           {myODEs["_powered"]  = ode; nODEs++;}
  if  (ode && (ode=mdDDAPI->mdRegisterODE("_spinning")))          {myODEs["_spinning"] = ode; nODEs++;}
  }
  // Repeat above line for each non-observational data element

  if (!ode) mdDDAPI->log->logN(1,"Error registering ODE: %s.",mdErrors->what());

  rc = (ode != NULL && obs != NULL);

  done: return rc;

}
int 
main(int           const argc, 
     const char ** const argv) 
{
#ifndef _WIN32_WINNT
    setSignals();
    aucDevice();
#endif
    mdError stub;
    stub.get(&mdErrors);
    additionalUserMsgs();
    nObs = nODEs = nSCPI = 0;

   // Construct shared memory for data elements produced on this host.
   // Provide standard RAII constructor/destructor:

   struct shm_remove 
   {
     shm_remove()  { shared_memory_object::remove("auc_dv_global"); }
     ~shm_remove() { shared_memory_object::remove("auc_dv_global"); }
   } remover;

  shared_memory_object shm(create_only, "auc_dv_global", read_write);
  shm.truncate(sizeof(auc_dv_global));    
  mapped_region dv_telemetry_frame(shm, read_write);
  memset(dv_telemetry_frame.get_address(), 0, dv_telemetry_frame.get_size());
  gm = (auc_dv_global *)dv_telemetry_frame.get_address();
  // Below will segfault if there is a problem so catches are futile.
  // Debug by catching any SIGSEGVs in a debugger.
  strcpy(gm->id,"auc_dv_global");
  strcmp(gm->id,"auc_dv_global"); 

   // Construct the md_device.dll object exactly once in any process.

    mdEmbeddedAPI thisMDEmbedding =
    mdEmbeddedAPI( // logPath removed - c:\openauc\logs must pre-exist.
   // The host names can be defaulted to their mdcommon.h values by specifying 
   // empty strings here, but the ports must be specified, 4242 being the common value
   // Values set below are those for the current "staging" environment. 
                  // "", "4242", "", "4242" );                // Use defaults
                  "67.223.227.29",   "4242",   // md ip,port
                  "208.109.106.127", "4242");  // cd "
   
   /* the MD thread group runs independently of this one
      from this point, but in the process context of this
      function, anchored to this block context.
   */

   thisMDEmbedding.setSingleton(gm);
   mdDDAPI = &thisMDEmbedding;

   // Devices are clustered with the CD so it needs to be connected to proceed.

   while (!*mdDDAPI->cdConnected) {
     boost::system_time const alarum=boost::get_system_time() + boost::posix_time::seconds(5); // adjust as needed
     boost::this_thread::sleep(alarum);
   }

   /* The commands and data elements which this device can handle/originate
      can be changed in realtime but not at this level of the system. So MD
      must know that the device can field the command or data before the 
      device registers to do so or the attempt to register will fail.
 . */

   mdDDAPI->log->logN(0,"Registering data and SCPI for this device.");
   if (regMyData() && regMySCPI())
        mdDDAPI->mdResume();
   else exit(problem);
   
   /* At this point the device is connected to the system and
      registered for the commands and data it can handle. All 
      further work will be done by the md_device.dll threads,
      the SCPI commands using the registered callbacks and the
      dataLayer sending telemetry frames with values collected
      from the common system shared memory in which the data
      elements have been placed. Updates to the Observables and
      ODEs could be done in this thread but it would be
      better to do so in another process or processes which get
      access to the shared memory and updates it independently of
      this process or at least the thread of this block (i.e. 
      dvdriver.main (or whatever this source module is transformed
      into in an actual device)) context. Any process on the
      machine can obtain access to the data elements in the same
      way as this one does.

      The shared memory is only defined in the lifetime of this
      block so it cannot exit until the md_device.dll interface
      is no longer needed.

      Use the maps myObs and myODEs anytime while this process
      is active to set values of data elements. Besides the unix
      stuff, the command and data element registration and the
      process anchoring below can be removed to start a new
      stub process which will define DV_DRV but not DV_DRV_MAIN.
      The mdDDAPI object should be created with a default
      constructor (no parameters) and the setSingleton method
      must be executed in order for the new process to have
      access to myObs and myODEs. Yield and Resume can be 
      executed in any process.
      
    */

   bool dlt = mdDDAPI->data_layer->joinable(),
         tt = mdDDAPI->telemetry->joinable();

   if (dlt && tt)
   {
       mdDDAPI->log->logN(3,"%d observations, %d operational variables, %d SCPI commands registered with MD",nObs,nODEs,nSCPI);
       mdDDAPI->data_layer->join();
       mdDDAPI->telemetry->join();
   }
   else mdDDAPI->log->logN(0,"Initialization failed, process ends.");
   mdDDAPI->log->logN(0,"MD Device Interface EOJ.");

}
#ifndef _WIN32_WINNT
void setSignals() {

    signal(SIGCHLD,SIG_IGN);            /* ignore child */ 
    signal(SIGTSTP,SIG_IGN);            /* ignore tty signals */ 
    signal(SIGTTOU,SIG_IGN);            // both input
    signal(SIGTTIN,SIG_IGN);            //  and output
    signal(SIGSEGV,signal_handler);
    signal(SIGUSR1,signal_handler);     // commander log messages
    signal(SIGUSR2,signal_handler);     // reserved
    signal(SIGHUP,signal_handler);      /* catch hangup signal */
    signal(SIGTERM,signal_handler);     /* catch kill signal   */

}
void signal_handler(int sig)
{
   switch(sig) {
        case SIGSEGV:
                break;
        case SIGUSR1: 
                break;
        case SIGUSR2: 
                break;
	case SIGHUP:
		mdDDAPI->log->logN(0,"hangup signal caught, currently auc-md ignores this.");
		break;
	case SIGTERM:
		mdDDAPI->log->logN(0,"terminate signal caught, auc-md will shutdown.");
		exit(0);
		break;
   }
}
#endif 
