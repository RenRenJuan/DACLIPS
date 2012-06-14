#if !defined(DV_EVENTS) && !defined(DV_DRV)
#define DV_EVENTS

class dvHeartbeat: public TimeStampedEvent<>, public PolymorphEvent {
     
    public:
        mdDG      mdg;
        mdReply   dgr;

        dvHeartbeat() {

        mdg.dg.hdr.clientType  = thisConfig->thisDeviceType;
        mdg.dg.hdr.msgType     = MDDG_HEARTBEAT;

         };

       ~dvHeartbeat() {};
        virtual void send() const { sendTypedEvent(*this); }

};
using boost::asio::ip::udp;
class dvIncoming: public TimeStampedEvent<>, public PolymorphEvent {

    public:
        mdDG            mdg;
        udp::endpoint    ip;

     dvIncoming(mdDGChannel &c) {mdg.dg = *(c.inProcess);}

     virtual void send() const { sendTypedEvent(*this); }
          
};
class dvResponse: public TimeStampedEvent<>, public PolymorphEvent {
public:
    bool        ackIsNak;
    mdDatagram *incoming;
    mdDatagram    *reply;
    udp::endpoint     ip;
   
    virtual void send() const { sendTypedEvent(*this); }

};
class dvQueryMD: public TimeStampedEvent<>, public PolymorphEvent {

    public:
        mdDG            mdg;
        dvResponse     *dvr;
        udp::endpoint    ip;

     dvQueryMD() {dvr = NULL;}

     virtual void send() const { sendTypedEvent(*this); }
          
};
class dvShutdown:  public TimeStampedEvent<>, public PolymorphEvent {

    public:
        virtual void send() const { sendTypedEvent(*this); }
};
class dvTelemetryFrame:  public TimeStampedEvent<>, public PolymorphEvent {

    public:
    md_device  dest;
    mdDG      frame;

    virtual void send() const { sendTypedEvent(*this); }
};
#endif
