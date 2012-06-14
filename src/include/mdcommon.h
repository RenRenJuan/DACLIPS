  /**
   * \mainpage DACLIPS
   *
   * <br><hr>
   *
   * \par About
   * \par
   * <a href="http://meansofproduction.biz/openauc">The Latex2HTML Master Document</a>
   * 
   * \htmlonly
   * \endhtmlonly
   *
   * <br><hr>
   *
   * \par DACLIPS requirements
   *
   * The DACLIPS program suite was originally developed on Fedora and Debian but
   * should compile on any Unix where all of the requirements are present. The device
   * embedded programs were developed for Windows and Windows Xe. The intent is to
   * have a standalone Cliubook packaging by 2011Q2,
   *
   * <br><hr>
   *
   * \par Download DACLIPS  source code
   *
   * Developers Repository
   *
   * - To pull from my svn repo:
   *   - \verbatim svn co svn://juan.ai-integration.biz/svn/ai-integration.biz/DACLIPS  \endverbatim
   *
   *
   * <br><hr>
   *
   * \par Top Level External Dependencies... and version currently used 
   * <br>
   * \b boost:    1.44    <br>
   * \b log4cpp:  1.0     <br>
   * \b sigc++:   2.0     <br>
   * \b xmlrpc-c: advanced<br>
   * <br>
   * The above is a covering set of dependencies, everything else required for unix builds should be in the svn tree.
   * 
   * <br><hr>
   *
   * mdcommon.h - Core Daemon Level definitions.
   *
   * \par Authors Support Site
   *
   * \htmlonly <a href=http://auc.meansofproduction.biz>auc.meansofproduction.biz</a> \endhtmlonly
   *
   * \par License
   * See the licenses section of the Latex2HTML document
   *
   */

#ifndef MD_COMMON
#define MD_COMMON

#include<boost/asio/datagram_socket_service.hpp>

using namespace std;
using boost::asio::ip::udp;

#define MAX_CLIENTS                  1000
#define MAX_CLIEVER                  10
#define MAX_DATACLIENTS              200
#define MAX_INSTRUMENTS              3        // Per Cliever cluster.
#define MAX_DEBUG                    1000     // Set the config parm higher than this to inhibit logNdebug(m...) where m < this
#define MAX_DEVICE                   (((MAX_CLIEVER + 1) * MAX_INSTRUMENTS) + MAX_DATACLIENTS)
#ifndef MD_STAGE
#define CD_DEFAULT_IP                "192.168.0.9"
#define MD_DEFAULT_IP                "192.168.0.5"
#define PULL_MD_LOG                  "cp /somejuan/tmp/auc-md.log ."
#else
#define CD_DEFAULT_IP                "184.168.64.86"
#define MD_DEFAULT_IP                "178.79.142.228"
#define PULL_MD_LOG                  ("scp daclips@" MD_DEFAULT_IP "/tmp/auc-md.log .")
#endif
#define MD_EPOCH                     date()           
#define MD_HEARTBEAT                 1            // Network peer heartbeat in seconds.
#define MD_MAX_DATAGRAM              (32*1024)    // half of the IPV4 max
#define DACLIPS_APP                  "Generic"
#define MD_COMPONENT                 "Master Daemon" // DACLIPS Component
#define MD_NAME                      DACLIPS_APP " " MD_COMPONENT 
#define MD_VERSION                   " 1.1 "      // DACLIPS Version
#define MD_REFRESH                   10           // default milliseconds between telemetry frame updates
#define MD_TYPE                      "CENTRIFUGE" // i.e. what a MACHINE is, Change per your DACLIPS derivation
#define NORMAL_DEBUG                 10  
#ifndef CURRENT_DEBUG
#define CURRENT_DEBUG                NORMAL_DEBUG
#endif
#define NOT_OK                       -1
#define OK                           0
#define RUNNING_DIR          	     "/tmp"

