
#include <string>
#include <iostream>
#include <xmlrpc-c/base.hpp>
#include <xmlrpc-c/client_simple.hpp>
#define XMLRPC_C
#include "tools.h"
#include "mdClientBehavior.h"
#include "mdClientDevice.h"
#include "mdClientState.h"

#define MD_SERVER_URL           "http://localhost:4243/RPC2"
#define DEFAULT_DEVICE          "ALX"
#define EXPECTED_MACHINE_HANDLE 1
#define PAUSE_SECS              3

#ifdef MDCLIENTMAIN

     bool     doSanityCheck = false, repeatableOnly = false;

     xmlrpc_env env;      
     xmlrpc_c::clientXmlTransport_libwww myTransport;
     xmlrpc_c::client_xml                 myClient(&myTransport);
     XmlRpcValue::int32                   mdServerHandle = 0;
    
     int   pauseSecs=0;
     const char *defaultDevice,*serverURL;
     std::string phase;

#else

     extern bool     doSanityCheck, repeatableOnly;

     extern xmlrpc_env env;      
     extern xmlrpc_c::clientXmlTransport_libwww  myTransport;
     extern xmlrpc_c::client_xml                 myClient;
     extern XmlRpcValue::int32                   mdServerHandle;
     extern const char *defaultDevice,*serverURL;
     extern int   pauseSecs;
     extern std::string phase;

#endif

class mdCoreAPITestSuite : public testSuite {

/*----------------------------------------------------------------------------
   The object of this class tests the MD core API.

   Some day, we would like to automate its generate
   with that of the client objects it tests.

   Unlike the "new" xmlrpc-c test style, we do count
   successes and failures and attempt to execute the
   entire suite.
-----------------------------------------------------------------------------*/
public:    

     mdClientState       *testState;
     mdClientDevice     *thisClient;
     mdClientBehavior *testBehavior;

     virtual std::string suiteName() {
        return "Phase I UAT Suite";
    }
    void bucket00(char const *title) {

      std::cout << "\nTest Bucket: " << title  << std::endl;
      TEST(mdServerHandle = thisClient->registeR( 0, defaultDevice));

    }
    void bucket01(char const *title);
    void bucket02(char const *title);
    void bucket03(char const *title);
    void bucket04(char const *title);
    void bucket05(char const *title);
    void bucket06(char const *title);

    virtual void runtests(unsigned int const) {

      char             testContext[256];
      mdClientState    mdState(serverURL);
      mdClientDevice   mdClient(serverURL);
      mdClientBehavior mdBehavior(serverURL);

      testState    = &mdState;
      thisClient   = &mdClient;
      testBehavior = &mdBehavior;       

      tests = failures = 0;

      sprintf(testContext,"Get handle for device: %s to test against: %s\n",defaultDevice,serverURL);
      if (!mdServerHandle)
      bucket00(testContext);
      bucket01("Check predefined observables access.\n");
      bucket02("Check for required SCPI subsystems for the selected device.\n");
      if (!repeatableOnly)
      bucket03("Check dynamic definition of remaining specified observables.\n");
      bucket04("Check event/rule mechanism.\n");
      bucket05("Check SCPI execution.\n");
      bucket06("Check datagram layer operations.\n");
        
    }
};

