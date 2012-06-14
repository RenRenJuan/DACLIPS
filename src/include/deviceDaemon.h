#ifndef DEVICE_CORE
#define DEVICE_CORE

using boost::asio::ip::udp;
/*! \brief mdEmbeddedTransaction
 *         Abstract category encapsulating MD-CD interactions.
 */
class mdEmbeddedTransaction : public mdProcess {void run() {};};
/*! \brief mdCDHearbeat
 *         Ensure vitality of the base MD-CD distributed process.
 */
void  hbCallback(const boost::system::error_code& error);
class mdDVHeartbeat : public mdEmbeddedTransaction {

    boost::asio::deadline_timer *t0;

public:

    mdDVHeartbeat() {}

    void init() {
       t0 = new  boost::asio::deadline_timer(io_, boost::posix_time::seconds(10));
                }
    void dispatch(mdWQitem*) {} // Heartbeats aren't dispatched.
    void nextBeat(const boost::system::error_code& error);
    void run();

};
/*! \brief dvTransaction
 *         Encapsulates mddevice interactions.
 *  
 *
 */
class dvTransaction : public mdProcess {void run()=0;};

/*! \brief mdEmbedded
 *         Client-server middleware object.
 *  
 *
 */
class mdEmbedded: public dvTransaction,
                 public Listener<dvHeartbeat>, 
                 public Listener<dvTelemetryFrame>,
                 public Listener<dvIncoming>,
                 public Listener<dvQueryMD>,
                 public Listener<dvResponse>,
                 public Listener<dvShutdown>
{
  public:

  bool          alive,connected,shuttingDown,shutDown;
  int             mdStdDevIdx,myHandle, rc, sentBeats;
                  
  dvHeartbeat                                 myPulse;
  deviceDaemonConfig                             *cfg;
  mdDVHeartbeat                                *pulse;
  mdDGChannel                                 *md,*cd;  


    mdEmbedded()  {this->create();}
    mdEmbedded(deviceDaemonConfig *cmdCfg)
                  {  this->cfg = cmdCfg;
                     this->create();
                  }

           
           void additionalSystemMsgs();
           void dispatch(mdWQitem *);
           void create() {
                    alive        = connected = false;                    
                    rc           = OK;
                    pulse        = NULL;
                    sentBeats    = 0;
                    shuttingDown = shutDown  = false;
                    myHandle     = 0;
                    mdStdDevIdx  = MAX_CLIENTS+1; 
           }
           void run();

    virtual void processEvent(const dvHeartbeat &ev);
    virtual void processEvent(const dvIncoming &ev);
    virtual void processEvent(const dvQueryMD &ev);
    virtual void processEvent(const dvResponse &ev);
    virtual void processEvent(const dvShutdown &ev);
    virtual void processEvent(const dvTelemetryFrame &ev);
            
};
#endif
