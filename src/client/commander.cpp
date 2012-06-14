#include "auc-cd.h"

int is_numeric(const char *p) { int i = strlen(p),j=0;
     if (*p) {
          char c;
          while ((c=*p++)) { j++;
                if (!isdigit(c)) {
                   if (j == i) return 2;
                   else        return 0;
                }
          }
          return 1;
      }
      return 0;
}
void mdCommander::driver() {
  
   bool  rc;
   char  instrinsic[16],next,rawString[256],work[256];
   const char  *mdErrCode  = "";
   int   i,commandLength;

   greet();   
   while(acceptingInput) {
       putchar('>');
       next=0;
       i=0;
       memset(rawString,0,sizeof(rawString));
       while(next != '\012') {
             next = getchar();
             rawString[i++] = next;
             if (i > (sizeof(rawString) - 1)) {
               puts("Max length exceeded!");
               continue;
             }
       }
       if (!strlen(rawString)) continue;
       if (rawString[0] == '?') {
          help();
          continue;
       }
       if (is_numeric(rawString) == 2) {
          rawString[strlen(rawString)] = 0;
          mdStdDevIdx = atoi(rawString);
          continue;
       }
       if (strlen(rawString) >= 4 && strlen(rawString) <= 6 )
       {if (!strcmp(rawString,"log\n")) {
            system("less /tmp/auc-cd.log");
            continue;
        }
        if (!strcmp(rawString,"rlog\n")) {
            system(PULL_MD_LOG);
            system("less auc-md.log");
            continue;
        }
        if (!strcmp(rawString,"clips\n")) {
#ifdef MD_MAND
          
#endif
            continue;
        }
        if (!strcmp(rawString,"done\n")) {
            return;
        }
        if (!strcmp(rawString,"mdapi\n")) {
            system("mdclient ");
            continue;
        }
        if (!strcmp(rawString,"quit\n")) {
            thisConfig->terminateRequest = true;
            return; 
        }                 
        if (!strcmp(rawString,"mdapi\n")) {
            continue; 
        }               
        if (strlen(rawString) < 3) {
             puts("That SCPI command is too short!");
             continue;
        }
        rc = scpi(rawString);
        if (!rc) puts("Command transmitted: OK.");
        else     printf("Command result: %s.",mdErrCode);
        continue;
       }
    }

}
void mdCommander::greet() {

  puts("auc-cd command processor");
  puts("Enter ? for help or a cliever low level command");
  acceptingInput = true;
  SCPImode       = true;
  currentDevice  = std::string("ALX");

}
void mdCommander::help() {
 
   const char *banner = "\n" CD_NAME " "  CD_VERSION " compiled on " __DATE__ " @ " __TIME__ " (%d)\n";

   system("clear"); 
   printf(banner,thisConfig->shellProcess); 
   printf("Target mdStdDevIdx: %d (0: Master Daemon(MD), 1: Cliever(CD))\n",mdStdDevIdx);
   puts("LL (low level) Cliever commands: \n");
   puts("  ?      - display this screen");
   puts("  <n>    - make <n> (an integer) the target mdStdDevIdx");
   if (*cdOrKb == 'd')
   {puts("  clips  - character UI on this active rulebase");
    puts("  xclips - GUI on this active rulebase via an X server");
    puts("  xhost  - set the xserver (current: localhost:0)");
   }
   puts("  done   - terminate the command loop but not auc-cd");
   puts("  log    - display this cliever log");
   puts("  rlog   - pull and display the MD log");
   puts("  mdapi  - run mdclient here (xmlrpc-c must be installed)");
   printf("  quit   - terminate %s (if in md shell CTL-C if finished)\n\n",thisConfig->origCmd);
   puts("Anything else is a SCPI cmd for the current target device.");
   puts("If the device responds it should show in the log if debug level high enough.\n");
   if (*cdOrKb == 'd') {
    puts("In the character mode UI:");
    puts(" Enter (help) in the rules system for more help.");
    puts(" Enter (exit) in the rules system to return here.\n");
   }
   puts("If in md shell, 'RST' and 'quit' resets the servers for this Cliever group");
   puts("(i.e. if the mdStdDevIdx is 0;used to get a fresh epoch with MD");
   puts(" and CD initialized and connected for device and data client testing).\n");
   puts("NB: USE LL SCPI COMMANDS FOR DEVICE DEV ONLY -\n");
   puts("Sending device commands at this level is potentially dangerous and is ");
   puts("only for device development. Other users should issue commands using the");
   puts("data client XMLRPC API, e.g. thru mdclient which uses the current best");
   puts("proven rulebase (when MD is running as daclips-md).");

} 
bool mdCommander::scpi(char *cmd) {

  char *command,work[256];
  bool isDirect=false,rc=true;
 
  if (!mdStdDevIdx && !strncmp(cmd,"RST",3)) {

       mdDG mdg;

       mdg.dg.hdr.sourceHandle  = thisCliever->myHandle;
       mdg.dg.hdr.payloadSize   = 0;
       mdg.dg.hdr.msgType       = MDDG_CDRESET;
       if (thisCliever->fg->send(mdg.dg)) rc = false;

  }

  return rc;

}

