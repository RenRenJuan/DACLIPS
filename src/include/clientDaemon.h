#ifndef CLIEVER_CORE
#define CLIEVER_CORE


using boost::asio::ip::udp;
/*! \brief mdClieverTransaction
 *         Abstract category encapsulating MD-CD interactions.
 */
class mdClieverTransaction : public mdProcess {void run() {};};
/*! \brief mdCDHearbeat
 *         Ensure vitality of the base MD-CD distributed process.
 */
void hbCallback(const boost::system::error_code& error);
class mdCDHeartbeat : public mdClieverTransaction {

    boost::asio::deadline_timer *t0;

public:

    mdCDHeartbeat() {}

    void init() {
       t0 = new  boost::asio::deadline_timer(io_bg, boost::posix_time::seconds(MD_HEARTBEAT));
                }
    void dispatch(mdWQitem*) {} // Heartbeats aren't dispatched.
    void nextBeat(const boost::system::error_code& error);
    void run();

};
/*! \brief cdClieverTransaction
 *         Encapsulates CD-mddevice interactions.
 *  
 *
 */
class cdClieverTransaction : public mdProcess {void run()=0;};

/*! \brief mdCliever
 *         Client-server middleware object.
 *  
 *
 */
class mdCliever: public mdProcess,
                 public Listener<cdHeartbeat>, 
                 public Listener<cdTelemetryFrame>,
                 public Listener<cdIncoming>,
                 public Listener<cdInteractiveCommand>,
                 public Listener<cdResponse>,
                 public Listener<cdShutdown>
{
  public:

  bool          alive,connected,shuttingDown,shutDown;

  int               instrumentHandle[MAX_INSTRUMENTS],
                               myHandle,machineHandle,
                                                   rc,
            sentMsgCount[N_MDDG_TYPES][CD_MAX_DEVICE];

  cdHeartbeat                                 myPulse;
  clientDaemonConfig                             *cfg;
  mdCDHeartbeat                                *pulse;
  mdDGChannel                                 *bg,*fg;


    mdCliever()   { alive        = connected = false;                    
                    rc           = OK;
                    pulse        = NULL;
                    shuttingDown = shutDown  = false;
                    memset(sentMsgCount,0,sizeof(sentMsgCount)); 
                    memset(instrumentHandle,0,sizeof(instrumentHandle));
                    myHandle = machineHandle = 0;
                  }
    mdCliever(clientDaemonConfig *cmdCfg)
                  {  this->cfg = cmdCfg; }

           void dispatch(mdWQitem *);
           void run() {}

    virtual void processEvent(const cdHeartbeat &ev);
    virtual void processEvent(const cdTelemetryFrame &ev);
    virtual void processEvent(const cdInteractiveCommand &ev);
    virtual void processEvent(const cdIncoming &ev);
    virtual void processEvent(const cdResponse &ev);
    virtual void processEvent(const cdShutdown &ev);

};
#endif