#define theMachine                   thisConfig->machine[thisConfig->thisMachineContext]

enum md_mand {
  MD_NAM,                            // Not a Mand.
  MD_USER_MAND,                      // User defined mand type
  MD_SCPI,                           
  MD_RULE_ACTION,
  MD_CLIEVER_CMD,                    // From CD command loop or other UI
  MD_CLIENT_CMD,                     // From XMLRPC 
  MD_NMANDS 
};

enum mdErrorCode {                   // In auc-md/kb index to masterDaemonConfig.err
  MDERR_OK,
  MDERR_MISSING,
  MDERR_EXISTS,
  MDERR_CONFLICT,
  MDERR_NOTREADY,
  MDERR_SYNTAX,
  N_MDSTDERR
};

enum md_dispatch_category {
  MD_NEWBORN   = 0,                  // inbound this isn't dispatched
  CD_FRAME,
  MD_FRAME,
  DV_MDQUERY,
   DVMDQ_REGSCPI,
   DVMDQ_REGOBS,
   DVMDQ_REGODE,
  MD_SHUTDOWN
};

enum md_device {
  MDDEV_MD = 0,
  MDDEV_CD,
  MACHINE,
  MDDEV_INSTRUMENT,
  MDDEV_DATACLIENT,
  N_MDDEV_TYPES
};

enum md_units {
  MD_UNITS_UNDEFINED = 0,
  MD_CENTIMETERS,  
  MD_MILLIMETERS,
  MD_MICRONS,
  MD_NANOMETERS,
  MD_VOLTS,
  MD_CC,
  N_MD_UNITS
};

enum mdDGtype {
  MDDG_HEARTBEAT = 0,
  MDDG_DEVICEHB,
  MDDG_NEWBORN,
  MDDG_MDQUERY,
   MDDG_REGSCPI,
   MDDG_REGOBS,
   MDDG_REGODE,
  MDDG_TELEMETRY,
  MDDG_CDRESET,
  N_MDDG_TYPES
};

typedef
struct MD_DG_TYPE {
unsigned inBandOnly   :  1;
unsigned requiresAck  :  1;
unsigned isAckNak     :  1;
unsigned value        :  1; // i.e. boolean for ack/nak etc. where true = ack.
unsigned reserved     :  4;
unsigned clieverGroup :  8; // masterDaemonConfig.thisMachineContext
unsigned reserved2    : 16; 
}
 mdDGflags;

typedef 
struct MD_DG_HEADER {
mdDGtype    msgType;
mdDGflags   dgType;
mdDGtype    dgSubType;
int         msgSN;           // Ordinal in a dialog 
md_device   clientType;
int         sourceHandle;
int         sinkHandle;
int         handle;          // for example if query about a device other than source or sink.
mdErrorCode ec;
int         payloadSize;
int         primeOffset;     // for example to the name associated with the data
}
 mdDGHeader;

typedef
struct MD_DATAGRAM {
  mdDGHeader hdr;
  char       payLoad[MD_MAX_DATAGRAM - (sizeof(mdDGHeader))];
}
 mdDatagram;

typedef 
struct MD_REPLY {
 mdDGHeader hdr;
 char  payLoad[512 - sizeof(mdDGHeader)];
}
 mdDGReply;

class mdReply {
public:

 mdDGReply  dg;

 mdReply() {memset((void *)&dg,0,sizeof(mdDGReply));
            dg.hdr.dgType.isAckNak = true;
           }
};

#if (defined(MD_MAIN) || defined(CD_MAIN) || defined(DV_MAIN) || defined(DV_DLL_MAIN))
const char *clientTypes[N_MDDEV_TYPES ] = { "Master Daemon",  "Cliever", "Machine", "Instrument", "MD Non-Data Client" };
#else
extern const char *clientTypes[N_MDDEV_TYPES];
#endif

