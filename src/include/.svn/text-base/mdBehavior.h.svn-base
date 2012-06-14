#ifndef MD_BEHAVIOR
#define MD_BEHAVIOR

#include "Listener.h"
#include "EventSender.h"
#include "PolymorphEvent.h"

/*! \brief mdMand
 *         The former mdBehavior
 *
 * The overall object category and files are still using the original name. 
 * Wanted to make d0 pure virtual but too many problems with current gcc template instantiation
 * ( http://gcc.gnu.org/onlinedocs/gcc/Template-Instantiation.html )
 * 
 * The CLIPS integration with the low level system in mostly restricted to this interface.
 */

class mdMand;

typedef std::map<std::string,mdMand> MandLayer;

class mdMand { 
public:

    md_mand            kind;
    std::string    fullname;
    MandLayer     subsystem; // children
    MandLayer        parent;
    void           *handler;

    // Subtypes must implement these. 
    std::string  *dO(std::string *text);
   
};

class mdMandSpace {
    MandLayer       catalog;

    bool add(std::string name,md_mand typ)
    {if (catalog.find(name) == catalog.end()) {       
        mdMand *newMand    = new mdMand();
        catalog[name]      = *newMand;
        newMand->fullname  = name;        
        newMand->kind      = typ;
        newMand->handler   = NULL;
     }

    }
    mdMand               *find(std::string fn);
    mdMand *parseAndCreatePath(std::string fn);
    bool                     setFullName(void);
};

typedef struct {
  bool  requiresResponse;
  bool      hasArguments;
  unsigned short   nArgs;
  char              sVal;
}
 mdCmdPOD;  

class mdCommand : mdMand {
public:               
                  mdCmdPOD        parms;
                  std::string signature;

                  mdCommand(md_mand typ=MD_USER_MAND,std::string name=std::string(""))  
                  {mdMand::handler   = NULL; 
                   mdMand::fullname  = name;
                   mdMand::kind      =  typ;                              
                  }
                  ~mdCommand()  {}

  mdCommand       *mand(int deviceHandle, std::string& text);
  std::string     dO(void *target,std::string *text);
  void           *getHandler() {return mdMand::handler;}
  void            setHandler(void *to) {mdMand::handler = to;}

};
class mdResponse;
class mdSCPI : mdCommand {
public:

      mdSCPI(std::string name) : mdCommand(MD_SCPI, name) {}
      mdSCPI *setHandler(mdResponse *mdr);
      std::string dO(void *target,std::string *text);
      
};

typedef std::map<std::string,mdCommand *> InstructionSet; // The SCPI commands by cannonical name.
 
#endif
