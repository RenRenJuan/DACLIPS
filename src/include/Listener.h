#ifndef LISTENER_H
#define LISTENER_H

/** \file
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

template <typename EvType> 
class Listener
{
    public:
        /// By default, listener not registered
        Listener(): _registered(false), _ignoringHeardEvent(false), 
                    _processingEvent(false) {}
    
        /// Automatically deregister ourselves
        virtual ~Listener() { ignoreEvents(); }
        
        void ignoreEvents();
        void listenForEvents();
        void ignoreThisEvent();
        inline void processEventPublic(const EvType&);
              
        /** Is this instance of listener registered?
            If not, it will not receive events of type EvType,
            processEvent() will not be called. To register
            it, call listenForEvents().
            \return true if *this is registered
            */
        bool isRegistered() const {return _registered;}
        
    protected:
        /** Classes that inherit from Listener must override this 
            method. This is where you react to the \a event heard. 
            \param event the event heard.
            */
        virtual void processEvent(const EvType& event) = 0;
        
    private: // methods
        inline void preProcessEvent();
        inline void postProcessEvent();

    private: // data
        /** True if our listenForEvents() method has been called,
            and false otherwise or if ignoreEvents() is called.
            */
        bool _registered;
        /// are we ignoring this event?
        bool _ignoringHeardEvent;
        /// are we ignoring this event?
        bool _processingEvent;
};

/// Pre-processing for the event.
template <typename EvType> 
inline void 
Listener<EvType>::preProcessEvent() 
{
    _ignoringHeardEvent = false;
    _processingEvent = true;
}

/// Undo any pre-processing, as required. 
template <typename EvType> 
inline void 
Listener<EvType>::postProcessEvent() 
{
    _processingEvent = false;
    // ignoringHeardEvent doesn't need touching
}

/** Process this event. This public method can be called directly
    with an event to simulate an event having been generated and heard by
    this listener. It is also called by EventSender<EvType>::send(). This
    public method is a "template pattern" method, in that it calls
    several private methods but most importantly calls the protected,
    virtual processEvent(). Since the latter is virtual it is the definition
    in the most derived class of this Listener<EvType> that will get
    called.  The event is passed as const, so listeners can't
    change the data carried by the event.
    
    \param event event to process
    */
template <typename EvType> 
inline void 
Listener<EvType>::processEventPublic(const EvType& event) 
{
    preProcessEvent();
    try {
        processEvent(event);
    }
    catch (...) {
        postProcessEvent(); 
        throw;
    }
    postProcessEvent();
}

//#ifdef __GNUG__ 
  // because gcc doesn't handle separate template definition
  //#include "Listener.cc"
//#endif

#endif // LISTENER_H