/* \brief mdProcess
 *        Abstract base class of various subprocesses
 *
 *  DACLIPS is a distributed system with various subprocesses
 *  spanning the central server, the 'Cliever' middleware component and clients.
 *  Root class for these.
 *
 */

class mdWQitem {
public:
 md_dispatch_category kind;
 const void          *what;
 int                  user; // User defined
 mdWQitem (const void *work,md_dispatch_category priority,int x)
 : what(work), kind(priority), user(x) {}
 
 bool operator< (const mdWQitem & right) const {
  return kind < right.kind; 
 }

};

typedef std::priority_queue < mdWQitem* > MDWQ;

class mdProcess {  
public: MDWQ q;
                   mdProcess()  {}
                  ~mdProcess()  {}

        void  queue(mdWQitem *w) {q.push(w);}             
virtual void  dispatch(mdWQitem *w)=0;
virtual void  run() = 0;  

};
#define MD_DEFAULT_DEVICE_PROTOCOL 0
#define MD_DEFAULT_RULE            0

typedef
struct { 
  unsigned       open:1;  
  unsigned     looped:1;  // back channel established from passive connection.     
  unsigned  reserved:30;
 } mdCnctBool;

typedef 
struct  MD_CONTROL_BLOCK
{int                                  handle;        // debug mark
 mdCnctBool                       connection;
 boost::asio::ip::udp::endpoint           ep;
 boost::asio::ip::udp::resolver::iterator it;
 boost::asio::ip::udp::socket           *udp;
 MD_CONTROL_BLOCK() {
  handle = 0;
  memset((void *)&connection,0,sizeof(connection));
  udp    = NULL;
 }
}
 mdCB;

typedef std::map<int,mdCB*> mdStdDevicePODMap;      // MD Standard Device Map -
/*
 *\brief stdDev: collection with       MD at: 0, CD in:  1 - MAX_CLIEVER,
 *                                      MACHINEs    in:  MAX_CLIEVER+1    - MAX_CLIEVER*2,
 *                                      Instruments in: (MAX_CLIEVER*2)+1 - (((MAX_CLIEVER*2)+1)+(MAX_CLIEVER*MAX_INSTRUMENTS)),
 *                                      DataClients in: (MAX_CLIEVER*MAX_INSTRUMENTS)+1 - MAX_CLIENT
 *                                     localhost    at:  MAX_CLIENT+1
 * 
 * The mdStdDevIdx of a device is its index above. 
 * Within intervals clients are assigned compactly in the same order as thier handles are created and assigned.
 */

#if (defined(MD_MAIN) || defined(CD_MAIN) || defined(DV_DLL_MAIN))
         mdStdDevicePODMap  cb;
         int                myStdDevIdx=MAX_CLIENTS+1; // global default to localhost
#else
  extern mdStdDevicePODMap  cb;
  extern int                myStdDevIdx;
#endif

class mdDGChannel
{public:

  boost::asio::io_service&                         io_service_;
  boost::asio::ip::udp::endpoint                   p_endpoint_;
  boost::asio::ip::udp::endpoint                   a_endpoint_;
  boost::asio::ip::udp::endpoint                          *ep_;
  boost::asio::ip::udp::resolver                            *r;
  boost::asio::ip::udp::resolver::query                     *q;
  boost::asio::ip::udp::socket                        passive_;
  boost::asio::ip::udp::socket                        *active_;
  boost::asio::ip::udp::socket                             *s_;
  
  char                                 ack_[sizeof(mdDGReply)];
  char                                  data_[MD_MAX_DATAGRAM];

  int                                              mdStdDevIdx;

  mdDatagram                                        *inProcess;
  mdReply                                               *reply;

  short                                                   port;

