#ifndef MD_CHARGUI
#define MD_CHARGUI

class mdCommander {

  bool         acceptingInput;
  bool         SCPImode;         // false implies CLIPS mode
  int          mdStdDevIdx;
  std::string  currentDevice;

 public:
 
    mdCommander() {mdStdDevIdx=0;}
   ~mdCommander() {}

    void driver();
    void greet();
    void help();
    bool scpi(char *command); 

};

#endif
