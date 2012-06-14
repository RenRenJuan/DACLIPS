#define  CD_MAIN
#include "auc-cd.h"

#include <stdio.h>
#include <fcntl.h>
#include <signal.h>
#include <unistd.h>

      bool cdHasKb;
      char cdOrKbValue;
const char *cdOrKb=&cdOrKbValue;

using namespace std;

/*
 * This is the shell for the Unix Client Server (Cliever) daemon.
 * There is a different shell for the Windows Service.
 *
 */
       void          runCommander();
       void          setSignals();
       void          signal_handler(int);
       void          usage();

using namespace boost::interprocess;
using namespace std;

void aucClientServer() { // AKA "Cliever"

 int  i,lfp;
 char str[10];

    thisConfig->daemonProcess = fork();
    if (thisConfig->daemonProcess < 0) {
        puts("Can't initialize process!");
        exit(1);
    }
    if (thisConfig->runCommander && getpid() == thisConfig->shellProcess) 
       {setSignals(); runCommander();}
    setsid(); /* obtain a new process group */
    i=open("/dev/null",O_RDWR); dup(i); dup(i); /* handle standard I/O */
    umask(027);                                 /* set newly created file permissions */
    chdir(RUNNING_DIR); /* change running directory */
    lfp=open(CD_LOCK_FILE,O_RDWR|O_CREAT,0640);
    if (lfp<0) {puts("Can't open lockfile!");  exit(1);}
    if (lockf(lfp,F_TLOCK,0)<0)
               {puts("Can't lock lockfile!");  exit(0);}
    shared_memory_object shm(open_only, "auc-cd-global", read_write);
    mapped_region aucCDglobal(shm, read_write);
    gm = (auc_cd_global *)aucCDglobal.get_address();
    if (strcmp(gm->id,"auc-cd"))  // Same deal
    {theseLogs.logN(0,"Daemon couldn't identify global memory. Bye."); exit(1);}
    gm->daemon_pid = getpid();
    sprintf(str,"%d",getpid());
    theseLogs.logN(1,"auc-cd running (%s)",str);
    strcat(str,"\n");
    write(lfp,str,strlen(str));         /* record pid to lockfile */ 
    setSignals();

    theseLogs.init("auc-cd");
    theseLogs.logN(0,CD_NAME " " CD_VERSION " compiled on " __DATE__ " @ " __TIME__); 
    theseLogs.logN(3,"Cliever processing(%d) begins for devices on port %s to MD at %s.",getpid(),thisConfig->telemetryPortStr.c_str(),thisConfig->mdAddress.c_str());    

    if (cdHasKb) {
         thisConfig->clipsProcess = fork();
         if (thisConfig->clipsProcess < 0) {
             puts("Can't initialize CLIPS--!");
            exit(1);
         }
     if (getpid() != gm->daemon_pid) { 
#if defined(MD_MAND)
         theseLogs.logN(0,"Creating CLIPS Environment.");
         DACLIPS::init();
#endif
      }
     }

    try { 

       boost::thread cliever(runCliever);
       boost::thread dataLayer(runDataLayer);

       if (!dataLayer.joinable() || !cliever.joinable()) {
            if (!dataLayer.joinable())
               theseLogs.logN(0,"Failed to start data layer, auc-cd process will terminate.");
            if (!cliever.joinable())
               theseLogs.logN(0,"Failed to start client-server, auc-cd process will terminate.");
            }
       else {
             theseLogs.logN(0,"Cliever started OK.");
             dataLayer.join();
             theseLogs.logN(0,"auc-cd EOJ.");
            }

    }
    catch (std::exception &e)
    {
      theseLogs.logN(1,"Exception: %s",e.what());      
    }
    catch (...) {
      theseLogs.logN(0,"General fault.");
    }

    exit(thisCliever->rc); 

}
int main(int  const argc, const char ** const argv)
{
  const char *exeName,*banner = "\n" CD_NAME " "  CD_VERSION " compiled on " __DATE__ " @ " __TIME__ " (%d)\n";
  int mthParm, rc = OK;

  thisCliever = NULL;
 
  cdHasKb     = strstr(argv[0],"clips") ? true : false;
  cdOrKbValue = cdHasKb ? 'd' : 'D'; // d == kb enabled, D = !d

  //RAII constructor/destructor
  struct shm_remove 
  {
    shm_remove() { shared_memory_object::remove("auc-cd-global"); }
   ~shm_remove() { shared_memory_object::remove("auc-cd-global"); }
  } remover;

  shared_memory_object shm(create_only, "auc-cd-global", read_write);
  shm.truncate(CD_GLOBAL_SIZE);    
  mapped_region aucCDglobal(shm, read_write);
  memset(aucCDglobal.get_address(), 0, aucCDglobal.get_size());
  gm = (auc_cd_global *)aucCDglobal.get_address();
  strcpy(gm->id,"auc-cd");
  strcmp(gm->id,"auc-cd"); // Will segfault if there is a problem so catches are are futile.
                           // But the signal trap will catch the fault.

  thisConfig = new clientDaemonConfig();
  thisConfig->shellProcess = getpid();
  strcpy(thisConfig->origCmd,argv[0]);

  if (argc < 2 || argc > 7) usage();

  thisConfig->telemetryPort = atoi(argv[1]);    
  if (thisConfig->telemetryPort < 1000 || thisConfig->telemetryPort > 65535)
  {
      std::cerr << "The <telemetry-udp-port> value is invalid.\n";
      exit(1);
  }
  thisConfig->telemetryPortStr = std::string(argv[1]);
  for (mthParm=2;mthParm < argc;mthParm++) {      
     if (*argv[mthParm] == '*') {
          thisConfig->runCommander = false;
      }
      else
      if (!strncmp(argv[mthParm],"device=",7)) {
          thisConfig->deviceName = std::string(argv[mthParm]+8);
      }
      else
      if (!strncmp(argv[mthParm],"logs=",4)) {
          strcpy(thisConfig->logPath,argv[mthParm]+5);
      }
      else
      if (!strncmp(argv[mthParm],"mdIP=",4)) {
          thisConfig->mdAddress  = std::string(argv[mthParm]+5);
      }    
      else usage();  
   }

   if (thisConfig->runCommander) printf(banner,thisConfig->shellProcess); 
   aucClientServer();
   while(!gm->graceful) sleep(2);

}
void runCommander() {

   char         msg[128];
   int                 i;
   mdCommander commander;

   theseLogs.init("auc-cd-ui");
   theseLogs.logN(0,"Interactive command processor started.");
   commander.driver();
   if (thisConfig->terminateRequest) {
       theseLogs.logN(0,"Interactive shutdown requested.");
       puts("auc-cd operator issued terminate command.");
       kill(gm->daemon_pid,SIGTERM);
   } else {
       theseLogs.logN(0,"Interactive command processor ended.");
       sprintf(msg,"Commander terminated, auc-cd continues (%d).",gm->daemon_pid);
       puts(msg);
          }

   theseLogs.logN(1,"Closing out I/O for shell process (%d)",thisConfig->shellProcess);
   for (i=getdtablesize();i>=0;--i) close(i);  /* close all descriptors */  

   exit(0);

}
void setSignals() {

    signal(SIGCHLD,SIG_IGN);            /* ignore child */ 
    signal(SIGTSTP,SIG_IGN);            /* ignore tty signals */ 
    signal(SIGTTOU,SIG_IGN);            // both input
    signal(SIGTTIN,SIG_IGN);            //  and output
    signal(SIGSEGV,signal_handler);
    signal(SIGUSR1,signal_handler);     // commander log messages
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
    case SIGHUP:
	  theseLogs.logN(0,"hangup signal caught, currently auc-cd ignores this.");
	  break;
    case SIGTERM:
	  theseLogs.logN(0,"terminate signal caught, auc-cd will shutdown.");
          cdShutdown termEvent;
          termEvent.send();
	  break;
   }

}
void usage() {

      std::cerr << "Usage: " << cdOrKb << " <udp-port> ['*'] [device=TEST] [mdIP=" MD_DEFAULT_IP "] [logs=\\tmp]\n\n where \n\n"                 
                   "\t <udp-port> is required, must be the first parameter,  and must be 1000 or greater. \n"
                   "\t The other parameters are optional and non-positional and take the shown defaults.  \n"
                   "\t '*', if present, indicates skip the command loop (string quotes may be required).  \n";
      exit(1);
}
