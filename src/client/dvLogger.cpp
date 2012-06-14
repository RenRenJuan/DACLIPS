#define DV_DLL
#include "md_device.h"

void dvLogger::init(const char *baseName) {

    const  char      *defaultBasename = "auc-dv-main";

    if (!strlen(baseName)) strcpy(mainLogFileName,defaultBasename);
    else                   strcpy(mainLogFileName,baseName);
    strcat(mainLogFileName,".log");

    strcpy(dvLogWork,thisConfig->logPath);
    strcat(dvLogWork,"/");
    strcat(dvLogWork,mainLogFileName);                 
    strcpy(thisConfig->logPath,dvLogWork);
    logPath = dvLogWork;

    logFile=fopen(logPath,"a");
    
}
void dvLogger::logN(int n, const char *format, ...) {
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
   logPrint("INFO dv_core",buff);
}
void dvLogger::logNdebug(int n, const char *format, ...) {
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
   logPrint("WARN dv_dbug",buff);
}
void dvLogger::logNdebug(int m, int n, const char *format, ...) {
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
   logPrint("WARN dv_dbug",buff);
}
void dvLogger::logNdev(int n, const char *format, ...) {
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
   logPrint("WARN dv_devl",buff);
}
