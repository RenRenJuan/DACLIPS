#ifndef ILLEGAL_SEND_ERROR_H
#define ILLEGAL_SEND_ERROR_H

/** 
    \file
    Class template definition file.
    
    \copyright
    Copyright (C) 2002, 2003 Oliver Schoenborn
    
    This software is provided 'as-is', without
    any express or implied warranty. In no event
    will the authors be held liable for any
    damages arising from the use of this
    software.
                                 
    You can redistribute it and/or modify it
    under the terms found in the LICENSE file that 
    is included in the library distribution. 
    \endcopyright
*/

#include <string>
#include <sstream>
#include <typeinfo>
#include <stdexcept>

/**
    \class EventSender<EvType>::IllegalSendError
    
    An exception that gets thrown when EventSender<EvType>::send() is called
    recursively at least once. This situation is more likely in complex
    systems where events cause other events to be generated.

    An example scenario is where you create an Type1Event and call
    EventSender<Type1Event>::send(Type1Event).  This call to send() in turn
    calls the processEvent() method of a listener of Type1Event's.
    If this listener's method creates another Type1Event and calls
    EventSender<Type1Event>::send(Type1Event) on it, this will cause that
    listener's processEvent() to be called once more, and the
    process repeats.  This is likely to trigger an infinite loop of
    event generation.  The only case where this would not happen is if
    the listener keeps state information that changes between successive
    calls to processEvent(), such that it does not generate an event
    during one of those calls (the recursion ends), or if this listener
    deregister's itself from listening.

    Since an infinite recursion is likely to cause a program crash, and
    since it is quite easy to make that kind of mistake, EventSender<EvType>
    forbids calling send() while a send() (for that event type) is
    in progress.  It will throw a EventSender<EvType>::IllegalSendError if
    such a situation occurs.

    \author Oliver Schoenborn 
    \since Sept 2002
*/

template<typename EvType> 
class EventSender<EvType>::IllegalSendError
    : public std::logic_error
{
    public:
        /// Create the exception
        IllegalSendError() : std::logic_error( msg() ) {}

    private:
        /// Prefix for each new line
        static std::string nl() throw()  { return "\n!!! "; }
        
        /// The message to give to std::logic_error constructor.
        static std::string msg()
        {
            std::ostringstream ss;
            ss << nl() << "BUG alert (Recursive send forbidden): "
               << nl() << "Method send() of " << typeid(EventSender<EvType>).name()
               << nl() << "calls itself indirectly through listeners"
               << nl() << "(forbidden since could lead to infinite loop).";
            return ss.str();
        }
};

#endif // ILLEGAL_SEND_ERROR_H
