#define DV_DLL
#include "md_device.h"
#include "../server/Listener.cpp"
#include "../server/EventSender.cpp"
#include <time.h>
#include <boost/thread/mutex.hpp>
#include <boost/foreach.hpp>
#include "telemetry.h"

using namespace std;
using boost::asio::ip::udp;

void dvWQ();
void hbCallback(const boost::system::error_code&);
void stream();
void trCallback(const boost::system::error_code& error);


 boost::mutex                   mutAlive;
 boost::mutex                    mdQuery;
 boost::condition_variable deviceRunning;
 boost::condition_variable mdObsQPending;
 boost::condition_variable mdODEQPending;
 boost::condition_variable mdCmdQPending;
 bool              deviceIsRunning=false;

void mdEmbedded::dispatch(mdWQitem *next) {

   bool                 gc = true;
   dvQueryMD        *thisQ = (dvQueryMD *)next->what;
   dvTelemetryFrame *thisF = (dvTelemetryFrame *)next->what;

   switch(next->kind) {
    case CD_FRAME:
      cd->send_to(thisF->frame.dg, thisF->dest );
      break;
    case DV_MDQUERY:
      gc = false;
      md->send_to(thisQ->mdg.dg, MDDEV_MD );
      break;
    default:;
      break;
   }
   if (gc) delete next;

}
void mdEmbedded::processEvent(  const dvIncoming &dgEvent )
{      
   const char   *name;
   assert(EventSender<dvIncoming>::isSending());
    
   switch(dgEvent.mdg.dg.hdr.msgType) {
     case MDDG_MDQUERY:
         name = &dgEvent.mdg.dg.payLoad[dgEvent.mdg.dg.hdr.primeOffset];
         theseLogs.logN(1,"Got response to query re: '%s' from MD",name);  
     switch(dgEvent.mdg.dg.hdr.dgSubType) {
         case MDDG_REGSCPI:
            thisCmdQry.response = (dvIncoming *)&dgEvent;
            mdCmdQPending.notify_one();
         break;
         case MDDG_REGODE:
            thisODEQry.response = (dvIncoming *)&dgEvent;
            mdODEQPending.notify_one();
         break;
         case MDDG_REGOBS:
            thisObsQry.response = (dvIncoming *)&dgEvent;
            mdObsQPending.notify_one();
         break;
       }
     break;
     case MDDG_NEWBORN:
     switch(dgEvent.mdg.dg.hdr.clientType) {
       case MDDEV_MD:
         if (dgEvent.mdg.dg.hdr.sinkHandle) { const char *rawCD = dgEvent.mdg.dg.payLoad;
                                      const unsigned short *rawCDport = (unsigned short *)(&dgEvent.mdg.dg.payLoad[0] + strlen(rawCD) + 1);
           myHandle = dgEvent.mdg.dg.hdr.sinkHandle;
           theseLogs.logN(3,"Got handle (%d) from MD, device will use telemetry CD at %s:%d.",myHandle,rawCD,*rawCDport);       
           thisConfig->cdAddress = std::string(rawCD);
           thisConfig->cdPort    = *rawCDport;
         }
         else if (!myHandle)
           theseLogs.logN(0,"MD rejected natal sequence. Please kill me and call tech. support."); 
         break;
     }
   }

}
void mdEmbedded::processEvent( const dvHeartbeat &thisPulse )
{
    assert(EventSender<dvHeartbeat>::isSending());
   
    myPulse.mdg.dg.hdr.msgSN         = sentBeats++;
    myPulse.mdg.dg.hdr.sourceHandle  = myHandle;
    strcpy(myPulse.mdg.dg.payLoad,thisConfig->telemetryPortStr.c_str());
    myPulse.mdg.dg.hdr.primeOffset   = strlen(thisConfig->telemetryPortStr.c_str()) + 1;
    strcpy((char *)(&myPulse.mdg.dg.payLoad[myPulse.mdg.dg.hdr.primeOffset]),thisConfig->deviceName.c_str());
    myPulse.mdg.dg.hdr.payloadSize   = strlen(thisConfig->telemetryPortStr.c_str()) + thisConfig->deviceName.length() + 2;
    md->send_to(myPulse.mdg.dg, MDDEV_MD );
    theseLogs.logNdebug(MAX_DEBUG,1,"Heartbeat (%d)",sentBeats);
  
}
void mdEmbedded::processEvent(  const dvShutdown &bye )
{      
    assert(EventSender<dvShutdown>::isSending());
    shuttingDown = true;    
    theseLogs.logN(0,"Shutting down: draining work for immediate exit.");

}
void mdEmbedded::processEvent( const dvQueryMD &thisQuery )
{
    const void *queued = &thisQuery;

    assert(EventSender<dvQueryMD>::isSending());
    queue(new mdWQitem( queued, DV_MDQUERY, 0 ));

}
void mdEmbedded::processEvent( const dvResponse &thisReply )
{
    const void *queued = &thisReply;

    assert(EventSender<dvResponse>::isSending());
    queue(new mdWQitem( queued, MD_NEWBORN, 0 ));

}
void mdEmbedded::processEvent(  const dvTelemetryFrame &frameEv )
{      
    assert(EventSender<dvTelemetryFrame>::isSending());

    const void *queued = &frameEv;
    std::pair <std::string,mdObservable *>              obsPair;
    std::pair <std::string,mdOperationalDataElement *>  odePair;
    mdTelemetryFrame tFrame(frameEv.frame.dg.payLoad,sizeof(frameEv.frame.dg.payLoad));
  
    tFrame.newOut();

    BOOST_FOREACH( obsPair, myObs )
    {  tFrame.pack( obsPair.second, obsPair.first ); }

    BOOST_FOREACH( odePair, myODEs )
    {  tFrame.pack( odePair.second, odePair.first ); }

    queue(new mdWQitem( queued, CD_FRAME, 0 ));

}
void mdEmbedded::run() {

    boost::thread work(dvWQ);
    assert(work.joinable());
    theseLogs.logNdebug(MAX_DEBUG,0,"MD Embedded premptible worker started.");
    work.join();

}
void mdDGChannel::handle_receive_from(const boost::system::error_code& error,
      size_t bytes_recvd)
{
   if (!error && bytes_recvd > 0)
   {
     dvIncoming  incoming( *(thisDevice->cd) );

     if (incoming.mdg.dg.hdr.clientType >= 0 && incoming.mdg.dg.hdr.clientType <  N_MDDEV_TYPES)
     {theseLogs.logNdebug(MAX_DEBUG,2,"msgtype %d received from a '%s'.",incoming.mdg.dg.hdr.msgType,clientTypes[incoming.mdg.dg.hdr.clientType]);
      incoming.ip = p_endpoint_;
      incoming.send();
     } else
        theseLogs.logNdebug(1,1,"msgtype %d received from unknown MD client type, ignored.",incoming.mdg.dg.hdr.msgType);

    }
    passive_.async_receive_from(
          boost::asio::buffer(data_, MD_MAX_DATAGRAM), p_endpoint_,
          boost::bind(&mdDGChannel::handle_receive_from, this,
            boost::asio::placeholders::error,
            boost::asio::placeholders::bytes_transferred));

}
void mdDVHeartbeat::nextBeat(const boost::system::error_code& error) { thisDevice->myPulse.send(); }
void mdDVHeartbeat::run() {

  int                i;

      while (!thisDevice->shuttingDown) 
      {t0->async_wait(hbCallback);
       i = (thisDevice->myHandle) ? 60 : 10;
       boost::system_time const alarum=boost::get_system_time() + boost::posix_time::seconds(i*MD_HEARTBEAT);
       boost::this_thread::sleep(alarum);
      }

}
//
// Free functions
//
void hbCallback(const boost::system::error_code& error) { if (thisDevice->alive) thisDevice->pulse->nextBeat(error); }
void pulse() { if ((thisDevice->connected=thisDevice->md->connect_to( thisConfig->mdAddress, thisConfig->telemetryPortStr ))) 
  theseLogs.logNdebug(NORMAL_DEBUG,2,"device connect_to: MD @ %s port %s.", thisConfig->mdAddress.c_str(),thisConfig->telemetryPortStr.c_str());
  else
  theseLogs.logNdebug(NORMAL_DEBUG*2,2,"device connect_to: MD @ %s port %s failed.", thisConfig->mdAddress.c_str(),thisConfig->telemetryPortStr.c_str());
  if (thisDevice->connected)
      thisDevice->pulse->run();                               
}
void runEmbedded() {

 try { 

  thisDevice                  = new mdEmbedded(thisConfig);
  cb[thisDevice->mdStdDevIdx] = new mdCB();

  EventSender<dvHeartbeat>::add(*thisDevice);
  assert(EventSender<dvHeartbeat>::getNumListeners() == 1);
  EventSender<dvIncoming>::add(*thisDevice);
  assert(EventSender<dvIncoming>::getNumListeners() == 1);
  EventSender<dvQueryMD>::add(*thisDevice);
  assert(EventSender<dvQueryMD>::getNumListeners() == 1);
  EventSender<dvResponse>::add(*thisDevice);
  assert(EventSender<dvResponse>::getNumListeners() == 1);
  EventSender<dvShutdown>::add(*thisDevice);
  assert(EventSender<dvShutdown>::getNumListeners() == 1);
  EventSender<dvTelemetryFrame>::add(*thisDevice);
  assert(EventSender<dvTelemetryFrame>::getNumListeners() == 1);

  thisDevice->cd = new mdDGChannel( io_, 0 , 1 );
  thisDevice->md = new mdDGChannel( io_, 0 , 0 );

  } catch(...) {
     theseLogs.logNdebug(-1,0,"Unknown error in device initialization block.");
  }

  theseLogs.logNdebug(NORMAL_DEBUG*2,0,"Device instantiated, starting MD embedded foreground.");

  deviceIsRunning = true;
  deviceRunning.notify_all();
  
  io_.run();
  theseLogs.logNdebug(0,0,"runEmbedded asio ended");
  
}
void runDevice() {   thisDevice->run(); }
void runDataLayer() {

  boost::unique_lock<boost::mutex> liveLock(mutAlive);
 
  if (!deviceIsRunning) {
     theseLogs.logN(1,"Waiting for device to initialize MD background on port %d ...",thisConfig->telemetryPort);
     deviceRunning.wait(liveLock);
  }
     theseLogs.logN(1,"Initializing MD background on port %d ...",thisConfig->telemetryPort);

  try {

    thisDevice->cd = new mdDGChannel(io_, thisConfig->telemetryPort );
    theseLogs.logN(0,"... main bus background running.");
    thisDevice->pulse = new mdDVHeartbeat();
    thisDevice->pulse->init();
    boost::thread myPulse(pulse);   
    mdDDAPI->data_layer = new boost::thread(runDevice);
    assert(myPulse.joinable());   
    assert(mdDDAPI->data_layer->joinable());   
    mdDDAPI->telemetry = new boost::thread(stream); 
    assert(mdDDAPI->telemetry->joinable());    
    thisDevice->alive = true;
    io_.run();
    myPulse.join();
    mdDDAPI->telemetry->join();

  }
  catch (std::exception& e)
  {
   theseLogs.logN(1,"Fatal error in data layer: %s .",e.what());
  }
  catch (...)
  {
   theseLogs.logN(0,"Unknown failure in datalayer.");
  }

  theseLogs.logNdebug(1,0,"asio background io service ended.");

}
void setStrMsg(mdDG &mdg,const char *str,
               mdDGtype md_DG_type,mdDGtype md_DG_subtype,
               const char *extraString=""  ) {

 mdg.dg.hdr.msgType      = md_DG_type;
 mdg.dg.hdr.dgSubType    = md_DG_subtype;
 mdg.dg.hdr.clientType   = thisConfig->thisDeviceType;
 strcpy(&mdg.dg.payLoad[0],(char *)str); 
 mdg.dg.hdr.primeOffset  = strlen((char *)str) + 1;
 strcpy((char *)(&mdg.dg.payLoad[mdg.dg.hdr.primeOffset]),extraString);
 mdg.dg.hdr.payloadSize  = mdg.dg.hdr.primeOffset + strlen(extraString) + 1;

}
void shutdown() {
   
    dvShutdown bye = dvShutdown();
    bye.send();

}
void stream() {
  
  boost::asio::deadline_timer t1(io_, boost::posix_time::seconds(MD_REFRESH));
  while (!thisDevice->shuttingDown) 
  {t1.async_wait(trCallback);
   boost::system_time const alarum=boost::get_system_time() + boost::posix_time::seconds(2*MD_REFRESH);
   boost::this_thread::sleep(alarum);
  }

}
void trCallback(const boost::system::error_code& error) {

    if (!thisConfig->cdConnected) {

      char portStr[10];

      if (thisConfig->cdAddress.empty()) return;
      sprintf(portStr,"%d",thisConfig->cdPort);
      std::string cdPort(portStr);
 
      if (!thisDevice->cd->connect_to(thisConfig->cdAddress,cdPort,1)) {
          theseLogs.logNdebug(NORMAL_DEBUG,0,"attempt to connect to CD failed.");
          return;
      } else 
          {theseLogs.logNdebug(NORMAL_DEBUG,0,"connected to CD.");
           *mdDDAPI->cdConnected = true;
          }

    }

    dvTelemetryFrame thisFrame;
    thisFrame.send();

}
void dvWQ() {

    while(!thisConfig->terminateRequest) {      
       if (!thisConfig->yield && thisDevice->q.size())
       { thisDevice->dispatch(thisDevice->q.top()); thisDevice->q.pop(); }
       else 
           boost::this_thread::yield();
    }

}