  mdDGChannel(boost::asio::io_service& io_service,
              short inport, int stdDevIdx=myStdDevIdx)
    : io_service_(io_service), mdStdDevIdx(stdDevIdx), 
      passive_(io_service, udp::endpoint(udp::v4(), inport))
  {   
   inProcess   = (mdDatagram *)data_;
   ep_         = &p_endpoint_;
   port        = inport;
   reply       = (mdReply *)ack_;
   q           = NULL;
   r           = NULL;
   s_          = &passive_;
   
    passive_.async_receive_from(
        boost::asio::buffer(data_, MD_MAX_DATAGRAM), p_endpoint_,
        boost::bind(&mdDGChannel::handle_receive_from, this,
          boost::asio::placeholders::error,
          boost::asio::placeholders::bytes_transferred));
  }

  void async_send(mdDatagram &dg) {

      size_t dgSize = sizeof(mdDGHeader) + dg.hdr.payloadSize;

      *inProcess = dg;
      //std::memcpy(this->data_,(char *)&dg,dgSize);

      active_->async_send_to(
          boost::asio::buffer(data_, dgSize), *ep_,
          boost::bind(&mdDGChannel::handle_send_to, this,
            boost::asio::placeholders::error,
            boost::asio::placeholders::bytes_transferred));
   }

   bool connect_to (std::string &host, std::string &port, int stdDevIdx=-1) {

   bool value = false;
   int  rport = atoi(port.c_str());
   boost::system::error_code    ec; 
   boost::asio::ip::udp::endpoint remote ( boost::asio::ip::address::from_string(host.c_str()), rport);

   stdDevIdx = (stdDevIdx == -1) ? mdStdDevIdx : stdDevIdx;
   map<int,mdCB *>::iterator iter = cb.find(stdDevIdx);
   if( iter == cb.end() ) cb[stdDevIdx] = new mdCB();

   try {
     if (!r) r = new udp::resolver(io_service_);
     if ( q)  delete q;
             q = new udp::resolver::query(udp::v4(), host.c_str(), port.c_str());
     cb[stdDevIdx]->it = r->resolve(*q);
     if (!cb[mdStdDevIdx]->udp)
          cb[mdStdDevIdx]->udp = new udp::socket(io_service_, udp::endpoint(udp::v4(), 0));
     active_ = cb[mdStdDevIdx]->udp;
     if (active_->is_open())
         active_->connect(remote,ec);

     if (!ec) value = true;  

   }
    catch(...) {}

   return (cb[stdDevIdx]->connection.open=value);

  }

  bool connect_to (boost::asio::ip::udp::endpoint &ep,boost::system::error_code &ec,int &step,int stdDevIdx=-1)
  {
   
   bool                   value = false;

   stdDevIdx = stdDevIdx == -1 ? mdStdDevIdx : stdDevIdx;
   map<int,mdCB *>::iterator iter = cb.find(stdDevIdx);
    if( iter == cb.end() ) cb[stdDevIdx] = new mdCB();

   try { if (cb[stdDevIdx]->udp) {if (cb[stdDevIdx]->udp->is_open())
                                      cb[stdDevIdx]->udp->close();
                                  delete cb[stdDevIdx]->udp;}

      cb[stdDevIdx]->ep  = ep;
      active_ = cb[stdDevIdx]->udp = new boost::asio::ip::udp::socket( io_service_ , udp::endpoint(udp::v4(), 0) );
      ec.clear();
      active_->connect( cb[stdDevIdx]->ep, ec );
      if (active_->is_open()) { value = true; cb[stdDevIdx]->connection.open=1; }
      else {
         step++;
         active_->open( udp::v4(),  ec );
         if (active_->is_open()) {value = true; cb[stdDevIdx]->connection.open=1; }
      }

   } 
   catch(boost::system::system_error &be) {boost::system::system_error warning = be;} 
   catch(...) {}

   return (value);

  }

  void handle_receive_from(const boost::system::error_code& error, size_t bytes_recvd);

