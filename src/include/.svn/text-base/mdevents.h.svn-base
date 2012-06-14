#ifndef MD_EVENTS
#define MD_EVENTS

class mdAttention: public TimeStampedEvent<>, public PolymorphEvent {

        int idx;
    public:
        mdAttention( int count ) { idx = count; }
        virtual void send() const { sendTypedEvent(*this); }

};
class mdClientBirth:  public TimeStampedEvent<>, public PolymorphEvent {
public:
    bool                      dgDetermined;
    int                        mdStdDevIdx;
    md_device                   clientType;
    std::string                  signature;
    boost::asio::ip::udp::endpoint      ip;

    mdDatagram                          dg;
    mdReply                            dgr;

        mdClientBirth() {
          dgDetermined = false;
          mdStdDevIdx  =    -1;
        }
        virtual void send() const { sendTypedEvent(*this); }

};
class mdClientDeath:  public TimeStampedEvent<>, public PolymorphEvent {

    public:
        virtual void send() const { sendTypedEvent(*this); }

};
class mdDeviceCommand:  public TimeStampedEvent<>, public PolymorphEvent {

    public:
        virtual void send() const { sendTypedEvent(*this); }

};
class mdIncoming: public TimeStampedEvent<>, public PolymorphEvent {

    public:
        mdDatagram                     dg;
        boost::asio::ip::udp::endpoint ip;
    
     mdIncoming(mdDGChannel *bus) {dg = *bus->inProcess;}

     virtual void send() const { sendTypedEvent(*this); }
          
};
class mdCDPulse: public TimeStampedEvent<>, public PolymorphEvent {
     
    public:
        virtual void send() const { sendTypedEvent(*this); }

};
class mdResponse: public TimeStampedEvent<>, public PolymorphEvent {
public:
    int                     mdStdDevIdx;

    md_dispatch_category           dCat;
    mdDGChannel                    *bus;
    mdReply                       reply;
    boost::asio::ip::udp::endpoint   ip;

     mdResponse(mdDGChannel *c,udp::endpoint ep) : 
       bus(c), ip(ep) { mdStdDevIdx = -1; }
   
    virtual void send() const { sendTypedEvent(*this); }

};
class mdTelemetryFrame:  public TimeStampedEvent<>, public PolymorphEvent {
public:
    int           mdStdDevIdx;

    mdTelemetryFrame() {mdStdDevIdx = -1;}

        virtual void send() const { sendTypedEvent(*this); }
};
#endif
