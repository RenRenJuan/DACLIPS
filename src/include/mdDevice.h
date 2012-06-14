
#include <boost/asio.hpp>

/*! \brief mdDevice
 *         General abstraction of all MD clients
 *
 *  For historical reasons all clients are considered to be
 *  devices, though mdclient and US clients have a non-device
 *  client type. The central device of the system has zero
 *  device type.
 *
 */
 
using namespace std;
using boost::asio::ip::udp;

template<class T>
class mdDevice {
public:

  bool                           isSingleton;
  int                            clieverGroup, // masterDaemonConfig.thisMachineContext
                                 handle,mdStdDevIdx;
  md_device                      type;
  mdState                        state; 

  udp::endpoint                  ip;

  // Only Machine and Instrument use below                 
  InstructionSet                  cmds;                                       

  // Some parameters initially here are now all uniformly ODEs
  // defined in the COOL scripts.

  ~mdDevice() {}
  mdDevice(md_device t) : type(t)    {clieverGroup = handle = mdStdDevIdx = -1;}

          void     lxi_control(T* device,std::string scpiText);
          T*       registeR(md_device t);

  xmlrpc_c::value* fetchCommands(std::string subSystem);
  void             registerCmd(const char *cmdName,const mdIncoming &mdI);
  
};

class mdClientServer;
class mdClientServer : public mdDevice<mdClientServer> {
public:
 
  mdClientServer() : mdDevice<mdClientServer>( MDDEV_CD ) {};
  mdClientServer  *validateClient(int handle, mdResponse &r);
};

class mdMachine;
class mdMachine : public mdDevice<mdMachine> {
public:

  mdMachine() : mdDevice<mdMachine>( MACHINE ) 
  { cmds["RST"] = new mdCommand(MD_SCPI,std::string("RST")); }
  mdMachine       *validateClient(int handle, const mdClientBirth &c, mdResponse &r);
  void             registerCmd(const char *cmdName,const mdIncoming &mdI);
};

class mdInstrument;
class mdInstrument : public mdDevice<mdInstrument> {
public:

  mdInstrument() : mdDevice<mdInstrument>( MDDEV_INSTRUMENT ) 
  { cmds["RST"] = new mdCommand(MD_SCPI,std::string("RST")); }
  mdInstrument   *validateClient(int handle, const mdClientBirth &c, mdResponse &r);
  void            registerCmd(const char *cmdName,const mdIncoming &mdI);
};

class mdDataClient;
class mdDataClient : public mdDevice<mdDataClient> {
public:

  mdDataClient() : mdDevice<mdDataClient>( MDDEV_DATACLIENT ) {};
  mdDataClient    *validateClient(int handle);
};

class masterDaemon;
class mdDeviceFabrik : public mdDevice<masterDaemon> 
{public:

   mdDeviceFabrik() : mdDevice<masterDaemon>( MDDEV_MD ) {}
   void        newFromHeartbeat(const mdClientBirth &itsAWhat);
   std::string newFromAPI(md_device type,std::string signature);

};
