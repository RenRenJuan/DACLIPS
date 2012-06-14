/*! \brief registerDevice
 *         core API.
 *
 *   Singleton: All Devices must begin their interation with the MD
 *              with this and use the supplied handle sin subsequent
 *              API.
 */
class registerDevice : public xmlrpc_c::method {
private:
  masterDaemonConfig *_cfg;
public:
  registerDevice(masterDaemonConfig *cfg) {
       _cfg       = cfg;
       _signature = "i:is"; 
       _help      = "Register a client with the auc-md. The first parameter is the client type "
                    "which should be the integer value of MDDEV_DATACLIENT (currently 4) "
                    "or other md_dev type value. The string, specifies a signature identifying "
                    "client. Normally the first call to the MD after connecting, the response "
                    "if positive definite is a handle to use in further interaction referring "
                    "to the registered client. This API is primarily intended for data integrators not "
                    "device integrators but device integrators can also use if for diagnostic "
                    "purposes. Execute this API with signature 'release' to remove a MD client "
                    "in which case the first parameter should be the handle for the client to drop. "
                    "Obviously this API can cause havoc with a production MD, so use with care.";
                   }
    void
    execute(xmlrpc_c::paramList const& paramList,
            xmlrpc_c::value *   const  retvalP) {
        
        int const handleOrType(paramList.getInt(0));
        std::string stringField(paramList.getString(1));
        
        paramList.verifyEnd(2);

        if (stringField == "release")
        *retvalP = xmlrpc_c::value_int(thisService->releaseDevice(handleOrType));
        else
        *retvalP = xmlrpc_c::value_int(thisService->getDeviceHandle(handleOrType,stringField));

    }

};
/*! \brief getter
 *         core API.
 *
 *   Common getter.
 */
class getter : public xmlrpc_c::method, mdState {
public:
         getter() {
       _signature = "S:is"; 
       _help      = "Send handle, dataname, get structure answer. The the first  "
                    "character of the dataname determines its type: ODEs "
                    "(Operational Data Elements) start with an underscore, otherwise "
                    "the dataname is that of an expermental Observable. The first  "
                    "entry in the structure is always the state of the call which "
                    "will either the supplied dataname indicating success or error text. "
                    "The remainder of the structure is specific to the datatype.";
                   }

    void
    execute(xmlrpc_c::paramList const& paramList,
            xmlrpc_c::value *   const  retvalP) {
        
        int const   deviceHandle(paramList.getInt(0));
        std::string dataName(paramList.getString(1));        
        paramList.verifyEnd(2);        

        *retvalP = *mdState::get(deviceHandle,dataName);
    }

};
/*! \brief setter
 *         core API.
 *
 *   Common setter.
 */
class setter : public xmlrpc_c::method, mdState {
public:
     setter() {

       _signature =  "s:iS"; 
       _help      =  "Process a gotten  structure with changes. "
                     "Answers 'OK' or error text";
                   }

    void
    execute(xmlrpc_c::paramList const& paramList,
            xmlrpc_c::value *   const  retvalP) {
        
       int const             deviceHandle(paramList.getInt(0));
        xmlrpc_c::cstruct      returnee(paramList.getStruct(1));
        paramList.verifyEnd(2);

        *retvalP = xmlrpc_c::value_string(mdState::set(deviceHandle,returnee));
    }
};
/*! \brief create
 *         create a ndw data element.
 *
 *   Dynamically create a MD data item.
 */
class create : public xmlrpc_c::method, mdState {
public:
          create() {

       _signature =  "s:iss"; 
       _help      =  "Given a device handle, focus type, and dataname create the element. "
                     "The type string uses the standard xmplrpc-c single character  "
                     "type signatures and the name is an MD dataname whose first character "
                     "determines whether an Observable or and ODEe. Any text "
                     "following the type signature is preserved as a comment. " 
                     "Answers 'OK' or error text";
                   }

