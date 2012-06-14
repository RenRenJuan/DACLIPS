#ifdef INCLMD
#include "auc-md.h"
#endif
#ifdef INCLDV
#include "md_device.h"
#else
#include "masterDaemon.h"
#endif

class mdResponse;

using namespace std;

unsigned short mdOperationalDataElement::pack(char *framePtr) {

  unsigned short value = 0;

  return value;

}
mdOperationalDataElement::mdOperationalDataElement() {
   stringValue           = std::string("");
   ode                   = new mdODEPOD;
   ode->bitValue         = false;
   ode->realValue        = 0.0;
   ode->intValue         = 0;
   ode->hasSource        = false;
   ode->realtime         = true;  
   ode->referenceType    = 's';
   ode->sValSize         = ode->sVal = 0;
}
mdOperationalDataElement::mdOperationalDataElement(mdODEPOD *shared) {
   stringValue           = std::string("");
   ode                   = shared;
}

#ifndef INCLDV
void mdOperationalDataElement::source(mdResponse *mdr) {

   int   sValSize;
   mdODEPOD *flat = (mdODEPOD *)&mdr->reply.dg.payLoad[0];

   memcpy(flat,&this->ode,sizeof(mdODEPOD));
   strcpy(&flat->sVal,this->stringValue.c_str());
   sValSize           = this->stringValue.length();
   flat->sValSize     = sValSize + 1;
   
   mdr->reply.dg.hdr.primeOffset = mdr->reply.dg.hdr.payloadSize = sizeof(mdODEPOD) + sValSize;
 
}
#endif
void mdOperationalDataElement::unpack(char **framePtr) {


}
#ifndef INCLDV
std::string mdState::create(int deviceHandle,std::string &typeSig,std::string &dataName) {

  mdObservable              neuName;
  mdOperationalDataElement *newName;
  std::string               rc("OK"); 

  if (dataName.at(0) != '_')
      return neuName.create(deviceHandle,typeSig,dataName);

  if (thisConfig->allClients[deviceHandle]->devType == MDDEV_INSTRUMENT) {

    if ( thisConfig->instruments[deviceHandle]->state.localODEs.find(dataName) !=
       thisConfig->instruments[deviceHandle]->state.localODEs.end() ) {

     rc = std::string("Dataname already defined.");
   }
   else {

    newName                     = &(thisConfig->instruments[deviceHandle]->state.localODEs[dataName]);
    newName->ode->referenceType = typeSig[0];
  
  }}
  else if (thisConfig->allClients[deviceHandle]->devType == MACHINE)
  {
   if ( theMachine->state.localODEs.find(dataName) !=
        theMachine->state.localODEs.end() ) {

     rc = std::string("Dataname already defined.");
   }
   else {

    newName                     = &(theMachine->state.localODEs[dataName]);
    newName->ode->referenceType = typeSig[0];
  
   }
  }
  else rc = NOT_OK;
 
  if (rc == "OK")
  theseLogs->logNdebug(MAX_DEBUG/1000,2,"New ODE: '%s' defined by device: %d.",dataName.c_str(),deviceHandle);
  else      
  theseLogs->logNdebug(0,3,"Failed New ODE: '%s' attemptd by device: %d: %s.",dataName.c_str(),deviceHandle,rc.c_str());

  return rc;  

}
xmlrpc_c::value *mdState::get(int deviceHandle,std::string &dataname) {

  map<string, xmlrpc_c::value> returnData;
  mdObservable     focus;
  xmlrpc_c::value *gotten;

  try {

    if (thisConfig->allClients[deviceHandle]->devType == MDDEV_INSTRUMENT) {

     if ( thisConfig->instruments[deviceHandle]->state.observables.find(dataname) ==
       thisConfig->instruments[deviceHandle]->state.observables.end() )
     {
       theseLogs->logNdebug(100,2,"Unknown datum: '%s' requested from device: %d.",dataname.c_str(),deviceHandle);
       returnData["dataname"] = xmlrpc_c::value_string("not found");
       gotten = new xmlrpc_c::value_struct(returnData);
     }
     else {focus  = thisConfig->instruments[deviceHandle]->state.observables[dataname];
          gotten = focus.shipIt(returnData,dataname);                 
         }
    }
    else if (thisConfig->allClients[deviceHandle]->devType == MACHINE) {

     if ( theMachine->state.observables.find(dataname) ==
       theMachine->state.observables.end() )
     {
       theseLogs->logNdebug(100,2,"Unknown datum: '%s' requested from device: %d.",dataname.c_str(),deviceHandle);
       returnData["dataname"] = xmlrpc_c::value_string("not found");
       gotten = new xmlrpc_c::value_struct(returnData);
     }
     else {focus  = theMachine->state.observables[dataname];
          gotten = focus.shipIt(returnData,dataname);                 
         }
    }

  }
  catch(exception &e) {
    theseLogs->logN(1,"fault - mdState.get: %s",e.what());
  }

  return gotten;

}
std::string mdState::set(int deviceHandle,xmlrpc_c::cstruct &inbound) {

  std::string   dataname("dataname"),svalue("sValue"),rc("NOT OK");
  mdObservable *focus;

  if (inbound.find(dataname) == inbound.end() || inbound.find(svalue) == inbound.end()) {
     if (inbound.find(dataname) == inbound.end())
        theseLogs->logNdebug(0,1,"Missing dataname in update attempt from device: %d.",deviceHandle);
     if (inbound.find(svalue) == inbound.end())
        theseLogs->logNdebug(0,1,"Missing string value in update attempt from device: %d.",deviceHandle);
     return rc;          
  }

  try {dataname = std::string(xmlrpc_c::value_string(inbound["dataname"]));

   if (thisConfig->allClients[deviceHandle]->devType == MDDEV_INSTRUMENT) {

     if ( thisConfig->instruments[deviceHandle]->state.observables.find(dataname) !=
       thisConfig->instruments[deviceHandle]->state.observables.end() ) 
     {
      focus = &thisConfig->instruments[deviceHandle]->state.observables[dataname];
      rc    = focus->setWith(inbound);
     }
    else {
         theseLogs->logNdebug(1000,2,"Unknown datum: '%s' update attempt from device: %d.",dataname.c_str(),deviceHandle);
        }
   } else if (thisConfig->allClients[deviceHandle]->devType == MACHINE)
     {if ( theMachine->state.observables.find(dataname) !=
      theMachine->state.observables.end() ) 
      {
      focus = &theMachine->state.observables[dataname];
      rc    = focus->setWith(inbound);
     }
    else {
         theseLogs->logNdebug(1000,2,"Unknown datum: '%s' update attempt from device: %d.",dataname.c_str(),deviceHandle);
        }
     }
  }
  catch(exception &e) {
    theseLogs->logN(1,"fault - mdState.set: %s",e.what());
  }

  return rc;

}
void mdState::registerData(const char *dataName,const mdIncoming &thisOne) {

  const char                         *msg;
  char                              *name;
  int                          value = OK;
  std::string arg = std::string(dataName);
  std::map<int,mdLiveClient*>::iterator iter = thisConfig->allClients.find(thisOne.dg.hdr.handle);
  mdResponse   *result = new mdResponse(thisService->bg,thisOne.ip);

  result->reply.dg.hdr = thisOne.dg.hdr;
  result->dCat         = DV_MDQUERY;    

  if( iter == thisConfig->allClients.end() ) {
      theseLogs->logN(1,"Query for device whose handle (%d) absent, ignored.", thisOne.dg.hdr.handle );  
        value = MDERR_NOTREADY;
        goto done;
  }

  result->mdStdDevIdx = iter->second->mdStdDevIdx;

  if (dataName[0] != '_') {

   if (observables.empty()) {
        theseLogs->logN(1,"attempt to register '%s' but device not ready to accept data element registration.",dataName);
        value = MDERR_NOTREADY;
        goto done;
   }

   if( observables.find(arg) == observables.end() ) {
        theseLogs->logN(1,"attempt to register '%s' which does not yet exist.",dataName);
        value = MDERR_MISSING;
        goto done;
    }

   mdObservable sourced = observables[arg];
   if (sourced.obs->hasSource) {value = MDERR_CONFLICT; goto done;}
   sourced.obs->hasSource=true;
   sourced.source(result);
   result->reply.dg.hdr.dgSubType = MDDG_REGOBS;

  } else {
   
   if (localODEs.empty()) {
        theseLogs->logN(1,"attempt to register '%s' but device not ready to accept data element registration.",dataName);
        value = MDERR_NOTREADY;
        goto done;
   }

   if( localODEs.find(arg) == localODEs.end() ) {
        theseLogs->logN(1,"attempt to register '%s' which does not yet exist.",dataName);
        value = MDERR_MISSING;
        goto done;
    }

   mdOperationalDataElement sourced = localODEs[arg];
   if (sourced.ode->hasSource)
   {value = MDERR_CONFLICT; goto done;}
   sourced.ode->hasSource=true;
   sourced.source(result);
   result->reply.dg.hdr.dgSubType = MDDG_REGODE;

  }

  done: 

    if (value == OK) {
         msg = dataName;
         result->reply.dg.hdr.dgType.value = 1;  
    }
    else msg = thisConfig->err[value];
      
    result->reply.dg.hdr.msgType      = MDDG_MDQUERY;
    name                              = (char *)(&result->reply.dg.payLoad[0] +  result->reply.dg.hdr.primeOffset);
   
    strcpy(name,msg);
    result->reply.dg.hdr.payloadSize  = result->reply.dg.hdr.primeOffset + strlen(name) + 1;
    result->send();

}

#endif
