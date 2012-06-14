#ifndef MD_LOGGER
#define MD_LOGGER

#include "log4cpp/Category.hh"
#include "log4cpp/Appender.hh"
#include "log4cpp/FileAppender.hh"
#include "log4cpp/Layout.hh"
#include "log4cpp/BasicLayout.hh"
#include "log4cpp/Priority.hh"

using namespace log4cpp;

class mdLogger {
public:
    char                         *logPath;

   mdLogger() {};

   void init();
   void logN(int n, const char *format, ...);
   // log iff m positive and >=  config.debugThreshold, 
   //   set in powers of 10
   void logNdebug(int m, int n, const char *format, ...); 
   void logNdev(int n, const char *format, ...);

  ~mdLogger(){};

};

#endif