  void handle_send_to(const boost::system::error_code& asioEC,  size_t sentByes)
  {
     size_t dgSize = inProcess->hdr.dgType.requiresAck
                   ?  sizeof(mdReply) :  sizeof(mdDatagram);

      //  std::string debugMsg = asioEC.message();

      if (inProcess->hdr.dgType.requiresAck)
        active_->async_receive_from(
        boost::asio::buffer(ack_, dgSize), *ep_,
        boost::bind(&mdDGChannel::handle_receive_from, this,
          boost::asio::placeholders::error,
          boost::asio::placeholders::bytes_transferred));
      else
        active_->async_receive_from(
        boost::asio::buffer(data_, dgSize), *ep_,
        boost::bind(&mdDGChannel::handle_receive_from, this,
          boost::asio::placeholders::error,
          boost::asio::placeholders::bytes_transferred));
  }

  bool send(mdDatagram &dg) {

      size_t dgSize = sizeof(mdDGHeader) + dg.hdr.payloadSize;

      return (dgSize == 
      active_->send(boost::asio::buffer((void *)&dg, dgSize)));

  }

  bool send_to(mdDatagram &dg, int mdStdDevIdx) {

      size_t dgSize = sizeof(mdDGHeader) + dg.hdr.payloadSize;

      return (dgSize == 
      active_->send_to(boost::asio::buffer((void *)&dg, dgSize), *cb[mdStdDevIdx]->it));

  }

  size_t send(mdReply &dg, boost::system::error_code &ec) {

      size_t dgSize = sizeof(mdDGReply);
      boost::asio::socket_base::message_flags  flags=0;

      return (active_->send(boost::asio::buffer((void *)&dg, dgSize), flags, ec));

  }
 
  size_t send_back(mdReply &dg, boost::system::error_code &ec, int &step) {

      size_t dgSize = sizeof(mdDGReply);
      boost::asio::socket_base::message_flags  flags=0;
      step = 1;

      a_endpoint_ = passive_.remote_endpoint(ec);

      if (ec) return 0;
    
      return (passive_.send_to(boost::asio::buffer((void *)&dg, dgSize), a_endpoint_, flags, ec));

  }

  bool send_to(mdReply &dg,int mdStdDevIdx) {

      size_t dgSize = sizeof(mdDGReply);

      return (dgSize == 
      active_->send_to(boost::asio::buffer((void *)&dg, dgSize), *cb[mdStdDevIdx]->it));

  }

};


#if defined(_WIN32_WINNT) && !defined(DllExport) && defined(DV_DLL)
#pragma warning( disable: 4251 )
#define DllExport __declspec(dllexport)
#else
#define DllExport
#endif
        
typedef std::map<int,std::string> mdErrMsgMap;

class DllExport mdError {
 
  int         instance; 
  mdErrMsgMap     text;

public: 
   mdError() { text[0]  = std::string("OK");
               instance = 0;
             }

  ~mdError() {}
 
   // The below populate the additional messages;
   // Instances below 1000 are reserved for system errors, negative
   // integers not used.
   // Users derive from this class and implement additionalUsrMsgs.

   void     additionalUserMsg(int instCode,const char *msgText)
   {if (instCode >= 1000) text[instCode] = std::string(msgText);}
   void additionalSystemMsg(int instCode,const char *msgText)
   {if (instCode < 1000 && instCode >0) text[instCode] = std::string(msgText);}

   int      get()        {return instance;}
   void     get(mdError **parentPtr)
                         {*parentPtr = this;}
   void     set(int i)   {instance = i;}

   const char *what(char *buffer=NULL) {
     if (text.find(get()) == text.end()) {
      {if (!buffer) return NULL;
       sprintf(buffer,"Unknown error code: %d",get());
       return buffer;
      } 
      return text[get()].c_str();
     }
     return "unknown";
   }

};

class mdDG {
public:
  mdDatagram dg;

  mdDG() {memset(&dg,0,sizeof(mdDatagram));}

};

#endif
