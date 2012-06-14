// mdClientBehavior.h - xmlrpc-c C++ proxy class
// Auto-generated by xml-rpc-api2cpp.

#ifndef _mdClientBehavior_H_
#define _mdClientBehavior_H_ 1

#include <xmlrpc-c/oldcppwrapper.hpp>

class mdClientBehavior {
    XmlRpcClient mClient;

public:
    mdClientBehavior (const XmlRpcClient& client)
        : mClient(client) {}
    mdClientBehavior (const std::string& server_url)
        : mClient(XmlRpcClient(server_url)) {}
    mdClientBehavior (const mdClientBehavior& o)
        : mClient(o.mClient) {}

    mdClientBehavior& operator= (const mdClientBehavior& o) {
        if (this != &o) mClient = o.mClient;
        return *this;
    }

    /* Send handle, and the SCPI subsystem or subcommand. Use empty string to get the full subsystem list.   Reply will be an array of the available command/subsystems */
    XmlRpcValue /*array*/ getCommandList (XmlRpcValue::int32 const int1, std::string const string2);

    /* Send the full text of a SCPI command and the device handle of the device to process it. If the command is valid MD answers OK and in that case the command will be sent to specified device, otherwise answers error text. Whether or not the OK indicates anything other than a valid command depends on the configured behavior of the device. */
    std::string command (XmlRpcValue::int32 const int1, XmlRpcValue /*struct*/ struct2);
};

#endif /* _mdClientBehavior_H_ */

