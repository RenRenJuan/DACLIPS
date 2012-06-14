// guard need for compilers that require template source included in header
#ifndef LISTENER_CC_TEMPLATE
#define LISTENER_CC_TEMPLATE

#include "Listener.h"
#include "EventSender.h"

/** 
    \file
    Class method definition file.
    
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

#include "Listener.h"
#include "EventSender.h"

/** Tell EventSender<EvType> that this listener is ignoring the event received. 
    This will increment a counter in EventSender<EvType>, such that a call to 
    EventSender<EvType>::getNumIgnored() will return how many listeners ignored
    the event. Note however that the listener is not \em required to 
    notify EventSender<EvType> that it is ignoring the event, hence this number
    is only a minimum. This method can be called more than once without
    screwing up the count. If called from outside a call to 
    Listener<EvType>::processEvent(), nothing is done. 
    */
template<typename EvType>
void 
Listener<EvType>::ignoreThisEvent()
{
    // only a valid call if processing an event
    if (! _processingEvent) return;
    
    assert( EventSender<EvType>::isSending() );
    if (! _ignoringHeardEvent) 
    {
        EventSender<EvType>::instance().incEventIgnored();
        _ignoringHeardEvent = true;
    }
    
    //assert( EventSender<EvType>::isRegistered(this) == _registered); 
}

/** Tell EventSender<EvType> that this listener is not interested in hearing 
    EvType events. This does nothing if already ignoring them. 
    */
template<typename EvType>
void 
Listener<EvType>::ignoreEvents() 
{
    if (_registered) 
    {
        EventSender<EvType>::instance().removeListener(this);
        _registered = false;
    }
    
    //assert( ! EventSender<EvType>::isRegistered(this) ); 
}

/** Tell EventSender<EvType> that this listener wants to hear
    EvType events. This does nothing if already listening to them. 
    */
template<typename EvType>
void 
Listener<EvType>::listenForEvents() 
{
    if (!_registered) 
   {
        EventSender<EvType>::instance().registerListener(this);
        _registered = true;
    }
    
    //assert( EventSender<EvType>::isRegistered(this) ); 
}

    
#endif // LISTENER_CC_TEMPLATE



