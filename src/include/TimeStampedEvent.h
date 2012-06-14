#ifndef TIME_STAMPED_EVENT_H
#define TIME_STAMPED_EVENT_H

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

/**
    Example of time stamper. It requires only one typedef (DataType), and one
    member function (getTimeStamp). The extra member function, used
    for ordering two time stamps, is only necessary if your code
    does a call to the ordering functions of TimeStampedEvent. 
    \note
    - The member functions need not be static and/or inline; this is 
      determined by your implementation of time-stamper;
    - The return type and arguments to leftOlder() would be "const DataType&"
      instead of "DataType", if DataType were a class rather than a 
      fundamental type.
*/
template <typename IntType>
struct TimeStamper
{
    /// The type of data holding the timestamp
    typedef IntType DataType;
    static IntType getTimeStamp();
    /// Return true only if \a left is strictly older than \a right
    inline static bool leftOlder(IntType left, IntType right) {return left < right;}
};

/** 
    Get the time stamp. This is where we define how to 
    implement time stamping. Here, we simply increment a 
    counter. 
*/
template <typename IntType>
IntType 
TimeStamper<IntType>::getTimeStamp()
{
    static IntType stamp = 0;
    return ++ stamp;
}

/**
    Default time stamper just uses a counter of type 
    unsigned long int. It has the benefit of 
    - complete portability 
    - speed
    - garantee of unique stamp for every event
    
    Time stampers that rely on system clocks typically 
    suffer in all three areas: the call is relatively costly, 
    several events may end up with the same time stamp, 
    the system clock may provide different resolutions on
    different systems, and may not be accessible with the
    same system calls. 
    
    The only disadvantage is that the time stamp will cycle every 2^N 
    events, where N is the number of bits for the long int data type. 
    Consequences: 
    - 32-bit longs: 
        - over 4 billion events before rollover;
        - one million time-stamped events/second implies a rollover 
          every hour;
        - therefore a program generating 1 million \em time-stamped 
          events/sec (not all event types need be time-stamped in your
          program) would have to run \em uninterrupted for more than 
          one hour in order to see the rollover;
    - 64-bit longs: 
        - 20 billion billion events (2x10^19) before rollover;
        - one billion time-stamped events/second implies a rollover 
          every 700 years;
        - therefore a program generating 1 billion \em time-stamped 
          events/sec would have to run \em uninterrupted for more than 
          700 years in order to see the rollover.
          
    If this limitation is not acceptable, you have two choices:
    - Create your own integer-based time-stamper, via a new class or a 
      specialization of TimeStamper<IntType>, with an integer type that
      garantees enough bits (e.g., certain libraries provide a class 
      where the number of bits is specified via a template parameter,
      e.g. Int<128>, or perhaps the Standard will eventually supply 
      int64 and int128);
    - Create your own generic time-stamper via a new class, and 
      define the appropriate members (DataType, getTimeStamp(), and 
      leftOlder()). 
*/
typedef TimeStamper<unsigned long int> DefaultTimeStamper;

/** 
    A simple basic event class that provides a time stamp for creation
    of the event.  This class must be subclassed into a specific event 
    (it can only be instantiated via a derived class since the 
    constructor and destructor are protected), where data relevant to 
    the event is stored. 

    The time stamp is the number of seconds since the first TimeStampedEvent
    was instantiated. This strategy ensures that the reference is always 
    well defined and independent of compiler etc, is a relatively small 
    number, and can be repeated. 
    
    \author Oliver Schoenborn
    \since Sept 2002
    */
template <class Stamper = DefaultTimeStamper>
class TimeStampedEvent
{
    public:
        /** Get creation time of this event. This is given as 
            the number of seconds (or fraction thereof) since the 
            first instantiation of a TimeStampedEvent object.
            \return seconds since first TimeStampedEvent object created  
            */
        const typename Stamper::DataType& getTimeStamp() const {return _timeStamp;}
        
        /// Return true only if *this has a time stamp older than that of \a tse
        bool isOlderThan(const TimeStampedEvent& tse) const 
        {
            return Stamper::leftOlder(_timeStamp, tse._timeStamp);
        }
        
        /// Return true only if *this has a time stamp older than that of \a tse
        bool operator<(const TimeStampedEvent& tse) const {return isOlderThan(tse);}
        
    protected:
        /// Create a TimeStampedEvent object.
        TimeStampedEvent(): _timeStamp( Stamper::getTimeStamp() ) {}
        /// Protected destructor will prevent user from calling delete
        /// on a pointer to a TimeStampedEvent.
        ~TimeStampedEvent() {}

    private: // data
        /// Creation time of current instance of event
        const typename Stamper::DataType _timeStamp;
};

#endif // TIME_STAMPED_EVENT_H
