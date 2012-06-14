#include "auc-md.h"
#include "masterDaemon.h"
#include "../server/Listener.cpp"
#include "../server/EventSender2.cpp"
using namespace std;

/*! \brief Client object implementatios
 *
 */

int getHandle() {

 map<int,mdLiveClient*>::iterator it;

 bool collision = thisConfig->allClients.size() > 0 ? false: true, found;
 int  value; srand ( time(NULL) );

 value = (rand() % (MAX_DEVICE * 10)) + 1;

 while(collision) { 
   for(found = false, it =  thisConfig->allClients.begin();
       it != thisConfig->allClients.end() && !found;
       found = (it->first == value ? true : false), it++);
   if (!found) collision = false;
   else        value     = (rand() % (MAX_DEVICE * 10)) + 1;

 }
 return value;   

}
template<class T> T* mdDevice<T>::registeR(md_device t) {

  T  *value=NULL;
  int h = getHandle();

  if (value=mdDevice<T>::validateClient(h)) {
      theseLogs->logN(2,"Handle %d assigned to new client of type: %s",clientTypes[t]);
  } else {     
      theseLogs->logN(2,"Validation failed for client type: %s",clientTypes[t]);
      return value;
  }

  value->handle = h;
  value->create();
  thisConfig->allClients[h] = value; // validateClient has already added to group
  return value ;

}
template<class T> 
 void mdDevice<T>::lxi_control(T *device, std::string fullText) {

  T        *target = device;
  char     *ip,*port,*command,*timeout,*argv[5];

  argv[1]  = ip       = (char *)malloc(32);
  argv[2]  = port     = (char *)malloc(16);
  argv[3]  = timeout  = (char *)malloc(32);
  argv[4]  = command  = (char *)malloc(1024);

  sprintf(ip,"--ip %s",target->ip.c_str());
  sprintf(port,"--port %s",target->port.c_str());
  sprintf(timeout,"--timeout %s",target->timeout.c_str());
  sprintf(command,"--scpi %s",fullText.c_str());

  lxi_control(5,argv);

  free(ip);
  free(port);
  free(timeout);
  free(command);

}
mdClientServer* mdClientServer::validateClient(int handle, mdResponse &r) {
 
 bool            isNew=true;
 int            i,m=-1,n=-1;
 mdClientServer *value=NULL; 
 
 if (!thisConfig->nClievers) {m =0; isNew = true;}
 else for(i=0;i<MAX_CLIEVER && isNew;i++)
      {if (m < 0 && thisConfig->clievers[i].empty()) m = i;
       if (ip.address().to_string() == thisConfig->clievers[i]) isNew = false;
      }

 if (isNew && thisConfig->nClievers < MAX_CLIEVER)
 { for (n=i=0;i<thisConfig->nClievers && n < 0;i++)
       if (!thisConfig->cliever[i]) n = i;
   thisConfig->nClievers++; 
   thisConfig->cliever[n]   = value = this;
   mdStdDevIdx              = n + 1;
   ip                       = r.ip;
   thisConfig->clievers[n]  = ip.address().to_string();
 }
 else {
 theseLogs->logN(1,"Either a Cliever already active at %s or limit number (%d) reached.",ip.address().to_string().c_str(),MAX_CLIEVER);
 }
 return value;   

}
mdMachine* mdMachine::validateClient(int handle, const mdClientBirth &c, mdResponse &r) {

 char      *cp; 
 mdMachine *value=NULL; 
 
 if (!theMachine) {
   if (c.dg.hdr.dgType.clieverGroup) {
     theseLogs->logN(1,"Machine specified non-zero cliever group(%d) in GDOLMS 1.x, rejected.",c.dg.hdr.dgType.clieverGroup);
     goto done;
   }
   if (!thisConfig->cliever[c.dg.hdr.dgType.clieverGroup]) {
     theseLogs->logN(1,"The cliever for this device group (%d) is not online, machine birth rejected.",c.dg.hdr.dgType.clieverGroup);
     goto done;
   }
   strcpy(r.reply.dg.payLoad,thisConfig->clievers[c.dg.hdr.dgType.clieverGroup].c_str());
   cp = &r.reply.dg.payLoad[0] + strlen(r.reply.dg.payLoad) + 1;
   *((unsigned short *)cp) = thisConfig->cliever[c.dg.hdr.dgType.clieverGroup]->ip.port();
   theMachine  = value  = this;
   mdStdDevIdx = MAX_CLIEVER + 1;
 }

 done: 
 return value;   

}
mdInstrument* mdInstrument::validateClient(int handle, const mdClientBirth &c, mdResponse &r) {

 mdInstrument *value=NULL;
 
 if (thisConfig->instruments.size() < MAX_INSTRUMENTS) {
      thisConfig->instruments[handle] = value = this;
//      mdStdDevIdx = 
 }
  else theseLogs->logN(1,"Too many instruments, configured limit is: %d.",MAX_INSTRUMENTS);

 return value;

}
mdDataClient* mdDataClient::validateClient(int handle) {

 mdDataClient *value=NULL;
 
 if (thisConfig->clients.size() < MAX_DATACLIENTS) {
      thisConfig->clients[handle] = value = this;
 }
  else theseLogs->logN(1,"Too many non-device clients, configured limit is: %d.",MAX_DATACLIENTS);

 return value;

}
std::string mdDeviceFabrik::newFromAPI(md_device type,std::string thisSpecialOne) {

}
void mdDeviceFabrik::newFromHeartbeat(const mdClientBirth &thisOne) {

 const char     *kind,*outcome;
       void     *resultat;

 int            i,mdStdDevIdx;
 md_device      thisKind;
 mdCB           *newControlBlock;
 mdLiveClient   *newAllMap;
 mdClientServer *newCliever;
 mdMachine      *newMachine;
 mdInstrument   *newInstrument;
 mdResponse     *result   = new mdResponse(thisService->bg,thisOne.ip);
 
 int maybe=getHandle();

 result->dCat                         = MD_NEWBORN;
 result->reply.dg.hdr                 = thisOne.dg.hdr;
 result->reply.dg.hdr.dgType.isAckNak = true;
 result->reply.dg.hdr.dgType.value    = true;
 result->ip                           = thisOne.ip;

 switch(thisOne.dg.hdr.clientType) {
  case MDDEV_CD:
    thisKind   = MDDEV_CD;
    kind       = "cliever";
    newCliever = new mdClientServer();
    if (resultat = newCliever = newCliever->validateClient( maybe, *result )) {       
        newCliever->ip      = thisOne.ip;
        mdStdDevIdx         = newCliever->mdStdDevIdx;
    }
    else delete newCliever;
    break;
  case MACHINE:
    thisKind   = MACHINE;
    kind       = "machine";
    newMachine = new mdMachine();
    if (resultat = newMachine = newMachine->validateClient( maybe, thisOne, *result )) {
         theMachine           = newMachine;
         newMachine->ip       = thisOne.ip;
         mdStdDevIdx          = MAX_CLIEVER + thisOne.dg.hdr.dgType.clieverGroup;
    }
    else delete newMachine;
    break;
  case MDDEV_INSTRUMENT:
    thisKind      = MDDEV_INSTRUMENT;
    kind          = "instrument";
    newInstrument = new mdInstrument();
    if (!(resultat = newInstrument = newInstrument->validateClient( maybe, thisOne, *result ))) 
          delete newInstrument;
    else {newInstrument->ip = thisOne.ip;       
          for (i=0;i<MAX_INSTRUMENTS && thisService->instruments[i];i++);
          thisService->instruments[i] = maybe;
          mdStdDevIdx        = 2+i;
         }
    break;
 }

 outcome         = resultat ? "succeeded" : "failed";
 theseLogs->logN(2,"The %s instantiation request %s.",kind,outcome);

 if (!resultat) { result->reply.dg.hdr.dgType.value = false;
                  result->mdStdDevIdx               = MDDEV_MD;
                }
 else           { newAllMap                         = new mdLiveClient();
                  newAllMap->devType                = thisKind;
                  newAllMap->mdStdDevIdx            = mdStdDevIdx;
                  thisConfig->allClients[maybe]     = newAllMap;
                  result->reply.dg.hdr.sinkHandle   = maybe;
                  result->mdStdDevIdx               = mdStdDevIdx;
                  cb[mdStdDevIdx] = newControlBlock = new mdCB;
                  newControlBlock->handle           = maybe;
                }

 result->send();
 
}
void mdMachine::registerCmd(const char *cmdName,const mdIncoming &thisOne) {
  
  const char                         *msg;
  char                              *name;
  int                          value = OK;
  std::string  arg = std::string(cmdName);
  std::map<int,mdLiveClient*>::iterator iter = thisConfig->allClients.find(thisOne.dg.hdr.handle);
  mdResponse   *result = new mdResponse(thisService->bg,thisOne.ip);

  result->reply.dg.hdr = thisOne.dg.hdr;
  result->dCat         = DV_MDQUERY;    

  if( iter == thisConfig->allClients.end() ) {
      theseLogs->logN(1,"Cmd reg for device whose handle (%d) absent, ignored.", thisOne.dg.hdr.handle );  
        value = MDERR_NOTREADY;
        goto done;
  }

  result->mdStdDevIdx = iter->second->mdStdDevIdx;

   if (cmds.empty()) {
        theseLogs->logN(1,"attempt to register '%s' but device not ready to accept command registration.",cmdName);
        value = MDERR_NOTREADY;
        goto done;
   }

   if( cmds.find(arg) == cmds.end() ) {
        theseLogs->logN(1,"attempt to register '%s' whose rules has not yet been defined.",cmdName);
        value = MDERR_MISSING;
        goto done;
    }

   // Currently presumes SCPI.

   if (cmds[arg]->getHandler())
   {value = MDERR_CONFLICT; goto done;}
   else{
   cmds[arg]->setHandler(cmds[arg]);
   result->reply.dg.hdr.dgSubType = MDDG_REGSCPI;
   }

  done: 

    if (value == OK) {
         msg = cmdName;
         result->reply.dg.hdr.dgType.value = 1;  
    }
    else msg = thisConfig->err[value];
      
    result->reply.dg.hdr.msgType      = MDDG_MDQUERY;
    name                              = (char *)(&result->reply.dg.payLoad[0] +  result->reply.dg.hdr.primeOffset);
   
    strcpy(name,msg);
    result->reply.dg.hdr.payloadSize  = result->reply.dg.hdr.primeOffset + strlen(name) + 1;
    result->send();

}
//
// TODO: figure out how to avoid this duplication in gcc and msvc 10.
//
void mdInstrument::registerCmd(const char *cmdName,const mdIncoming &thisOne) {
  
  const char                         *msg;
  char                              *name;
  int                          value = OK;
  std::string  arg = std::string(cmdName);
  std::map<int,mdLiveClient*>::iterator iter = thisConfig->allClients.find(thisOne.dg.hdr.handle);
  mdResponse   *result = new mdResponse(thisService->bg,thisOne.ip);

  result->reply.dg.hdr = thisOne.dg.hdr;
  result->dCat         = DV_MDQUERY;    

  if( iter == thisConfig->allClients.end() ) {
      theseLogs->logN(1,"Cmd reg for device whose handle (%d) absent, ignored.", thisOne.dg.hdr.handle );  
        value = MDERR_NOTREADY;
        goto done;
  }

  result->mdStdDevIdx = iter->second->mdStdDevIdx;

   if (cmds.empty()) {
        theseLogs->logN(1,"attempt to register '%s' but device not ready to accept command registration.",cmdName);
        value = MDERR_NOTREADY;
        goto done;
   }

   if( cmds.find(arg) == cmds.end() ) {
        theseLogs->logN(1,"attempt to register '%s' which has no rules basis.",cmdName);
        value = MDERR_MISSING;
        goto done;
    }

   // Currently presumes SCPI.

   if (cmds[arg]->getHandler())
   {value = MDERR_CONFLICT; goto done;}
   else{
   cmds[arg]->setHandler(cmds[arg]);
   result->reply.dg.hdr.dgSubType = MDDG_REGSCPI;
   }

  done: 

    if (value == OK) {
         msg = cmdName;
         result->reply.dg.hdr.dgType.value = 1;  
    }
    else msg = thisConfig->err[value];
      
    result->reply.dg.hdr.msgType      = MDDG_MDQUERY;
    name                              = (char *)(&result->reply.dg.payLoad[0] +  result->reply.dg.hdr.primeOffset);
   
    strcpy(name,msg);
    result->reply.dg.hdr.payloadSize  = result->reply.dg.hdr.primeOffset + strlen(name) + 1;
    result->send();

}
