
#include "mdclient.h"

using namespace std;

typedef struct _DE    {
   char          sig;
   const char * name; } newDEs; 

    // Test bogus name last.
    const char *predefinedObservables[5] = { "spintime", "omega-squared", "pressure", "temperature", "adsfasdf"  };
    const char      *randomValues[4] = { "333.333", "111.111", "34.43", "7777.777" };
    const char *requiredCmdSubSys[2] = { "SYSTEM",  "STATUS" };
    string debug1,debug2,success("OK");
    newDEs otherP1Elements[6]  = { {'d',  "absorbance"},  {'d',   "acceleration"},
                                   {'b',  "_powered" },   {'t',   "_uptime"},
                                   {'i',  "_vacuum" },    {'d',   "_rotorspeed"}
                                 };

void mdCoreAPITestSuite::bucket01(char const *title) { 

  phase = string("core API test bucket");

  int               nTests=(sizeof(predefinedObservables)/sizeof(char *)),variation; 
  XmlRpcValue       focus,gotten[nTests];
  cout << "\nTest Bucket: " << title  << endl;

  // Get predefined data and test a bogus dataname

        for ( variation=0; variation < nTests; variation++) { 

          cout << ".Get '" << predefinedObservables[variation] << "'\n";       
          gotten[variation] = testState->get(mdServerHandle,predefinedObservables[variation]).getStruct();
          focus = gotten[variation].structGetValue("dataname");
          if (variation < (nTests - 1)) 
               TEST(focus.getString() == string(predefinedObservables[variation]));
          else TEST(focus.getString() == string("not found"));

        }     

   // Set to some value.

        for (variation=0;variation < (nTests - 1);variation++) { 
          cout << ".Set '" << predefinedObservables[variation] << "'\n";     
          gotten[variation].structSetValue("sValue",XmlRpcValue::makeString(randomValues[variation]));
          TEST(string("OK") == testState->set(mdServerHandle,gotten[variation]));
        }     

   // Get and compare.

        for ( variation=0; variation < (nTests -1); variation++) { 

          cout << ".Cmp '" << predefinedObservables[variation] << "'\n";       
          gotten[variation] = testState->get(mdServerHandle,predefinedObservables[variation]).getStruct();
          focus  = gotten[variation].structGetValue("sValue");
          debug1 = focus.getString();
          debug2 = string(randomValues[variation]);
          TEST(focus.getString() == string(randomValues[variation]));

        }     
        
}
void mdCoreAPITestSuite::bucket02(char const *title) {

  int                     nRequired=(sizeof(requiredCmdSubSys)/sizeof(char *)),nthCmd=0,i,found=0;
  XmlRpcValue             response;
  cout << "\nTest Bucket: " << title  << endl;

  response = testBehavior->getCommandList(mdServerHandle,string("")).getArray(); 

  TEST(response.arraySize() >= nRequired);

  for (nthCmd = 0; nthCmd < response.arraySize(); nthCmd++) {
   for (i=0;i<nRequired;i++) 
      if (response.arrayGetItem(nthCmd).getString() == string(requiredCmdSubSys[i])) {
          cout << ".Has '" << requiredCmdSubSys[i] << "'\n"; // visually check for dups
          found++;
      }
  }

  TEST(found == nRequired);

}
void mdCoreAPITestSuite::bucket03(char const *title) {

  int                     nNew=(sizeof(otherP1Elements)/sizeof(newDEs)),nthNew=0;
  std::string             newType(" ");
  XmlRpcValue             response;
  cout << "\nTest Bucket: " << title  << endl;

  for (;nthNew < nNew;nthNew++) {

    cout << ".Add '" << otherP1Elements[nthNew].name 
         << "' with signature: '" << otherP1Elements[nthNew].sig << "'\n";
    newType.replace(0,1,1,otherP1Elements[nthNew].sig);
    TEST(success == testState->create(mdServerHandle,newType,otherP1Elements[nthNew].name));

  }

  cout << "Note: you cannot run this bucket again without restarting MD." << endl;

}
void mdCoreAPITestSuite::bucket04(char const *title) {

  cout << "\nTest Bucket: " << title << " test variations not implemented yet." << endl;

}
void mdCoreAPITestSuite::bucket05(char const *title) {

  cout << "\nTest Bucket: " << title << " test variations not implemented yet." << endl;

}
void mdCoreAPITestSuite::bucket06(char const *title) {

  cout << "\nTest Bucket: " << title << " test variations not implemented yet.\n" << endl;

}
