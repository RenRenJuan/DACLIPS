#include "auc-md.h"

const char *mdStdErrs[] = { "No error detected.",     "Required state/element missing.", "Already exists.",
                            "Conflict detected.",     "Not ready.",                      "Syntax error." };

masterDaemonConfig::masterDaemonConfig() {

   nClievers     =                        0;
   configPath    =                     "./";
   logPath       =                   "/tmp";  
   daemonized    =                     true;
// used in the logNdebug by increasing power of 10.
   debugThreshold =           CURRENT_DEBUG; 
   halt          =                    false;
   shuttingDown  =                    false;
   shutdown      =                    false;
   thisMachineContext =                  -1; // in v 1.0. there's only 1 but the 
//                                              basis for more than one is pre-established.           
   err           =                mdStdErrs;       
}
int masterDaemonConfig::loadMachineConfiguration(int deviceType) {

  int rc=OK;

  if (!deviceType) {

  }

  /* \todo Add configuration process for non-MD_TYPE devices */

  return rc;

}
