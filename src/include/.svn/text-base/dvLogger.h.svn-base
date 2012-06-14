#ifndef DEVICE_LOGGER
#define DEVICE_LOGGER
#include <time.h>

class DllExport dvLogger  {
   void logPrint(const char *level,char *buff) {

       char timeString[128];
       time_t       rawtime;
       struct tm * timeinfo;

       time ( &rawtime );
       timeinfo = localtime ( &rawtime );
       sprintf ( timeString, asctime (timeinfo) );
       if (timeString[strlen(timeString)-1] == '\n')
           timeString[strlen(timeString)-1] = 0;
       assert(logFile);
       fprintf(logFile,"%s %s %s\n",timeString,level,buff);
       fflush(logFile);
       logFile=freopen(logPath,"a",logFile);
   }
public:

   char dvLogWork[256],*logPath,mainLogFileName[128];

   FILE              *logFile;

   dvLogger() {logFile=NULL;};

   void init(const char * = "");
   void logN(int n, const char *format, ...);
   void logNdebug(int n, const char *format, ...);
   void logNdebug(int m, int n, const char *format, ...);
   void logNdev(int n, const char *format, ...);
   
  ~dvLogger(){};

};

#endif
