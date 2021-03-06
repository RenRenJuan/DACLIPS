#include <cassert>
#include <cstdarg>
#include <cstdlib>
#include <iostream>
#include <boost/thread.hpp>
#include <boost/asio.hpp>
#include <boost/bind.hpp>
#include <boost/date_time/posix_time/posix_time.hpp>
#include <Category.hh>
#include <FileAppender.hh>
#include <PatternLayout.hh>
#include "Listener.h"
#include "EventSender.h"
#include "TimeStampedEvent.h"
#include "PolymorphEvent.h"
