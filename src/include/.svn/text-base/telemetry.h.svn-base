#ifndef MD_TELEMETRY
#define MD_TELEMETRY
#define MAX_FRAMESIZE 100 // Capacity if data elements of both kinds.
#define nameOffsetIdx (frame + (sizeof(unsigned short) * (1 + *nNames)))

class mdTelemetryFrame {
public:

   char             *frame,*frameData,*nameCursor;
   int               frameSize,i,nameOffset;
   unsigned short   *nameOffsets,*nNames;
   std::string       manifest[MAX_FRAMESIZE];

   mdTelemetryFrame(const char *buffer,int size) : frameSize(size)
   {frame          = (char *)buffer;
    frameData      = frame + frameSize;
    nNames         =  (unsigned short *)frame; 
    nameOffsets    = ((unsigned short *)frame) + 1;
    nameCursor     = frame + ((MAX_FRAMESIZE + 1) * sizeof(unsigned short));
    nameOffsets[0] = nameCursor - frame;
    nameOffset     = 0;
   }

   char *nameIdx(int j) {return frame + ((MAX_FRAMESIZE+1) * sizeof(unsigned short)) + nameOffsets[j];}

   void newOut() { memset(frame,0,frameSize);  }
   void newIn()  { for (i=0;i< *nNames;i++) manifest[i] = std::string(nameIdx(i)); }
   
   void pack(mdObservable *obs, std::string &next) {
       frameData -= obs->pack(frameData);
       strcpy(nameCursor,next.c_str());
       *((unsigned short *)nameOffsetIdx) = nameOffset;
       nameOffset                        += (unsigned short)next.length() + 1;
      *nNames++;
   }

   void pack(mdOperationalDataElement *ode, std::string &next) {
       frameData -= ode->pack(frameData);
       strcpy(nameCursor,next.c_str());
       *((unsigned short *)nameOffsetIdx) = nameOffset;
       nameOffset                        += (unsigned short)next.length() + 1;
      *nNames++;
   }

};


#endif
