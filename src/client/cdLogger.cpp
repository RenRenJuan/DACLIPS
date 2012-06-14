#include "auc-cd.h"

#include "log4cpp/Category.hh"
#include "log4cpp/Appender.hh"
#include "log4cpp/FileAppender.hh"  
#include "log4cpp/Layout.hh"
#include "log4cpp/BasicLayout.hh"
#include "log4cpp/Priority.hh"
   
using namespace log4cpp;

    Appender                                                     *app;
    char                                               cdLogWork[256]; 
    Category &root    = Category::getRoot(),    
             &cd_core = Category::getInstance(std::string("cd_core")),
             &cd_dbug = Category::getInstance(std::string("cd_dbug")),
             &cd_devl = Category::getInstance(std::string("cd_devl"));
    PatternLayout                                             *layout;

void cdLogger::init(const char *baseName) {

      const  char *defaultBasename = "auc-cd-99";
             char  mainLogFileName[128];

        if (!strlen(baseName)) strcpy(mainLogFileName,defaultBasename);
        else                   strcpy(mainLogFileName,baseName);
        strcat(mainLogFileName,".log");

        strcpy(cdLogWork,thisConfig->logPath);
        strcat(cdLogWork,"/");
        strcat(cdLogWork,mainLogFileName);                 
        strcpy(thisConfig->logPath,cdLogWork);
        logPath = cdLogWork;

	app    = new FileAppender("default", std::string(logPath));
        layout = new PatternLayout();
        layout->setConversionPattern("%d %p %c %x: %m%n");
        app->setLayout(layout);

	root.addAppender(app);
	root.setPriority(Priority::ERROR);

        cd_core.setPriority(Priority::INFO);
        cd_core.setAdditivity(true);  

	cd_dbug.setPriority(Priority::DEBUG);
        cd_dbug.setAdditivity(true);
  	
	cd_devl.setPriority(Priority::NOTSET);
        cd_devl.setAdditivity(true);
    
}
void cdLogger::logN(int n, const char *format, ...) {
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
   cd_core.info(buff);
}
void cdLogger::logNdebug(int n, const char *format, ...) {
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
   cd_dbug.warn(buff);
}
void cdLogger::logNdebug(int m, int n, const char *format, ...) {
   char    buff[1024];
   void      *args[5];
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
   cd_dbug.warn(buff);
}
void cdLogger::logNdev(int n, const char *format, ...) {
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
   cd_devl.warn(buff);
}
