#define  MD_CORE
#include "auc-md.h"
#include "masterDaemon.h"
#include "coreapi.h"
#include "../server/Listener.cpp"
#include "../server/EventSender2.cpp"

void attention();
void arCallback(const boost::system::error_code& error);
void mdWQ();

void masterDaemon::dispatch(mdWQitem *next) {

  bool                                    success;
  boost::system::error_code                    ec;
  const char                             *failure;
  int                            sentBytes,step=1;
  mdResponse *ackOrNak = (mdResponse *)next->what;

   switch(next->kind) {
    case DV_MDQUERY:
       failure = (const char *)&ackOrNak->reply.dg.payLoad[0];
       success = ackOrNak->reply.dg.hdr.dgType.value == 1;
       goto commonReply;
    case MD_NEWBORN:     
       ackOrNak->reply.dg.hdr.msgType   = MDDG_NEWBORN;
       failure = "Stillbirth";
       success = ackOrNak->mdStdDevIdx >= 0;       
     commonReply:
       assert(cb.find(ackOrNak->mdStdDevIdx) != cb.end());
       ackOrNak->reply.dg.hdr.clientType = MDDEV_MD;
       if (success) {
       if (!cb[ackOrNak->mdStdDevIdx]->connection.open) {
           ackOrNak->bus->connect_to(ackOrNak->ip,ec,step,ackOrNak->mdStdDevIdx);
           if (cb[ackOrNak->mdStdDevIdx]->connection.open) {                 
               if ((sentBytes=ackOrNak->bus->send(ackOrNak->reply,ec)) != sizeof(mdDGReply))
                   theseLogs->logNdebug(1,2,"incomplete blocking send: %d: %s",sentBytes,ec.message().c_str());
           } 
           else 
           theseLogs->logNdebug(1,2,"Couldn't get back channel to client: %s (in step %d).",ec.message().c_str(),step);
       }
        else if ((sentBytes=ackOrNak->bus->send(ackOrNak->reply,ec)) != sizeof(mdDGReply))
                theseLogs->logNdebug(1,2,"incomplete blocking send: %d: %s",sentBytes,ec.message().c_str());

       } else {
         theseLogs->logNdebug(1,0,failure);
       }
       delete ackOrNak;
      break;
   }
   delete next;

}
/*
 * Prenatal heartbeats and commands are not queued.
 * Everything else is.
 *
 */
