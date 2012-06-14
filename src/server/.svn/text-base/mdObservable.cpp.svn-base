#ifdef INCLMD
#include "auc-md.h"
#endif
#ifdef INCLDV
#include "md_device.h"
#endif

using namespace std;
#ifndef INCLDV
std::string mdObservable::create(int deviceHandle,std::string &typeSig,std::string &dataName) {

  std::string rc("OK"); 

  if (thisConfig->allClients[deviceHandle]->devType == MDDEV_INSTRUMENT) {

    if ( thisConfig->instruments[deviceHandle]->state.observables.find(dataName) !=
       thisConfig->instruments[deviceHandle]->state.observables.end() ) { rc = string("Dataname already defined."); }

  } else if (thisConfig->allClients[deviceHandle]->devType == MACHINE) {

    if ( theMachine->state.observables.find(dataName) !=
       theMachine->state.observables.end() ) { rc = string("Dataname already defined."); }

   }

  if (rc == "OK")
  theseLogs->logNdebug(MAX_DEBUG/100,2,"New Observable: '%s' defined by device: %d.",dataName.c_str(),deviceHandle);
  else
  theseLogs->logNdebug(10,2,"Failed New Observable: '%s' attempt by device: %d: %s.",dataName.c_str(),deviceHandle,rc.c_str());
     
  return rc;  
}
void mdObservable::source(mdResponse *mdr) {

   int   sValSize;
   mdObsPOD *flat = (mdObsPOD *)(&mdr->reply.dg.payLoad[0]);
  
   memcpy(flat,&this->obs,sizeof(mdObsPOD));
   strcpy(&flat->sVal,this->sValue.c_str());
   sValSize           = this->sValue.length();
   flat->sValSize     = sValSize + 1;
   
   mdr->reply.dg.hdr.primeOffset = mdr->reply.dg.hdr.payloadSize = sizeof(mdObsPOD) + sValSize;

}
#endif
mdObservable::mdObservable() { 
   _shared               = false;
   obs                   = new mdObsPOD;
   obs->isPrivate        = true;
   obs->focusType        = 's';
   sValue                = std::string("");
   obs->units            = MD_UNITS_UNDEFINED;
   obs->hasBounds        = false;
   obs->hasSource        = false;
   obs->realtime         = true;
   obs->outOfLimits      = false;
   obs->rValue           = 0.0;
   obs->rValueTarget     = 0.0;
   obs->rValueLow        = 0.0;
   obs->rValueHigh       = 0.0;
}
mdObservable::mdObservable(mdObsPOD *sharedMem) { 
   _shared               = true;
   obs                   = sharedMem;
   sValue                = std::string("");
}
unsigned short mdObservable::pack(char *frameData) {

  int value = 0;

  return value;

}
void  mdObservable::unpack(char **frameData) {


}
#ifndef INCLDV
std::string mdObservable::setWith(xmlrpc_c::cstruct incoming) {

  std::string rc("OK");

  sValue = std::string(xmlrpc_c::value_string(incoming["sValue"]));

  return rc;

}
xmlrpc_c::value *mdObservable::shipIt(xmlrpc_c::cstruct outbound,std::string name)
{

  std::string focusTyp = std::string(" ");
  focusTyp.at(0)       = obs->focusType;

  outbound["dataname"]       = xmlrpc_c::value_string(name);
  outbound["sValue"]         = xmlrpc_c::value_string(sValue);
  outbound["intValue"]       = xmlrpc_c::value_int(obs->intValue); 
  outbound["intValueHigh"]   = xmlrpc_c::value_int(obs->intValueHigh);
  outbound["intValueLow"]    = xmlrpc_c::value_int(obs->intValueLow);
  outbound["intValueTarget"] = xmlrpc_c::value_int(obs->intValueTarget);
  outbound["rValue"]         = xmlrpc_c::value_double(obs->rValue);
  outbound["rValueLow"]      = xmlrpc_c::value_double(obs->rValueLow);
  outbound["rValueHigh"]     = xmlrpc_c::value_double(obs->rValueHigh);
  outbound["units"]          = xmlrpc_c::value_int((int)obs->units);
  outbound["focusType"]      = xmlrpc_c::value_string(focusTyp);
  outbound["isPrivate"]      = xmlrpc_c::value_boolean(obs->isPrivate);
  outbound["hasBounds"]      = xmlrpc_c::value_boolean(obs->hasBounds);
  outbound["outOfLimits"]    = xmlrpc_c::value_boolean(obs->outOfLimits);

  return new xmlrpc_c::value_struct(outbound);

}
#endif
