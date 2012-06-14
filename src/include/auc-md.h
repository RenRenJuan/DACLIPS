#include <cassert>
#include <cstdarg>
#include <cstdlib>
#include <xmlrpc-c/base.hpp>
#include <xmlrpc-c/registry.hpp>
#include <xmlrpc-c/server_abyss.hpp>
#include <xmlrpc-c/oldcppwrapper.hpp>
#include <xmlrpc-c/base.hpp>
#include <xmlrpc-c/client_simple.hpp>
#include <iostream>
#include <boost/thread.hpp>
#include <boost/date_time/posix_time/posix_time.hpp>
#include <boost/statechart/event.hpp>
#include <boost/statechart/state_machine.hpp>
#include <boost/statechart/simple_state.hpp>
#include <boost/statechart/transition.hpp>
#include <boost/bind.hpp>
#include <boost/asio.hpp>
#include <boost/shared_ptr.hpp>
#include <Category.hh>
#include <FileAppender.hh>
#include <PatternLayout.hh>
#include <map>
#include <utility>
#include <map>
#include <string>
#include <queue>
#include "Listener.h"
#include "EventSender.h"
#include "TimeStampedEvent.h"
#include "PolymorphEvent.h"
#ifdef MD_MAND
#include <clipsmm.h> 
#endif

namespace fsm = boost::statechart;

#define XMLRPC_C

#include "mdcommon.h"
#include "mdevents.h"
#include "mdLogger.h"
   
#include "mdBehavior.h"
#include "mdObservable.h"
#include "mdState.h"

#include "mdDevice.h"

#define MD_HAUSHALT         1200000              // milliseconds between attention routine
#define MD_LOCK_FILE        "auc-md.lock"                  

#include "masterDaemonConfig.h"

#ifdef MD_MAIN

         mdDeviceFabrik     *deviceFactory;
         mdLogger           *theseLogs;
         masterDaemonConfig *thisConfig;

  extern void runMasterDaemon();
  extern void runDataLayer();

#else

  extern mdDeviceFabrik     *deviceFactory;
  extern mdLogger           *theseLogs;
  extern masterDaemonConfig *thisConfig;

#endif


