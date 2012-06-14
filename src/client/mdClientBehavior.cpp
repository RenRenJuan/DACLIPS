// mdClientBehavior.cc - xmlrpc-c C++ proxy class
// Auto-generated by xml-rpc-api2cpp.

#include <xmlrpc-c/oldcppwrapper.hpp>
#include "mdClientBehavior.h"

XmlRpcValue /*array*/ mdClientBehavior::getCommandList (XmlRpcValue::int32 const int1, std::string const string2) {
    XmlRpcValue params(XmlRpcValue::makeArray());
    params.arrayAppendItem(XmlRpcValue::makeInt(int1));
    params.arrayAppendItem(XmlRpcValue::makeString(string2));
    XmlRpcValue result(this->mClient.call("behavior.getCommandList", params));
    return result;
}

std::string mdClientBehavior::command (XmlRpcValue::int32 const int1, XmlRpcValue /*struct*/ struct2) {
    XmlRpcValue params(XmlRpcValue::makeArray());
    params.arrayAppendItem(XmlRpcValue::makeInt(int1));
    params.arrayAppendItem(struct2);
    XmlRpcValue result(this->mClient.call("behavior.command", params));
    return result.getString();
}
