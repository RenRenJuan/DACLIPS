#define  MD_MAIN 
#include "auc-md.h"

#include <stdio.h>
#include <fcntl.h>
#include <signal.h>
#include <unistd.h>

using namespace std;

bool mdHasKb;
const char *mdOrKb;
void setSignals();
void signal_handler(int);
void usage();
void md() {

 bool daemonized=false;
 int  i,lfp,rc;
 char str[32];

   if (thisConfig->daemonized) {

    rc = fork();
    if (rc  < 0) {
        puts("Can't initialize process!");
        exit(1);
    }

    if (getpid() == thisConfig->shellProcess) 
        exit(0);

    setsid();                                       /* obtain a new process group */
    for (i=getdtablesize();i>=0;--i) close(i);      /* close all descriptors      */  
    i=open("/dev/null",O_RDWR); dup(i); dup(i);     /* handle standard I/O        */
    umask(027);                                     /* set newly created file permissions */
    chdir(RUNNING_DIR);                             /* change running directory   */
    lfp=open(MD_LOCK_FILE,O_RDWR|O_CREAT,0640);     /* make sure were The MD      */
    if (lfp<0) {printf("Can't open lockfile(%d)! Ctl-C me.");      exit(1);}
    if ((rc=lockf(lfp,F_TLOCK,0))<0)
               {printf("Can't lock lockfile (%d)! Ctl-C me.",rc);  exit(0);}

    thisConfig->daemonProcess = getpid();

    sprintf(str,"%d\n",getpid());
    write(lfp,str,strlen(str));                      /* record pid to lockfile    */ 
    daemonized = true;

  }

  setSignals();

  try {

    theseLogs     = new mdLogger();
    theseLogs->init();

    theseLogs->logN(1,MD_NAME " " MD_VERSION " compiled on " __DATE__ " @ " __TIME__ "(%d)",thisConfig->daemonProcess);
    if (daemonized) theseLogs->logN(1,"(detached from %d)",thisConfig->shellProcess);

    if (mdHasKb) {
         theseLogs->logN(0,"Creating CLIPS Environment.");
#ifdef MD_MAND
         DACLIPS::init();
#endif
       }

    boost::thread foreground(runMasterDaemon);
    boost::thread background(runDataLayer);

    xmlrpc_c::serverAbyss myAbyssServer(
        thisConfig->api_registry,
        thisConfig->xmlrpcPort, 
        thisConfig->xmlrpcLogpath
        );

    if (!foreground.joinable()) {
       theseLogs->logN(0,"Fatal Error: couldn't start server core!");
       exit(1);
    }

    if (background.joinable()) {
     theseLogs->logN(2,"%s %d","Accepting API Requests on Port",thisConfig->xmlrpcPort);
     myAbyssServer.run();    
     background.join();     // normally unreachable
    } else      
       theseLogs->logN(0,"Fatal Error: couldn't start background data layer!");
  }
  catch (XmlRpcFault::XmlRpcFault& e)
  { 
    theseLogs->logN(1,"xmlrpc_c fault: %s",e.getFaultString().c_str());
    exit(1);
  }
  catch (std::exception& e)
  {
    theseLogs->logN(1,"Exception: %s",e.what());
    exit(1);
  }
  catch (...) { 
    theseLogs->logN(1,"General Fault!");
    exit(1);
  }

}
int 
main(int           const argc, 
     const char ** const argv) {

  char  msg[512];
  const char *banner = MD_NAME " "  MD_VERSION " compiled on " __DATE__ " @ " __TIME__ "(%d)\n";
  int   mthParm,  rc = 0;

  thisConfig = new masterDaemonConfig();
  thisConfig->shellProcess = getpid();

    mdOrKb   = (strcspn(argv[0],"./") == strlen(argv[0])) ? argv[0] : strrchr(argv[0],'/') + 1;
    mdHasKb  = strstr(argv[0],"clips") ? true : false;

    if (argc < 3 || argc > 6) usage();

    thisConfig->telemetryPort = atoi(argv[1]);
    thisConfig->xmlrpcPort    = atoi(argv[2]);
    
    if (thisConfig->telemetryPort < 1000 || thisConfig->telemetryPort > 65535)
    {
      std::cerr << "The <telemetry-udp-port> value is invalid.\n";
      return 1;
    }

    if (thisConfig->xmlrpcPort < 1000 || thisConfig->xmlrpcPort > 65535)
    {
      std::cerr << "The <xmlrpc-socket-port> value is invalid.\n";
      return 1;
    }

    if (thisConfig->xmlrpcPort == thisConfig->telemetryPort)
    {
      std::cerr << "The <xmlrpc-socket-port> and <telemetry-udp-port> cannot be the same.\n";
      return 1;
    }

    for (mthParm=3;mthParm < argc;mthParm++) {      
     if (*argv[mthParm] == '!') {
          thisConfig->daemonized = false;
      }
      else
      if (!strncmp(argv[mthParm],"logs=",4)) {
          thisConfig->log_path = std::string(argv[mthParm]+4);
          thisConfig->logPath  = thisConfig->log_path.c_str();
      }
      else
      if (!strncmp(argv[mthParm],"cfg=",3)) {
          thisConfig->cfg_path   = std::string(argv[mthParm]+3);
          thisConfig->configPath = thisConfig->cfg_path.c_str();
      }    
      else usage();  
    }

    if (!thisConfig->daemonized) printf(banner,thisConfig->shellProcess); 
    md();
    while(!thisConfig->halt) sleep(5);

}
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
		theseLogs->logN(0,"SEGV ABEND.");
                exit(NOT_OK);
                break;
        case SIGUSR1: 
                break;
        case SIGUSR2: 
                break;
	case SIGHUP:
		theseLogs->logN(0,"hangup signal caught, currently md ignores this.");
		break;
	case SIGTERM:
		theseLogs->logN(0,"terminate signal caught, auc-md will shutdown.");
		exit(0);
		break;
   }
}
void usage() {

      std::cerr << "Usage: " << mdOrKb << " <telemetry-udp-port> <xmlrpc-socket-port> [cfg=<path>] [log=<path>] [!] \n\n"
                   "   where \n\nconfig directory defaults to the current directory \n"
                   "log directory to /tmp \nand ! indicates do not daemonize (for diagnostic purposes)\n\n";
      exit(1);

}
