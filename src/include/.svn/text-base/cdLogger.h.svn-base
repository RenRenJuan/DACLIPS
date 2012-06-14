#ifndef CLIEVER_LOGGER
#define CLIEVER_LOGGER

#include "log4cpp/Category.hh"
#include "log4cpp/Appender.hh"
#include "log4cpp/FileAppender.hh"
#include "log4cpp/Layout.hh"
#include "log4cpp/BasicLayout.hh"
#include "log4cpp/Priority.hh"

using namespace log4cpp;

class cdLogger {
public:
    char                         *logPath;

   cdLogger() {};

   void init(const char * = "");
   void logN(int n, const char *format, ...);
   void logNdebug(int n, const char *format, ...);
   void logNdebug(int m, int n, const char *format, ...);
   void logNdev(int n, const char *format, ...);

  ~cdLogger(){};

};

#endif