void masterDaemon::dispatch(const mdIncoming &what) {

    bool        isObservation;
    const char *name,*xStr;
    int         about=what.dg.hdr.handle;
    md_device     thisKind;
    mdInstrument *d1;
    mdMachine    *d2;

    map<int,mdLiveClient*>::iterator iter = thisConfig->allClients.find(about);

    switch(what.dg.hdr.msgType) {
     case MDDG_CDRESET:
        theseLogs->logN(0,"Shutdown request received from a Cliever"); 
        thisConfig->halt = true;
        break;
     case MDDG_MDQUERY:
       if( iter == thisConfig->allClients.end() )
         theseLogs->logN(1,"Query for device whose handle (%d) has disappeared, ignored.", about );  
       else { 
       thisKind = thisConfig->allClients[about]->devType;
       name     = &what.dg.payLoad[0];
       xStr     = &what.dg.payLoad[what.dg.hdr.primeOffset];
       switch(what.dg.hdr.dgSubType) {
         case MDDG_REGSCPI:
           theseLogs->logNdebug(NORMAL_DEBUG,4,"Src SCPI: '%s' from type: %d ('%s'), handle %d.", name, what.dg.hdr.clientType,xStr,about); 
           if  (thisKind == MACHINE) theMachine->registerCmd(name,what);
           else thisConfig->instruments[about]->registerCmd(name,what);
         break;
         case MDDG_REGODE:
           theseLogs->logNdebug(NORMAL_DEBUG,4,"Src ODE: '%s' from type: %d ('%s'), handle %d.", name, what.dg.hdr.clientType,xStr,about); 
           goto regName;
         case MDDG_REGOBS:
           theseLogs->logNdebug(NORMAL_DEBUG,4,"Src Obs: '%s' from type: %d ('%s'), handle %d.", name, what.dg.hdr.clientType,xStr,about);    
          regName:
           if  (thisKind == MACHINE) theMachine->state.registerData(name,what);
           else thisConfig->instruments[about]->state.registerData(name,what);
         break;
       }}
       break;
     case MDDG_HEARTBEAT:
       if (!what.dg.hdr.sourceHandle) {
          if (what.dg.hdr.clientType < MDDEV_CD || what.dg.hdr.clientType > MDDEV_DATACLIENT) {
           theseLogs->logN(1,"Heartbeat from unknown client type: %d, ignored.", what.dg.hdr.clientType);         
           break;
          }
          theseLogs->logNdebug(NORMAL_DEBUG*4,1,"Heartbeat from new %s ...",clientTypes[what.dg.hdr.clientType]);
          if (what.dg.hdr.primeOffset >= 5) {
                 mdClientBirth itsAWhat;
                 name  = (char *)(&what.dg.payLoad[what.dg.hdr.primeOffset]);
             theseLogs->logNdebug(NORMAL_DEBUG*4,1," ... its telemetry port is %s.",what.dg.payLoad);   
             theseLogs->logNdebug(NORMAL_DEBUG*4,1," ... '%s' will be its _deviceName.",name);
             itsAWhat.dg           = what.dg;
             itsAWhat.ip           = what.ip;
             itsAWhat.ip.port((unsigned short)atoi(what.dg.payLoad));
             itsAWhat.dgDetermined = true;
             itsAWhat.send();
          }
          else
           theseLogs->logN(1,"Heartbeat didn't appear to say what port to use, ignored.");      
        }
       else {
        theseLogs->logNdebug(MAX_DEBUG,2,"Heartbeat from client with handle: %d.",what.dg.hdr.sourceHandle);
       }
       break;
     }

}
int masterDaemon::initBaseAPI(void) {

    int rc=OK;

    try {

    theseLogs->logN(0,"Create Generic Core API");

    xmlrpc_c::methodPtr const registerDeviceP(new registerDevice(thisService->cfg)); 
    xmlrpc_c::methodPtr const getMDversionP(new getMDversion);
    xmlrpc_c::methodPtr const getP(new getter);
    xmlrpc_c::methodPtr const setP(new setter);
    xmlrpc_c::methodPtr const getCmdListP(new cmdListFetch);
    xmlrpc_c::methodPtr const getCmdP(new cmd);
    xmlrpc_c::methodPtr const createP(new create);

    thisConfig->api_registry.addMethod("device.registeR",         registerDeviceP );
    thisConfig->api_registry.addMethod("state.getMDversion",      getMDversionP );
    thisConfig->api_registry.addMethod("state.create",            createP);
    thisConfig->api_registry.addMethod("state.get",               getP );
    thisConfig->api_registry.addMethod("state.set",               setP );
    thisConfig->api_registry.addMethod("behavior.getCommandList", getCmdListP );
    thisConfig->api_registry.addMethod("behavior.command",        getCmdP );

    }
    catch(...) 
    { rc = NOT_OK; }

    return rc;

}
void masterDaemon::listen() {

  EventSender<mdAttention>::add(*this);
  assert(EventSender<mdAttention>::getNumListeners() == 1);
  EventSender<mdCDPulse>::add(*this);
  assert(EventSender<mdCDPulse>::getNumListeners() == 1);
  EventSender<mdClientBirth>::add(*this);
  assert(EventSender<mdClientBirth>::getNumListeners() == 1);
  EventSender<mdClientDeath>::add(*this);
  assert(EventSender<mdClientDeath>::getNumListeners() == 1);
  EventSender<mdDeviceCommand>::add(*this);
  assert(EventSender<mdDeviceCommand>::getNumListeners() == 1);
  EventSender<mdIncoming>::add(*this); 
  assert(EventSender<mdIncoming>::getNumListeners() == 1);
  EventSender<mdResponse>::add(*this);
  assert(EventSender<mdResponse>::getNumListeners() == 1);
  EventSender<mdTelemetryFrame>::add(*this);
  assert(EventSender<mdTelemetryFrame>::getNumListeners() == 1);

  boost::thread mdAr(attention);

}
void masterDaemon::processEvent( const mdAttention &thisAR )
{
   assert(EventSender<mdAttention>::isSending());  
}
void masterDaemon::processEvent( const mdCDPulse &thisPulse )
{
   assert(EventSender<mdCDPulse>::isSending()); 
}
void masterDaemon::processEvent( const mdClientBirth &thisWhat )
{
   assert(EventSender<mdClientBirth>::isSending());
   if (thisWhat.dgDetermined) {
      deviceFactory->newFromHeartbeat(thisWhat);
    }
    else {
      deviceFactory->newFromAPI(
         thisWhat.clientType,thisWhat.signature);
   }     
}
void masterDaemon::processEvent( const mdClientDeath &thisWas )
{
   assert(EventSender<mdClientDeath>::isSending()); 
}
void masterDaemon::processEvent( const mdDeviceCommand &thisCmd )
{
   assert(EventSender<mdDeviceCommand>::isSending()); 
}
void masterDaemon::processEvent(  const mdIncoming &thisDatagram )
{      
    assert(EventSender<mdIncoming>::isSending());
    thisService->dispatch(thisDatagram);
}
void masterDaemon::processEvent( const mdResponse &thisReply )
{
    const void *queued = &thisReply;

    assert(EventSender<mdResponse>::isSending());
    queue(new mdWQitem( queued, thisReply.dCat, 0 ));

}
void masterDaemon::processEvent(  const mdTelemetryFrame &thisFrame )
{      
    assert(EventSender<mdTelemetryFrame>::isSending());
}
void masterDaemon::run() { 
 
    deviceFactory = new mdDeviceFabrik();
    fg            = new mdDGChannel( thisService->io_, 0 );

    if (initBaseAPI()) return;
    listen();
    boost::thread work(mdWQ);
    assert(work.joinable());
    theseLogs->logNdebug(MAX_DEBUG,0,"Master Daemon worker started, foreground async i/o service joins MD worker.");
    io_.run();
    work.join();

}

