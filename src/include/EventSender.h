#ifndef EVENT_SENDER_H
#define EVENT_SENDER_H

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

#include <list>
#include <typeinfo>
#include <string>
#include <sstream>

#include "Listener.h" // uses inline
#include "EventFWD.h"
#include "PolymorphEvent.h"
//class PolymorphEvent;

template <typename EvType>
class EventSender
{
    public: // types
        /// Simpler form of Listener<EvType>
        typedef Listener<EvType> TListener;
        
    private: // types
        /// So Listener<EvType> can call register etc
        friend class Listener<EvType>;
        /// Short form of std::list<TListener*>.
        typedef std::list<TListener*> Registry;
    
    public: // static methods
        class IllegalSendError;
        inline static void remove(TListener&);
        inline static void add(TListener&);
        inline static void send(const EvType&);
        inline static bool isSending();
        inline static bool hasListeners();
        inline static unsigned int getNumListeners();
        inline static unsigned int getMinNumIgnored();
        
    private: // construct/destroy singleton
        EventSender(): _isBusySending(false), _eventIgnored(0) {}
        ~EventSender();
        
    private: // methods called by Listener
        void registerListener(TListener*);
        void removeListener(TListener*);
        void incEventIgnored() {_eventIgnored ++;}
        static EventSender<EvType>& instance(); // MUST NOT BE INLINE
        
    private: // utility methods 
        void sendEvent(const EvType&);
        void cleanupQueues();
        bool removeFrom(Registry&, TListener*);
        inline std::string lisnrID(TListener* = NULL) const;
        //bool hasListener(TListener*) const;
    
    private: // data
        /// Registry of listeners that want to hear events of this type   
        Registry _registry;
    
        /// True if EvType events are being sent (ie calling listeners)
        bool _isBusySending;
        /// How many listeners ignored the last event sent (so far)
        unsigned int _eventIgnored;
        /// The queue for registering listeners when send() is in progress
        Registry _registrationQueue;
        /// The queue for removing listeners when send() is in progress
        Registry _removalQueue;
};
        
/** Specialization of EventSender for events inheriting 
    from PolymorphEvent. This provides a natural alternative 
    to the call on Polymorph::send(). 
    */
template <>
class EventSender<PolymorphEvent>
{
    public: 
        /** Send the polymorphic event to its listeners. It simply calls
            PolymorphEvent::send(), which must be overriden by subclasses
            of PolymorphEvent to call EventSender<EvType>::send(const EvType&). 
            Hence see the latter for more info.
            */
        static void send(const PolymorphEvent& event)
        {
            event.send();
        }
};

/*  Include IllegalSendError in this header so users don't have 
    to include manually. It has to be included after class definition
    since it is an inner class to EventSender. 
    */
#include "IllegalSendError.h" 

/** Are there listeners currently registered? If this returns false, 
    creating and send()ing and event just wastes cpu cycles since no
    one will hear event.
    \return true if there are listeners in registry
    */
template<typename EvType>
inline bool 
EventSender<EvType>::hasListeners()
{
    return ! instance()._registry.empty();
}

/** Get how many listeners have ignored the event 
    that is currently being sent and that they have received. 
    This number is reset to 0 before every call to send(const EvType&).
    This number is a minimum, since a listener is not required to 
    tell EventSender<EvType> that it is ignoring an event.
    */
template<typename EvType>
inline unsigned int 
EventSender<EvType>::getMinNumIgnored() 
{
    return instance()._eventIgnored;
}
       
/** Get how many listeners are currently registered. Note that if 
    isSending() is true, then this number does not take into account
    listeners that are queued for registration/removal. 
    */ 
template<typename EvType>
inline unsigned int 
EventSender<EvType>::getNumListeners() 
{
    return instance()._registry.size();
}
        
/** Send the \a event to its listeners. 

    - Upon return, getNumIgnored() will have the number of
      listeners who have ignored the event. 
    - If one of the called listeners calls registerListener or
      removeListener, the operation will be queued and processed only
      after the event has been sent to all listeners.  This insures the
      integrity of the list of listeners during the send()
      process.
    - Throws an exception if called while another send() is 
      taking place, see IllegalSendError. You can use 
      isSending() to test whether a send is taking place.
    - All other exceptions are caught

    \exception IllegalSendError
    */
template<typename EvType>
inline void 
EventSender<EvType>::send(const EvType& event) 
{
    instance().sendEvent(event);
}

/** Is this event sender currently sending the event to
    its listeners? True if yes, false otherwise. 
    */
template<typename EvType>
inline bool 
EventSender<EvType>::isSending() 
{
    return instance()._isBusySending;
}

/** Remove the \a listener from the registry. Does
    nothing if the listener is not in the registry. 
    */
template<typename EvType>
inline void 
EventSender<EvType>::remove(TListener& listener) 
{
    listener.TListener::ignoreEvents();
}

/** Add the \a listener to the registry. Does nothing
    if the listener is already registered. 
    */
template<typename EvType>
inline void 
EventSender<EvType>::add(TListener& listener) 
{
    listener.TListener::listenForEvents();
}

/// Shortcut for TypeID of a listener
template<typename EvType>
inline std::string 
EventSender<EvType>::lisnrID(TListener* lisnr)
const 
{
    std::ostringstream lisnrStr;
    lisnrStr << typeid(TListener).name();
    if (lisnr) lisnrStr << ":" << lisnr;
    return lisnrStr.str();
}
            
//#ifdef __GNUG__ 
//  // because gcc doesn't handle separate template definition
//  #include "EventSender.cc"
//#endif

#endif // EVENT_SENDER_H

