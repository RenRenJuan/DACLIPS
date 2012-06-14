class cdHeartbeat: public TimeStampedEvent<>, public PolymorphEvent {
     
    public:
        mdDatagram dg;
        mdReply   dgr;

        cdHeartbeat() {

        memset((void *)&dg,0,sizeof(mdReply));
        dg.hdr.clientType  = MDDEV_CD;
        dg.hdr.msgType     = MDDG_HEARTBEAT;

         };

       ~cdHeartbeat() {};
        virtual void send() const { sendTypedEvent(*this); }

};
class cdIncoming: public TimeStampedEvent<>, public PolymorphEvent {

    public:
        mdDatagram                       dg;
        boost::asio::ip::udp::endpoint   ip;

     cdIncoming(mdDGChannel &c) {dg = *(c.inProcess);}

     virtual void send() const { sendTypedEvent(*this); }
          
};
class cdResponse: public TimeStampedEvent<>, public PolymorphEvent {
public:
    bool                        ackIsNak;
    mdDatagram                 *incoming;
    mdDatagram                    *reply;
    boost::asio::ip::udp::endpoint    ip;
   
        virtual void send() const { sendTypedEvent(*this); }

};
class cdShutdown:  public TimeStampedEvent<>, public PolymorphEvent {

    public:
        virtual void send() const { sendTypedEvent(*this); }
};
class cdTelemetryFrame:  public TimeStampedEvent<>, public PolymorphEvent {

    public:
        virtual void send() const { sendTypedEvent(*this); }
};
class cdInteractiveCommand:  public TimeStampedEvent<>, public PolymorphEvent {

    public:
        virtual void send() const { sendTypedEvent(*this); }

};
