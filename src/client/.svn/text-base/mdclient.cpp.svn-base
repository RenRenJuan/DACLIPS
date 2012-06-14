/*! \brief mdclient
 *         Master Daemon standalone client
 *
 *   This MD sample client driver has the same functionality as the
 *   xmlrpc-c xmlrpc command line utility program but additionally
 *   runs a test suite using the test harness reused from the
 *   xmlrpc-c cpp test.
 *
 *   Client interfaces are automatically generated when the server
 *   is compiled from the current server API so this program should
 *   be run to verify and currently the coding of test cases is
 *   entirely manual.
 *
 *   \todo DLL packaging supplying the client functionality used here.
 *
 */

#define MDCLIENTMAIN
#include "mdclient.h"
 
using namespace std;

main(int argc, char **argv) {

  char  debug[10];
  int   rc;

    cout << "mdclient compiled " __DATE__ " " __TIME__ " \n";

    if (argc < 3 ) {
      
        cerr << "Usage: mdclient <deviceType> <serverURL> <thirdOption>\n\nwhere\n\n"
                "  <serverURL>   = . defaults to '" MD_SERVER_URL  "'\n"
                "  <device>      = . defaults to '" DEFAULT_DEVICE "'\n"
                "  <thirdOption> = 'n' or 'N'\n\n"

                "The master daemon must be running at the specified <serverURL>.\n"
                "<thirdOption> = n causes non-repeatable testbucket(s) to be skipped.\n"
                "Any other 3rd ooption causes a simple connectivity test and exit.\n"
                "Otherwise performs the full MD core API test suite.\n\n";

        //      "If XMLRPC_TRACE_XML is defined will pause " <<
        //       PAUSE_SECS << " at selected points in the tests.\n\n";
        exit(1);
        
    }
    
    phase         = string("setup"); 
    if (argc > 3) {
      if (*argv[3] == 'n' || *argv[3] == 'N') repeatableOnly = true;
      else                                    doSanityCheck  = true;
    }
    defaultDevice = (*argv[1] == '.') ? DEFAULT_DEVICE : argv[1];
    serverURL     = (*argv[2] == '.') ? MD_SERVER_URL  : argv[2];

    if (doSanityCheck) {

    cout << "Doing sanity check with simple client:  get a handle for " << defaultDevice <<  " from " << serverURL <<  "\n"; 

    string const serverUrl(serverURL);
     string const methodName("device.registeR");

    xmlrpc_c::clientSimple monClient;
    xmlrpc_c::value result;
        
    monClient.call(serverUrl, methodName, "is", &result, 0, DEFAULT_DEVICE);

    int const handle((xmlrpc_c::value_int(result)));
    
    if ((mdServerHandle=handle) <= 0)
      {cout << serverURL << " returned: " <<  handle << " instead of a valid handle.\n"
                            " Run terminates in error.\n";
        exit(1);
      }

    cout << "Got " << defaultDevice << " handle: " <<  handle << "\n";
    cout << "Sanity check completed OK.\n";
    exit(0);

    }

    mdCoreAPITestSuite tests;

    try { 

      xmlrpc_env_init(&env);      
      xmlrpc_client_setup_global_const(&env);
      xmlrpc_client_init2(&env, 0, "mdclient", "1.0", NULL, 0);

      tests.run(0);
   
    } catch(exception const& e) {
      cout << "During " << phase << " caught std exception: " << e.what() << "\n";
      cout << "Terminating in error.\n" ;
      rc = 1;      
    }
     catch(XmlRpcFault const& e) {
      cout << "XmlRpcFault during " << phase << ": " << e.getFaultString() << "\n";
      cout << "Terminating in error.\n" ;
      rc = 1;
     }
    
    cout << tests.tests    << " Variation(s).\n"
         << tests.failures << " Failure(s).\n";

    return rc;
}

