#include "auc-md.h"
#ifdef MD_MAND
#include <environment.h>
#endif
using namespace std;

  extern xmlrpc_c::registry aucMDregistry;
  extern "C" int            lxi_control(int,char **); 

std::string mdCommand::dO(void *targeT,std::string *text) {

  return std::string("OK");
  
}
mdSCPI *mdSCPI::setHandler(mdResponse *mdr) {

   mdSCPI   *value = this;
   mdCmdPOD *flat  = (mdCmdPOD *)(&mdr->reply.dg.payLoad[0]);
  
   memcpy(flat,&this->parms,sizeof(mdCmdPOD));
   strcpy(&flat->sVal,this->signature.c_str());
   flat->nArgs = this->signature.length();
   
   mdr->reply.dg.hdr.primeOffset = mdr->reply.dg.hdr.payloadSize = sizeof(mdCmdPOD) + flat->nArgs;

  done: return value;

}
bool mdMandSpace::setFullName() {

  bool value=true;

  return value;
}
