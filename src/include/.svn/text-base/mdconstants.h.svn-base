
/*!
 *  \todo should be mdcommon.h
 */


#define INSTRUMENT                   1
#define MAX_DEVICE                   5        // Machine, Up to 3 optical instruments and the US i/f (Phase II and later)
#define MD_DATAGRAM_RESPONSE_SIZE    16       // First three bytes after header are ACK or NAK
#define MD_DEFAULT_RULE              0
// Our rendering of SCPI-99
// Custom behaviors greater than this
#define MD_DEFAULT_DEVICE_PROTOCOL   1
#define MD_DEFAULT_IP                "208.109.106.127"
#define MD_EPOCH                     date()           
#define MD_HEARTBEAT                 1         // Network peer heartbeat in seconds.
#define MD_HEARTBEAT_SIZE            8         // Network peer heartbeat in seconds.
#define MD_MAX_DATAGRAM              (63*1024) // 1K short of the IPV4 max
#define MD_NAME                      "OpenAUC Master Daemon"
#define MD_VERSION                   " - Pre Alpha"
#define MD_REFRESH                   10        // default milliseconds between telemetry frame updates
#define MD_TYPE                      "CENTRIFUGE"        // Change per your MD derivation
#define MACHINE                      0         // Null machine type impliss MD_TYPE
#define OK                           0
#define OTHERCLIENT                  2

enum md_units {

  centimeters,
  millimeters,
  microns,
  nanometers,
  angstroms,
  volts,
  cubiccentemeter

};

enum md_datagrams {

  HEARTBEAT,
  TELEMETRY 

};

typedef
  struct mdHB {
   char msgType;
   char deviceType;
   int  msgId;
  } MDHB;