    void
    execute(xmlrpc_c::paramList const& paramList,
            xmlrpc_c::value *   const  retvalP) {
        
       int const             deviceHandle(paramList.getInt(0));
       std::string            typeSpec(paramList.getString(1));
       std::string             newName(paramList.getString(2));
       paramList.verifyEnd(3);

       *retvalP = xmlrpc_c::value_string(mdState::create(deviceHandle,typeSpec,newName));
    }

};
/*! \brief cmdListFetch
 *         core API.
 *
 *   Fetch currently defined SCPI for device.
 */


class cmdListFetch : public xmlrpc_c::method, mdCommand {
public:
  cmdListFetch() {

       _signature = "A:is"; 
       _help      = "Send handle, md_dev type, and the SCPI subsystem or subcommand. "
                    "Use empty string to get the full subsystem list. Reply will be "
                    "an array of the available command/subsystems. Only MD clients "
                    "of type MACHINE or MDDEV_INSTRUMENT can have SCPI commands defined "
                    "so it is an error to specify any other type of MD client";
                   }

    void
    execute(xmlrpc_c::paramList const& paramList,
            xmlrpc_c::value *   const  retvalP) {
       
        int const   deviceHandle(paramList.getInt(0)); 
        int const   deviceType(paramList.getInt(0));               
        std::string commandSetSpecified(paramList.getString(2));
        paramList.verifyEnd(3);        

        if (deviceType != MACHINE && deviceType != MDDEV_INSTRUMENT)
           *retvalP = xmlrpc_c::value_string(std::string("Invalid MD client type."));
        else 
        {if (thisService->validateHandleForCmds(deviceHandle))
              *retvalP = *thisService->fetchCommands(commandSetSpecified);
         else *retvalP = xmlrpc_c::value_string(std::string("Error: Device not in state where this API can execute."));

        }
    }
};
/*! \brief cmd
 *         core API.
 *
 *   Common commander.
 */
class cmd : public xmlrpc_c::method, mdCommand {
public:
             cmd() {

       _signature = "s:iS"; 
       _help      = "Given, a handle, device type, the full text of a SCPI "
                    "sends the command to the MD and if accepted to the device. "
                    "If the command is valid for the configured MD, MD  answers OK "
                    "and sends it, otherwise answers error text. Whether "
                    "or not the OK indicates anything other than a valid command "
                    "depends on the configured behavior of the device.";            
                   } 

    std::string head(std::string in) { return in; }
    std::string tail(std::string in) { return in; }
    void
    execute(xmlrpc_c::paramList const& paramList,
            xmlrpc_c::value *   const  retvalP) {

       mdCommand    *thisCommand;
       mdCommand     local;

        int                   deviceHandle(paramList.getInt(0));  
        std::string           commandText(paramList.getString(1));      
        paramList.verifyEnd(2);   
        std::string           tails=tail(commandText);

//        if (thisService->validateHandleForCmds(deviceHandle)) {
//          if (thisCommand = thisDevice->commands[head(commandText)]) 
//            *retvalP = xmlrpc_c::value_string(thisCommand->dO(thisDevice,&tails)) ;
//          else {
//            *retvalP = xmlrpc_c::value_string(std::string("Error: Can't construct SCPI Command '" + commandText + "'"));
//          }
//        }
//        else {            
//          *retvalP = xmlrpc_c::value_string(std::string("Error: Unknown Device"));
//             } 
    }
};

/*! \brief getMDversion
 *         core API.
 *
 *   Report the configuration of the MD. This API can be called at
 *   any time and does not require a device handle.
 */
class getMDversion : public xmlrpc_c::method {
public:
  getMDversion() {

       _signature = "i:s"; 
       _help      = "Accepts a device handle and returns the version identification "
         "of the MD. ";

                   }

    void
    execute(xmlrpc_c::paramList const& paramList,
            xmlrpc_c::value *   const  retvalP) {
        
        int const addend(paramList.getInt(0));
        
        paramList.verifyEnd(1);        
        *retvalP = xmlrpc_c::value_string("OpenAUC v 0.5");
    }

};

