#ifndef POLYMORPHIC_EVENT_H
#define POLYMORPHIC_EVENT_H

/** \file
    Class definition file.
    
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

//#include "EventFWD.h"

/** 
    Derive your class from a PolymorphEvent to make it usable
    polymorphically. This just requires that your event subclass then
    define the send() pure virtual method, typically simply as 
    \code
    struct ConcreteEvent: public PolymorphEvent
    {
        // ... your event-specific data and methods ...
        // ... and the override:
        virtual void send() const { sendTypedEvent(*this); }
    };
    \endcode
*/
class PolymorphEvent
{
    public:
        /** Causes this event to be sent out to all listeners. The
            subclass  must provide an override so the event can be used
            polymorphically. This allows you to have a container
            of PolymorphEvent's of unknown concrete types, e.g. to queue
            events of different types. 
            */
        virtual void send() const = 0;
    
    protected:
        /// Need virtual destructor for polymorphic queues
        virtual ~PolymorphEvent() {}
        
        /**
            The class derived from PolymorphEvent must override send()
            to make it call EventSender<EvType>::send(). It can also 
            simply override it by making it call this method, sendTypedEvent,
            with *this. This method is really just a helper to simplify the 
            syntax required for overriding send().
            */
        template <typename EvType>
        inline static void 
        sendTypedEvent(const EvType& event) {EventSender<EvType>::send(event);}

};


    
#endif // POLYMORPHIC_EVENT_H
