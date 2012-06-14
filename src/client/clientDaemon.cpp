#include "auc-cd.h"
#include "../server/Listener.cpp"
#include "../server/EventSender.cpp"
#include <time.h>

using namespace std;
using boost::asio::ip::udp;

void hbCallback(const boost::system::error_code&);
void stream();
void trCallback(const boost::system::error_code& error);

void mdCliever::processEvent(  const cdIncoming &dgEvent )
{      
   assert(EventSender<cdIncoming>::isSending());
    
   switch(dgEvent.dg.hdr.msgType) {
     case MDDG_NEWBORN:
     switch(dgEvent.dg.hdr.clientType) {
       case MDDEV_MD:
         if (dgEvent.dg.hdr.sinkHandle) {
           myHandle = dgEvent.dg.hdr.sinkHandle;
           theseLogs.logN(1,"Got handle (%d) from MD. End of natal sequence for this cliever.",myHandle);         
         }
         else if (!myHandle)
           theseLogs.logN(0,"MD rejected natal sequence. Please kill me and call tech. support."); 
         break;
       case MACHINE:
         break;
       case MDDEV_INSTRUMENT:
         break;
     }
     break;
   }

}
void mdCliever::processEvent( const cdHeartbeat &thisPulse )
{
    assert(EventSender<cdHeartbeat>::isSending());
   
    myPulse.dg.hdr.msgSN         = sentMsgCount[MDDG_HEARTBEAT][0]++;
    myPulse.dg.hdr.sourceHandle  = myHandle;
    strcpy(myPulse.dg.payLoad,thisConfig->telemetryPortStr.c_str());
    myPulse.dg.hdr.primeOffset   = strlen(thisConfig->telemetryPortStr.c_str()) + 1;
    strcpy((char *)(&myPulse.dg.payLoad[strlen(myPulse.dg.payLoad)+1]),"CLIEVER");
    myPulse.dg.hdr.payloadSize   = myPulse.dg.hdr.primeOffset + strlen("CLIEVER") + 1;
    fg->send_to(myPulse.dg, myStdDevIdx );
    theseLogs.logNdebug(MAX_DEBUG,1,"Heartbeat (%d)",sentMsgCount[MDDG_HEARTBEAT][0]);

}
void mdCliever::processEvent(  const cdInteractiveCommand &cmdEvent )
{      
    assert(EventSender<cdInteractiveCommand>::isSending());

}
void mdCliever::processEvent(  const cdShutdown &bye )
{      
    assert(EventSender<cdShutdown>::isSending());
    shuttingDown = true;    
    theseLogs.logN(0,"Shutting down: draining work for immediate exit.");

}
void mdCliever::processEvent(  const cdTelemetryFrame &thisFrame )
{      
    assert(EventSender<cdTelemetryFrame>::isSending());

}
void mdCliever::processEvent( const cdResponse &thisReply )
{
    const void *queued = &thisReply;

    assert(EventSender<cdResponse>::isSending());
    queue(new mdWQitem( queued, MD_NEWBORN, 0 ));

}
void mdDGChannel::handle_receive_from(const boost::system::error_code& error,
      size_t bytes_recvd)
{
   if (!error && bytes_recvd > 0)
   {
     cdIncoming  incoming( *(thisCliever->bg) );

     if (incoming.dg.hdr.clientType >= 0 && incoming.dg.hdr.clientType <  N_MDDEV_TYPES)
     {theseLogs.logNdebug(MAX_DEBUG,2,"msgtype %d received from a '%s'.",incoming.dg.hdr.msgType,clientTypes[incoming.dg.hdr.clientType]);
      incoming.ip = p_endpoint_;
      incoming.send();

     } else
        theseLogs.logNdebug(1,1,"msgtype %d received from unknown MD client type, ignored.",incoming.dg.hdr.msgType);

    }
    passive_.async_receive_from(
          boost::asio::buffer(data_, MD_MAX_DATAGRAM), p_endpoint_,
          boost::bind(&mdDGChannel::handle_receive_from, this,
            boost::asio::placeholders::error,
            boost::asio::placeholders::bytes_transferred));

}
void mdCliever::dispatch(mdWQitem *next) {

   switch(next->kind) {
    case MD_NEWBORN: 
      break;
   }
   delete next;

}
void mdCDHeartbeat::nextBeat(const boost::system::error_code& error) { thisCliever->myPulse.send(); }
void mdCDHeartbeat::run() {

      while (!thisCliever->shuttingDown) 
      {t0->async_wait(hbCallback);
       if (thisCliever->myHandle)
           sleep(60*MD_HEARTBEAT);
        else
           sleep(10*MD_HEARTBEAT);
      }

}
void hbCallback(const boost::system::error_code& error) { if (thisCliever->alive) thisCliever->pulse->nextBeat(error); }
void pulse() {
  if ((thisCliever->connected=thisCliever->fg->connect_to( thisConfig->mdAddress, thisConfig->telemetryPortStr )))
  theseLogs.logNdebug(NORMAL_DEBUG,2,"Cliever connection open on: MD @ %s port %s.", thisConfig->mdAddress.c_str(),thisConfig->telemetryPortStr.c_str());
  else
  theseLogs.logNdebug(NORMAL_DEBUG*2,2,"Cliever UDP socket open on: MD @ %s port %s failed.", thisConfig->mdAddress.c_str(),thisConfig->telemetryPortStr.c_str());               
  if (thisCliever->connected)
      thisCliever->pulse->run();                               
}
void runCliever() {

 try {  cb[0] = new mdCB();

  thisCliever = new mdCliever(thisConfig);

  EventSender<cdHeartbeat>::add(*thisCliever);
  assert(EventSender<cdHeartbeat>::getNumListeners() == 1);
  EventSender<cdIncoming>::add(*thisCliever);
  assert(EventSender<cdIncoming>::getNumListeners() == 1);
  EventSender<cdShutdown>::add(*thisCliever);
  assert(EventSender<cdShutdown>::getNumListeners() == 1);
  EventSender<cdTelemetryFrame>::add(*thisCliever);
  assert(EventSender<cdTelemetryFrame>::getNumListeners() == 1);
  EventSender<cdInteractiveCommand>::add(*thisCliever);
  assert(EventSender<cdInteractiveCommand>::getNumListeners() == 1);

  thisCliever->fg = new mdDGChannel( io_fg, 0 );

  } catch(...) {
     theseLogs.logNdebug(-1,0,"Unknown error in Cliever initialization block.");
  }

  theseLogs.logNdebug(NORMAL_DEBUG*2,0,"Cliever instantiated, starting heartbeat and telemetry stream.");

  thisCliever->alive = true;
  io_fg.run();
  theseLogs.logNdebug(0,0,"runCliever asio ended");
  
}
void runDataLayer() {

  int assertCliever;

  theseLogs.logN(1,"Spin to attach  MD datalayer background on port %d ...",thisConfig->telemetryPort);

  for(assertCliever=0;!thisCliever        && assertCliever < MAX_DEBUG;assertCliever++);
  for(assertCliever=0;!thisCliever->alive && assertCliever < MAX_DEBUG;assertCliever++);

  try {

    thisCliever->bg = new mdDGChannel(io_bg, thisConfig->telemetryPort );
    theseLogs.logN(0,"... main bus background running.");
    thisCliever->pulse = new mdCDHeartbeat();
    thisCliever->pulse->init();
    boost::thread myPulse(pulse);
    assert(myPulse.joinable());   
    boost::thread telemetryStream(stream);        
    assert(telemetryStream.joinable());
    io_bg.run();
    myPulse.join();
    telemetryStream.join();

  }
  catch (std::exception& e)
  {
   theseLogs.logN(1,"Fatal error in data layer bg: %s .",e.what());
  }
  catch (...)
  {
   theseLogs.logN(0,"Unknown failure in datalayer bg.");
  }

  theseLogs.logNdebug(1,0,"asio background io service ended.");

}
void shutdown() {
   
    cdShutdown bye = cdShutdown();
    bye.send();

}
void stream() {

  boost::asio::deadline_timer t1(io_bg, boost::posix_time::seconds(MD_REFRESH));
  while (!thisCliever->shuttingDown) 
  {t1.async_wait(trCallback);
   sleep(2*MD_REFRESH);
  }

}
void trCallback(const boost::system::error_code& error) {

    cdTelemetryFrame thisFrame;
    thisFrame.send();

}
