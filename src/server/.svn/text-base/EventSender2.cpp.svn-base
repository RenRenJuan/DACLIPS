//#include "auc-cd.h"

#ifndef EVENT_SENDER_CC_TEMPLATE
#define EVENT_SENDER_CC_TEMPLATE

/**
    \file 
    Class template methods definition file.
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

#include <algorithm>
#include "EventSender.h"

/**
    Get the unique instance of event sender for this type of event.
    Putting it in a member function insures that the instance 
    cannot be accessed via one of the static methods before it has 
    been created. See C++FAQ book for example of technique. 
*/
template <typename EvType> 
EventSender<EvType>& 
EventSender<EvType>::instance() 
{
    static EventSender<EvType> eventSender;
    return eventSender;
}

/// Send the event to each listener in the registry. 
template <typename EvType>
void
EventSender<EvType>::sendEvent(const EvType& event) 
{
    /*
        If isBusySending == true, then problem: an attempt 
        is being made to send an EvType while one is already 
        being sent to listeners. Since the same listeners will be
        called again with the new event, this could lead to an 
        infinite loop.
    */
    if (_isBusySending) 
        throw IllegalSendError();
    
    // nothing else to do if no listeners registered
    if (_registry.empty())
    {
     theseLogs->logN(1,"No %s event registered.",lisnrID().c_str());
      return;
    }
    
    assert(!_isBusySending);
    _isBusySending = true;
    _eventIgnored = 0; // reset the event-ignored counter
    
    // Send event to each listener currently in registry
    typename Registry::iterator registryIter = _registry.begin();
    for (typename Registry::iterator registryIter = _registry.begin();
         registryIter != _registry.end(); ++ registryIter) 
    {
       theseLogs->logNdev(1,"Calling %s::processEventPublic",lisnrID(*registryIter).c_str());    
        try 
        { 
            (*registryIter)->processEventPublic(event); 
        }
        catch (const IllegalSendError&)
        {
            // propagate recursive flushes up the stack
            _isBusySending = false;
            cleanupQueues();
            throw;
        }
        catch (const std::exception& e)
        {
	 theseLogs->logNdebug(0,2,"BUG : %s::processEvent() threw an EXCEPTION of type %s", lisnrID(*registryIter).c_str(),typeid(e).name(),e.what());
         theseLogs->logNdebug(0,1,"....: The processEvent() must NOT leak ANY exception. \n\t\t\t Message is: ", e.what());
        }
        catch (...) 
        {
         theseLogs->logNdebug(0,1,"BUG : %s::processEvent() threw an EXCEPTION of UNKNOWN type (not derived from std::exception).",lisnrID(*registryIter).c_str());
        }
    }
    
    _isBusySending = false;
    // hold promise: the registration queue must 
    // be empty when isBusySending is over
    cleanupQueues();
}

/** When the EventSender is destroyed, every registered 
    listener must first be deregistered. 
    */
template<typename EvType>
EventSender<EvType>::~EventSender()
{
    // doesn't make sense to have EventSender destroyed while sending
    assert(!_isBusySending);
    // deregister every listener
    while (! _registry.empty()) 
    {
        _registry.front()->TListener::ignoreEvents();
    }
}

/** Move listeners queued for registration into the list 
    of active listeners, and remove listeners that are in 
    the removal queue from the registry.
    */
template<typename EvType>
void
EventSender<EvType>::cleanupQueues()
{
    assert(_isBusySending == false);
    
    // register listeners that have been queued for registration
    while (! _registrationQueue.empty()) 
    {
        typename Registry::iterator registryIter = _registrationQueue.begin();
       theseLogs->logNdev(1,"Registering queued %s ",lisnrID(*registryIter).c_str());
        // splice node from registration queue to registry
        _registry.splice(_registry.end(), _registrationQueue, registryIter);
        // make sure no other copy left in queue
        assert(std::find(_registrationQueue.begin(), 
                         _registrationQueue.end(), _registry.back()) 
               == _registrationQueue.end());
    }
    
    // remove listeners that have been queued for removal
    while (! _removalQueue.empty()) 
    {
        TListener* lisnr = _removalQueue.back();
        theseLogs->logNdev(1,"Removing queued %s ",lisnrID(lisnr).c_str());        
        if (! removeFrom(_registry, lisnr) )
	 theseLogs->logNdebug(1000,1,"Listener %s not in registry, removal ignored.", lisnrID(lisnr).c_str());
        _removalQueue.pop_back();
    }
}