void mdDGChannel::handle_receive_from(const boost::system::error_code& error,
      size_t bytes_recvd)
{
   const char *c1;

   if (!error && bytes_recvd > 0)
   {
     mdIncoming     incoming(thisService->bg);
     
     incoming.ip = thisService->bg->p_endpoint_;
     c1          = thisService->bg->p_endpoint_.address().to_string().c_str();
   
     if (incoming.dg.hdr.clientType >  0 && incoming.dg.hdr.clientType <  N_MDDEV_TYPES)
     { theseLogs->logNdebug(MAX_DEBUG,3,"msgtype %d received from %s (a '%s').",incoming.dg.hdr.msgType,c1,clientTypes[incoming.dg.hdr.clientType]);     
       incoming.send();
     } else 
        theseLogs->logNdebug(1,2,"msgtype %d received from unknown MD client type at %s, ignored.",incoming.dg.hdr.msgType,c1);
    }
    passive_.async_receive_from(
          boost::asio::buffer(data_, MD_MAX_DATAGRAM), p_endpoint_,
          boost::bind(&mdDGChannel::handle_receive_from, this,
            boost::asio::placeholders::error,
            boost::asio::placeholders::bytes_transferred));
}


// Callbacks, thread runners, and other ordinary functions.

void attention() {

  bool announced = false;

  // The housekeeping routine is the only cyclic event in MD
  boost::asio::deadline_timer t0(thisService->io_, boost::posix_time::seconds(MD_HAUSHALT)); 
  while (!thisService->shuttingDown)
  {t0.async_wait(arCallback);
   sleep(2*MD_HAUSHALT);
   if (!announced) {announced = true;
                    theseLogs->logNdebug(MAX_DEBUG,0,"First invocation of housekeeping.");}
  }
  
}
void arCallback(const boost::system::error_code& error) {

  mdAttention housekeep( thisService->arCycles++ );
  housekeep.send();

}
void runMasterDaemon() {

    cb[0]           = new mdCB();
    thisService     = new masterDaemon( thisConfig );
    thisService->run();

}
void mdWQ() {

    while(!thisConfig->shutdown) {      
       if (!thisConfig->halt && thisService->q.size())
       { thisService->dispatch(thisService->q.top()); thisService->q.pop(); }
       else 
           boost::this_thread::yield();
    }

}
void runDataLayer() {

   boost::asio::io_service io_;

  theseLogs->logN(1,"Background dgram service thread starting on port %d.",thisConfig->telemetryPort);

  try {

    thisService->bg = new mdDGChannel(io_, thisConfig->telemetryPort);
    io_.run();

  }
  catch (std::exception& e)
  {
    theseLogs->logN(1,"Fatal error on main bus background: %s .",e.what());
  }
  catch (...)
  {
   theseLogs->logN(0,"Unknown failure in background datalayer.");
  }

  theseLogs->logNdebug(1,0,"mainbus background thread exited.");

}
