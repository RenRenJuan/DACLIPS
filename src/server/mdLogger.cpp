#include "auc-md.h"

#include "log4cpp/Category.hh"
#include "log4cpp/Appender.hh"
#include "log4cpp/FileAppender.hh"  
#include "log4cpp/Layout.hh"
#include "log4cpp/BasicLayout.hh"
#include "log4cpp/Priority.hh"
   
using namespace log4cpp;

    Appender                                                     *app;
    char                                               mdLogWork[256]; 
    Category &root    = Category::getRoot(),    
             &md_core = Category::getInstance(std::string("md_core")),
             &md_dbug = Category::getInstance(std::string("md_dbug")),
             &md_devl = Category::getInstance(std::string("md_devl"));
    PatternLayout                                             *layout;
    char     *logPath,*mainLogFileName,xmlrpcLogFileName;

void mdLogger::init() {

      const char *mainLogFileName   = "auc-md.log",
                 *xmlrpcLogFileName = "auc-xmlrpc.log";

        logPath = new char [strlen(thisConfig->logPath) +
                            strlen(xmlrpcLogFileName) + 2];

        strcpy(logPath,thisConfig->logPath);
        strcat(logPath,"/");
        strcat(logPath,xmlrpcLogFileName);

        thisConfig->xmlrpcLogpath = logPath;

        logPath = new char [strlen(thisConfig->logPath) +
                            strlen(mainLogFileName) + 1];

        strcpy(logPath,thisConfig->logPath);
        strcat(logPath,"/");
        strcat(logPath,mainLogFileName);

        thisConfig->logPath = logPath;

	app    = new FileAppender("default", std::string(logPath));
        layout = new PatternLayout();
        layout->setConversionPattern("%d %p %c %x: %m%n");
        app->setLayout(layout);

	root.addAppender(app);
	root.setPriority(Priority::ERROR);

        md_core.setPriority(Priority::INFO);
        md_core.setAdditivity(true);  

	md_dbug.setPriority(Priority::DEBUG);
        md_dbug.setAdditivity(true);
  	
	md_devl.setPriority(Priority::NOTSET);
        md_devl.setAdditivity(true);
    
}
void mdLogger::logN(int n, const char *format, ...) {
   char    buff[1024];
   void      *args[4];
   int     nthArg = 0;
   va_list lm;

   va_start(lm,format);
   for (;nthArg<n;nthArg++) args[nthArg]=va_arg(lm,void *);
   va_end(lm);

   switch(n) {
    case 0:
      strcpy(buff,format);
      break;
    case 1:    
      sprintf(buff,format,args[0]);
      break;
    case 2:    
      sprintf(buff,format,args[0],args[1]);
      break;
    case 3:    
      sprintf(buff,format,args[0],args[1],args[2]);
      break;
    case 4:    
      sprintf(buff,format,args[0],args[1],args[2],args[3]);
      break;
    case 5:    
      sprintf(buff,format,args[0],args[1],args[2],args[3],args[4]);
      break;
   }
   md_core.info(buff);
}
void mdLogger::logNdebug(int m, int n, const char *format, ...) {
   char    buff[1024];
   void      *args[6];
   int     nthArg = 0;
   va_list lm;

   if (m < 0 || m > thisConfig->debugThreshold) return; 

   va_start(lm,format);
   for (;nthArg<n;nthArg++) args[nthArg]=va_arg(lm,void *);
   va_end(lm);

   switch(n) {
    case 0:
      strcpy(buff,format);
      break;
    case 1:    
      sprintf(buff,format,args[0]);
      break;
    case 2:    
      sprintf(buff,format,args[0],args[1]);
      break;
    case 3:    
      sprintf(buff,format,args[0],args[1],args[2]);
      break;
    case 4:    
      sprintf(buff,format,args[0],args[1],args[2],args[3]);
      break;
    case 5:    
      sprintf(buff,format,args[0],args[1],args[2],args[3],args[4]);
      break;
   }
   md_dbug.warn(buff);
}
void mdLogger::logNdev(int n, const char *format, ...) {
   char    buff[1024];
   void      *args[5];
   int     nthArg = 0;
   va_list lm;

   va_start(lm,format);
   for (;nthArg<n;nthArg++) args[nthArg]=va_arg(lm,void *);
   va_end(lm);

   switch(n) {
    case 0:
      strcpy(buff,format);
      break;
    case 1:    
      sprintf(buff,format,args[0]);
      break;
    case 2:    
      sprintf(buff,format,args[0],args[1]);
      break;
    case 3:    
      sprintf(buff,format,args[0],args[1],args[2]);
      break;
    case 4:    
      sprintf(buff,format,args[0],args[1],args[2],args[3]);
      break;
    case 5:    
      sprintf(buff,format,args[0],args[1],args[2],args[3],args[4]);
      break;
   }
   md_devl.warn(buff);
}