/** Remove \a lisnr from \a container. Return true if the 
    listener has been removed, false if it wasn't found in the
    container. 
    */
template<typename EvType>
bool 
EventSender<EvType>::removeFrom(Registry& container, TListener* lisnr)
{
    // Find iterator for listener to be removed
    typename Registry::iterator removeIter
        = std::find(container.begin(), container.end(), lisnr);
    if ( removeIter != container.end() ) 
    {
        container.erase(removeIter);
       theseLogs->logNdebug(MAX_DEBUG,1,"%s removed from list",lisnrID(lisnr).c_str());
        return true;
    }
    
    // listener not found anywhere
    theseLogs->logN(1,"%s  NOT found in list",lisnrID(lisnr).c_str());
    return false;
}

/** Remove a Listener from this EventSender's list of listeners. 
    This should only be called by Listener if it is currently
    registered or queued for registration. 
    \note 
    - Actual removal takes place just before send() returns, just 
      after all listeners have processed the event, since the list of 
      listeners must not change during a send() operation.  
      
    \pre \a lisnr is not null (not checked)
    \param lisnr the listener to remove from the registry
    */
template<typename EvType>
void 
EventSender<EvType>::removeListener(TListener* lisnr)
{
    if (_isBusySending)
    {
        if (! removeFrom(_registrationQueue, lisnr))
        {
            assert(std::find(_removalQueue.begin(), 
                   _removalQueue.end(), lisnr) == _removalQueue.end());
            _removalQueue.push_back(lisnr);

           theseLogs->logNdev(1,"Putting %s on removal queue",lisnrID(lisnr).c_str());
        }
        else // nothing to do, already removed from registration queue
        {
	 theseLogs->logNdev(1,"%s removed from registration queue",lisnrID(lisnr).c_str());
        }
    }
    else
    {
        assert(_removalQueue.empty());
        assert(_registrationQueue.empty());
        const bool removed = removeFrom(_registry, lisnr);
        assert(removed);
    }
}

/** Register a Listener with this EventSender. This should only be 
    called by Listener if it is currently not registered or is
    queued for removal. 
    \note 
    - If this is called while a send() is in progress, actual 
      registration takes place at the end of a send() operation, 
      so that the registry of listeners will not change during the 
      send().
    \pre \a lisnr is not null (not checked)
    \param lisnr the listener to add to the registry.
    */
template<typename EvType>
void 
EventSender<EvType>::registerListener(TListener* lisnr)
{
    if (_isBusySending)
    // use queues instead
    {
        // first see if it is on the removal queue
        if (! removeFrom(_removalQueue, lisnr))
        {
            // wasn't in removal queue, so put on registration queue
            // note that it shouldn't be possible to have listener 
            // register itself if it is already in the queue or registered
            assert(std::find(_registrationQueue.begin(), 
                   _registrationQueue.end(), lisnr) == _registrationQueue.end());
            _registrationQueue.push_back(lisnr);
           theseLogs->logNdev(1,"Putting %s on registration queue ",lisnrID(lisnr).c_str());
        }
        else // nothing to do, already in queue
        {
	 theseLogs->logNdev(1,"%s removed from registration queue",lisnrID(lisnr).c_str());
        }
    }
    else // safe to register immediately
    {
        // this method never called if already registerd, so assert this:
        assert(std::find(_registry.begin(), _registry.end(), lisnr)
                == _registry.end());
        
        _registry.push_back(lisnr);
       theseLogs->logNdev(1,"Added (immediate) %s to listeners list ",lisnrID(lisnr).c_str());
    }
}


#endif // EVENT_SENDER_CC_TEMPLATE

