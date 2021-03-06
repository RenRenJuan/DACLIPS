LOCATION=somejuan.deb6
#
# DACLIPS (location above indicates build locus).
#
# To build mdclient, you must first build the server
# and put it in operation at port used here because part
# of the client is generated using xml-rpc-api2cpp.
#
# For "make client", which should be run whenever an API
# is changed, the MD for which mdclient is to be built
# must be running at MD_URL and you must first run 
# make cleanclient
#
# Unfortunately the notion of using nmake on Windows
# didn't pan out. Since md_device is only actually 
# used on Windows, the Visual Studio 2010 projects
# for md_device and dvdriver are the actually tested
# versions, but the unix versions are used for 
# development purposes and bringing up devices there
# should be same as with the Windows versions.
# There is no integration between this makefile and 
# the VS2010 projects but same c++ sources are used.
#
# LOCATION just reflects accidents of different host
# setups, it could be made uniform.
#
# The rules system derives from CLIPS 6.x and is
# maintained as part of this project.
#
# Boost, xmlrpc-c and other and any other dependencies
# not built below are assumed to be in the host environment
# but only the original DACLIPS elements are included in
# the doxygen documentation. 
#
CC=g++
Cc=gcc
Cs=src/clipsrules/core/
Ck=obj/kb/

BOSTLIB=-L/usr/local/lib
BOSINCL=-L/usr/local/include
XRPCLIB=-L/usr/local/lib
LOG4LIB=-L/usr/local/lib
XRPINCL=-L/usr/local/include

ifeq ($(LOCATION),somejuan.deb6)
BOSTLIB=-L/usr/local/lib/boost
BOSINCL=-L/usr/local/include/boost
XRPCLIB=-L/usr/local/lib/xmlrpc
XRPINCL=-L/usr/local/include/xmlrpc
LOG4LIB=-L/usr/local/lib/log4cpp
endif

SLIBS= -L/usr/local/lib $(BOSTLIB) $(XRPCLIB) $(LOG4LIB) -l boost_system -l log4cpp -l xmlrpc_server_abyss -l xmlrpc++ -l xmlrpc_server_abyss++ \
       -l xmlrpc_xmlparse -l xmlrpc_xmltok -l xmlrpc_util -l xmlrpc_server++ -l boost_thread

DVCFLAGS=-shared -fPIC -Wl,-soname,libmddevice.so -DINCLDV
CLIBFLAGS=-shared -fPIC -Wl,-soname,libdaclisp.so 

ifeq ($(LOCATION),somejuan.deb6)
SINCL= -I src/include -I /usr/local/include/log4cpp $(XRPINCL) $(BOSINCL)
#CLIPSMMINCL= -I /usr/local/include/sigc++-2.0
CLIPSMNINCL=
CFLAGS= -DCURRENT_DEBUG=1000  
CLIPSMMFLAGS= -DCLIPSMM_USE_BOOST_SMART_POINTER 
CINCL= -I src/include -I /usr/local/include/log4cpp  
DVLIBS= $(BOSTLIB) $(XRPCLIB) -l boost_system -l boost_thread
KBLIBS= $(CLIPSMMOBJS) $(BOSTLIB) $(XRPCLIB) -l daclips -l sigc-2.0
endif

ifeq ($(LOCATION),daclips)
CFLAGS= -DMD_STAGE $(AI)
CINCL= -I src/include -I /usr/include/log4cpp
SINCL= -I src/include -I /usr/include/log4cpp
endif

ifeq ($(LOCATION),xasp)
CFLAGS= -DCURRENT_DEBUG=1000 
CINCL= -I src/include -I /root/include/log4cpp 
SINCL= -I src/include -I /root/include/log4cpp 
CLIPSMMINCL= -I /usr/include/sigc++-2.0 -I /usr/lib/sigc++-2.0/include 
CLIPSMMFLAGS= -DCLIPSMM_USE_BOOST_SMART_POINTER 
DVLIBS= -L$(USRLIB) -l boost_system -l boost_thread
KBLIBS= $(CLIPSMMOBJS) -L$(USRLIB) -l daclips -l sigc-2.0 -L/lib 
endif

ifeq ($(LOCATION),godaddy)
CFLAGS= -DMD_STAGE 
CINCL= -I src/include -I /usr/local/include/log4cpp
SINCL= -I src/include -I /usr/local/include/log4cpp
endif

DVINCL= -I src/include  
CLIBS= -L$(USRLIB) -l xmlrpc_cpp -l xmlrpc++ -l xmlrpc_client -l xmlrpc_client++  -l xmlrpc_util

MD_URL= http://localhost:4243/RPC2

CLIPSMMOBJS=obj/server/activation.o  obj/server/defaultfacts.o  obj/server/environment.o  obj/server/environmentobject.o \
  obj/server/fact.o  obj/server/factory.o  obj/server/function.o  obj/server/global.o  obj/server/module.o  obj/server/object.o \
  obj/server/rule.o  obj/server/template.o obj/server/utility.o   obj/server/value.o

CLIPSOBJS= $(Ck)agenda.o $(Ck)analysis.o $(Ck)argacces.o $(Ck)bload.o $(Ck)bmathfun.o $(Ck)bsave.o \
	$(Ck)classcom.o $(Ck)classexm.o $(Ck)classfun.o $(Ck)classinf.o $(Ck)classini.o \
	$(Ck)classpsr.o $(Ck)clsltpsr.o $(Ck)commline.o $(Ck)conscomp.o $(Ck)constrct.o \
	$(Ck)constrnt.o $(Ck)crstrtgy.o $(Ck)cstrcbin.o $(Ck)cstrccom.o $(Ck)cstrcpsr.o \
	$(Ck)cstrnbin.o $(Ck)cstrnchk.o $(Ck)cstrncmp.o $(Ck)cstrnops.o $(Ck)cstrnpsr.o \
	$(Ck)cstrnutl.o $(Ck)default.o $(Ck)defins.o $(Ck)developr.o $(Ck)dffctbin.o $(Ck)dffctbsc.o \
	$(Ck)dffctcmp.o $(Ck)dffctdef.o $(Ck)dffctpsr.o $(Ck)dffnxbin.o $(Ck)dffnxcmp.o \
	$(Ck)dffnxexe.o $(Ck)dffnxfun.o $(Ck)dffnxpsr.o $(Ck)dfinsbin.o $(Ck)dfinscmp.o $(Ck)drive.o \
	$(Ck)edbasic.o $(Ck)edmain.o $(Ck)edmisc.o $(Ck)edstruct.o $(Ck)edterm.o $(Ck)emathfun.o \
	$(Ck)engine.o $(Ck)envrnmnt.o $(Ck)evaluatn.o $(Ck)expressn.o $(Ck)exprnbin.o $(Ck)exprnops.o \
	$(Ck)exprnpsr.o $(Ck)extnfunc.o $(Ck)factbin.o $(Ck)factbld.o $(Ck)factcmp.o $(Ck)factcom.o \
	$(Ck)factfun.o $(Ck)factgen.o $(Ck)facthsh.o $(Ck)factlhs.o $(Ck)factmch.o $(Ck)factmngr.o \
	$(Ck)factprt.o $(Ck)factqpsr.o $(Ck)factqury.o $(Ck)factrete.o $(Ck)factrhs.o $(Ck)filecom.o $(Ck)filertr.o \
	$(Ck)generate.o $(Ck)genrcbin.o $(Ck)genrccmp.o $(Ck)genrccom.o $(Ck)genrcexe.o $(Ck)genrcfun.o \
	$(Ck)genrcpsr.o $(Ck)globlbin.o $(Ck)globlbsc.o $(Ck)globlcmp.o $(Ck)globlcom.o \
	$(Ck)globldef.o $(Ck)globlpsr.o $(Ck)immthpsr.o $(Ck)incrrset.o $(Ck)inherpsr.o \
	$(Ck)inscom.o $(Ck)insfile.o $(Ck)insfun.o $(Ck)insmngr.o $(Ck)insmoddp.o $(Ck)insmult.o \
	$(Ck)inspsr.o $(Ck)insquery.o $(Ck)insqypsr.o $(Ck)iofun.o $(Ck)lgcldpnd.o \
	$(Ck)memalloc.o $(Ck)miscfun.o $(Ck)modulbin.o $(Ck)modulbsc.o $(Ck)modulcmp.o $(Ck)moduldef.o \
	$(Ck)modulpsr.o $(Ck)modulutl.o $(Ck)msgcom.o $(Ck)msgfun.o $(Ck)msgpass.o $(Ck)msgpsr.o \
	$(Ck)multifld.o $(Ck)multifun.o $(Ck)objbin.o $(Ck)objcmp.o $(Ck)objrtbin.o $(Ck)objrtbld.o \
	$(Ck)objrtcmp.o $(Ck)objrtfnx.o $(Ck)objrtgen.o $(Ck)objrtmch.o $(Ck)parsefun.o $(Ck)pattern.o \
	$(Ck)pprint.o $(Ck)prccode.o $(Ck)prcdrfun.o $(Ck)prcdrpsr.o $(Ck)prdctfun.o $(Ck)prntutil.o \
	$(Ck)proflfun.o $(Ck)reorder.o $(Ck)reteutil.o $(Ck)retract.o $(Ck)router.o $(Ck)rulebin.o \
	$(Ck)rulebld.o $(Ck)rulebsc.o $(Ck)rulecmp.o $(Ck)rulecom.o $(Ck)rulecstr.o $(Ck)ruledef.o \
	$(Ck)ruledlt.o $(Ck)rulelhs.o $(Ck)rulepsr.o $(Ck)scanner.o $(Ck)sortfun.o $(Ck)strngfun.o \
	$(Ck)strngrtr.o $(Ck)symblbin.o $(Ck)symblcmp.o $(Ck)symbol.o $(Ck)sysdep.o $(Ck)textpro.o \
	$(Ck)tmpltbin.o $(Ck)tmpltbsc.o $(Ck)tmpltcmp.o $(Ck)tmpltdef.o $(Ck)tmpltfun.o $(Ck)tmpltlhs.o \
	$(Ck)tmpltpsr.o $(Ck)tmpltrhs.o $(Ck)tmpltutl.o $(Ck)userdata.o $(Ck)userfunctions.o $(Ck)utility.o $(Ck)watch.o 


CLFLAGS= -Wall -Wundef -Wpointer-arith -Wshadow \
	 -Wcast-align -Winline -Wmissing-declarations -Wredundant-decls \
	 -Wmissing-prototypes -Wnested-externs \
	 -Wstrict-prototypes -Waggregate-return -Wno-implicit 

# --- targets
# Because of the dependency on introspection of the 
# current XMLRPC API, all doesn't include md_client.
# 
# If MD is running do make cleanclient;make client;make all
# to do an actual complete rebuild of the entire unix system.
#
ifeq ($(LOCATION),somejuan)
all:    cliever device kb server docs
else
all:    cliever server kb
endif

client:  bin/mdclient
cliever: bin/md-cd 
device:  bin/libmddevice.so bin/dvdriver
docs:    doxygen/html/index.html
kb:      bin/libdaclips.so bin/daclips-md bin/daclips-cd
server:  bin/md

.c.o:
	$(Cc) -c $(CLFLAGS) -o  $<

obj/server/mdLogger.o: src/server/mdLogger.cpp src/include/mdLogger.h 
	$(CC) $(CFLAGS) src/server/mdLogger.cpp -c -o obj/server/mdLogger.o $(SINCL)

obj/server/mdDevice.o: src/server/mdDevice.cpp src/include/mdDevice.h 
	$(CC) $(CFLAGS) src/server/mdDevice.cpp -c -o obj/server/mdDevice.o $(SINCL)

obj/server/mdObservable.o: src/server/mdDevice.cpp src/include/mdObservable.h 
	$(CC) $(CFLAGS) -DINCLMD src/server/mdObservable.cpp -c -o obj/server/mdObservable.o $(SINCL)

obj/server/mdBehavior.o: src/server/mdBehavior.cpp src/include/mdBehavior.h 
	$(CC) $(CFLAGS) src/server/mdBehavior.cpp  -c -o obj/server/mdBehavior.o $(SINCL)

obj/server/masterDaemon.o: src/server/masterDaemon.cpp src/include/masterDaemon.h src/include/coreapi.h  src/include/Listener.h src/include/EventSender.h
	$(CC) $(CFLAGS) src/server/masterDaemon.cpp -c -l boost_system -o obj/server/masterDaemon.o $(SINCL)

obj/server/masterDaemonConfig.o: src/server/masterDaemonConfig.cpp src/include/masterDaemonConfig.h
	$(CC) $(CFLAGS) src/server/masterDaemonConfig.cpp  -c -l boost_system -o obj/server/masterDaemonConfig.o $(SINCL)

obj/server/mdState.o: src/server/mdState.cpp src/include/mdState.h 
	$(CC) $(CFLAGS) -DINCLMD src/server/mdState.cpp -c  -o obj/server/mdState.o $(SINCL)

obj/server/auc-md.o: src/server/auc-md.cpp src/include/*.h
	$(CC) $(CFLAGS) src/server/auc-md.cpp -c -o obj/server/auc-md.o $(SINCL)

obj/server/lxi-control.o: src/server/lxi-control.c
	$(Cc) $(CFLAGS) src/server/lxi-control.c -c -o obj/server/lxi-control.o 

obj/client/clientDaemonConfig.o: src/client/clientDaemonConfig.cpp
	$(CC) $(CFLAGS) src/client/clientDaemonConfig.cpp -c -o obj/client/clientDaemonConfig.o $(CINCL)

src/client/mdClientBehavior.cpp:
	xml-rpc-api2cpp $(MD_URL) "behavior" mdClientBehavior        >src/client/mdClientBehavior 
	bin/after   src/client/mdClientBehavior mdClientBehavior\.cc >src/client/mdClientBehavior.cpp
	bin/before  src/client/mdClientBehavior mdClientBehavior\.cc >src/include/mdClientBehavior.h
	rm src/client/mdClientBehavior

src/client/mdClientDevice.cpp:
	xml-rpc-api2cpp $(MD_URL) "device" mdClientDevice         >src/client/mdClientDevice 
	bin/after   src/client/mdClientDevice mdClientDevice\.cc  >src/client/mdClientDevice.cpp
	bin/before  src/client/mdClientDevice mdClientDevice\.cc  >src/include/mdClientDevice.h
	rm src/client/mdClientDevice 

src/client/mdClientState.cpp:
	xml-rpc-api2cpp $(MD_URL) "state" mdClientState >src/client/mdClientState 
	bin/after   src/client/mdClientState mdClientState\.cc >src/client/mdClientState.cpp
	bin/before  src/client/mdClientState mdClientState\.cc >src/include/mdClientState.h
	rm src/client/mdClientState

obj/client/mdClientBehavior.o: src/client/mdClientBehavior.cpp 
	$(CC) $(CFLAGS) src/client/mdClientBehavior.cpp $(CINCL) -c -o obj/client/mdClientBehavior.o

obj/client/mdClientState.o: src/client/mdClientState.cpp 
	$(CC) $(CFLAGS) src/client/mdClientState.cpp $(CINCL) -c -o obj/client/mdClientState.o

obj/client/commander.o: src/client/commander.cpp src/include/mdCommander.h
	$(CC) $(CFLAGS) src/client/commander.cpp $(CINCL) -c -o obj/client/commander.o

obj/client/mdClientDevice.o: src/client/mdClientDevice.cpp 
	$(CC) $(CFLAGS) src/client/mdClientDevice.cpp $(CINCL) -c -o obj/client/mdClientDevice.o

obj/client/tools.o: src/client/tools.cpp 
	$(CC) $(CFLAGS) src/client/tools.cpp $(CINCL) -c -o obj/client/tools.o

obj/client/coretestbucket.o: src/client/coretestbucket.cpp 
	$(CC) $(CFLAGS) src/client/coretestbucket.cpp $(CINCL) -c -o obj/client/coretestbucket.o

$(Ck)activation.o: src/clipsmm/activation.cpp 
	$(CC) $(CFLAGS) src/clipsmm/activation.cpp  -c -o $(Ck)actvation.o

bin/md: obj/server/auc-md.o  obj/server/mdBehavior.o obj/server/mdDevice.o  obj/server/masterDaemon.o   \
	obj/server/masterDaemonConfig.o obj/server/lxi-control.o obj/server/mdLogger.o obj/server/mdState.o  obj/server/mdObservable.o
	$(CC) $(CFLAGS) -o bin/md $(SINCL) $(LIBS) obj/server/auc-md.o obj/server/mdObservable.o obj/server/lxi-control.o obj/server/mdLogger.o  \
	obj/server/mdDevice.o obj/server/mdBehavior.o obj/server/mdState.o obj/server/masterDaemon.o obj/server/masterDaemonConfig.o $(SLIBS) $(CLIBS)

bin/md-cd: src/client/auc-cd.cpp src/include/auc-cd.h src/include/Listener.h src/include/EventSender.h obj/client/clientDaemonConfig.o \
	obj/client/commander.o src/client/clientDaemon.cpp src/include/clientDaemon.h src/include/cdLogger.h src/client/cdLogger.cpp
	$(CC) $(CFLAGS) src/client/auc-cd.cpp src/client/cdLogger.cpp src/client/clientDaemon.cpp obj/client/clientDaemonConfig.o obj/client/commander.o \
	 -o bin/md-cd $(CINCL)  $(SLIBS) $(CLIBS) 

obj/server/activation.o: src/clipsmm/activation.cpp
	$(CC) $(CFLAGS) $(CLIPSMMFLAGS) -c src/clipsmm/activation.cpp -o obj/server/activation.o  $(SINCL) $(CLIPSMMINCL)

obj/server/defaultfacts.o: src/clipsmm/defaultfacts.cpp
	$(CC) $(CFLAGS) $(CLIPSMMFLAGS) -c src/clipsmm/defaultfacts.cpp -o obj/server/defaultfacts.o  $(SINCL) $(CLIPSMMINCL)

obj/server/environment.o: src/clipsmm/environment.cpp
	$(CC) $(CFLAGS) $(CLIPSMMFLAGS) -c src/clipsmm/environment.cpp -o obj/server/environment.o  $(SINCL)  $(CLIPSMMINCL)

obj/server/environmentobject.o: src/clipsmm/environmentobject.cpp
	$(CC) $(CFLAGS) $(CLIPSMMFLAGS) -c src/clipsmm/environmentobject.cpp -o obj/server/environmentobject.o  $(SINCL) $(CLIPSMMINCL)

obj/server/fact.o: src/clipsmm/fact.cpp
	$(CC) $(CFLAGS) $(CLIPSMMFLAGS) -c src/clipsmm/fact.cpp -o obj/server/fact.o  $(SINCL) $(CLIPSMMINCL)

obj/server/factory.o: src/clipsmm/factory.cpp
	$(CC) $(CFLAGS) $(CLIPSMMFLAGS) -c src/clipsmm/factory.cpp -o obj/server/factory.o  $(SINCL) $(CLIPSMMINCL)

obj/server/function.o: src/clipsmm/function.cpp
	$(CC) $(CFLAGS) $(CLIPSMMFLAGS) -c src/clipsmm/function.cpp -o obj/server/function.o  $(SINCL) $(CLIPSMMINCL)

obj/server/global.o: src/clipsmm/global.cpp
	$(CC) $(CFLAGS) $(CLIPSMMFLAGS) -c src/clipsmm/global.cpp -o obj/server/global.o  $(SINCL) $(CLIPSMMINCL)

obj/server/module.o: src/clipsmm/module.cpp
	$(CC) $(CFLAGS) $(CLIPSMMFLAGS) -c src/clipsmm/module.cpp -o obj/server/module.o  $(SINCL) $(CLIPSMMINCL)

obj/server/object.o: src/clipsmm/object.cpp
	$(CC) $(CFLAGS) $(CLIPSMMFLAGS) -c src/clipsmm/object.cpp -o obj/server/object.o  $(SINCL) $(CLIPSMMINCL)

obj/server/rule.o: src/clipsmm/rule.cpp
	$(CC) $(CFLAGS) $(CLIPSMMFLAGS) -c src/clipsmm/rule.cpp -o obj/server/rule.o  $(SINCL) $(CLIPSMMINCL)

obj/server/template.o: src/clipsmm/template.cpp
	$(CC) $(CFLAGS) $(CLIPSMMFLAGS) -c src/clipsmm/template.cpp -o obj/server/template.o  $(SINCL) $(CLIPSMMINCL)

obj/server/utility.o: src/clipsmm/utility.cpp
	$(CC) $(CFLAGS) $(CLIPSMMFLAGS) -c src/clipsmm/utility.cpp -o obj/server/utility.o  $(SINCL) $(CLIPSMMINCL)

obj/server/value.o: src/clipsmm/value.cpp
	$(CC) $(CFLAGS) $(CLIPSMMFLAGS) -c src/clipsmm/value.cpp -o obj/server/value.o  $(SINCL) $(CLIPSMMINCL)

bin/mdclient: obj/client/mdClientBehavior.o obj/client/mdClientState.o obj/client/mdClientDevice.o obj/client/tools.o obj/client/coretestbucket.o src/client/mdclient.cpp 
	$(CC) $(CFLAGS) src/client/mdclient.cpp $(CLIBS) $(CINCL) -o bin/mdclient obj/client/tools.o obj/client/coretestbucket.o \
	obj/client/mdClientBehavior.o obj/client/mdClientState.o obj/client/mdClientDevice.o 

$(Ck)agenda.o: $(Cs)agenda.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h $(Cs)expressn.h \
  $(Cs) $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
  $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h \
  $(Cs)modulpsr.h $(Cs)utility.h $(Cs)crstrtgy.h $(Cs)agenda.h $(Cs)ruledef.h $(Cs)constrnt.h \
  $(Cs)cstrccom.h $(Cs)network.h $(Cs)match.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)engine.h $(Cs)lgcldpnd.h \
  $(Cs) $(Cs)retract.h $(Cs)memalloc.h $(Cs)modulutl.h $(Cs)multifld.h $(Cs)reteutil.h $(Cs)router.h \
  $(Cs)prntutil.h $(Cs)rulebsc.h $(Cs)strngrtr.h $(Cs)sysdep.h $(Cs)watch.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)agenda.o $(Cs)agenda.c

$(Ck)analysis.o: $(Cs)analysis.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h $(Cs)symbol.h \
 $(Cs)memalloc.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)reorder.h $(Cs)ruledef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h \
 $(Cs)modulpsr.h $(Cs)evaluatn.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)constrnt.h $(Cs)cstrccom.h \
 $(Cs)agenda.h $(Cs)match.h $(Cs)network.h $(Cs)pattern.h $(Cs)generate.h $(Cs)router.h $(Cs)prntutil.h \
 $(Cs)cstrnchk.h $(Cs)cstrnutl.h $(Cs)cstrnops.h $(Cs)rulecstr.h $(Cs)modulutl.h $(Cs)analysis.h \
 $(Cs)globldef.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)analysis.o $(Cs)analysis.c

$(Ck)argacces.o: $(Cs)argacces.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)extnfunc.h $(Cs)symbol.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)userdata.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)evaluatn.h $(Cs)constant.h \
 $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)cstrnchk.h $(Cs)constrnt.h $(Cs)insfun.h $(Cs)object.h \
 $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)pattern.h \
 $(Cs)reorder.h $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)tmpltdef.h $(Cs)factbld.h $(Cs)argacces.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)argacces.o $(Cs)argacces.c

$(Ck)bload.o: $(Cs)bload.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)utility.h $(Cs)bsave.h $(Cs)cstrnbin.h $(Cs)constrnt.h $(Cs)memalloc.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)bload.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)bload.o $(Cs)bload.c

$(Ck)bmathfun.o: $(Cs)bmathfun.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)router.h $(Cs)prntutil.h \
 $(Cs)bmathfun.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)bmathfun.o $(Cs)bmathfun.c

$(Ck)bsave.o: $(Cs)bsave.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)utility.h $(Cs)bload.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)cstrnbin.h \
 $(Cs)constrnt.h $(Cs)memalloc.h $(Cs)router.h $(Cs)prntutil.h $(Cs)bsave.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)bsave.o $(Cs)bsave.c

$(Ck)classcom.o: $(Cs)classcom.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)bload.h $(Cs)utility.h \
 $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)userdata.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)argacces.h $(Cs)evaluatn.h \
 $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h \
 $(Cs)classfun.h $(Cs)object.h $(Cs)constrnt.h $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h \
 $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)classini.h $(Cs)modulutl.h $(Cs)msgcom.h \
 $(Cs)msgpass.h $(Cs)router.h $(Cs)prntutil.h $(Cs)classcom.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)classcom.o $(Cs)classcom.c

$(Ck)classexm.o: $(Cs)classexm.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)classcom.h $(Cs)cstrccom.h \
 $(Cs)object.h $(Cs)constrnt.h $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h \
 $(Cs)pattern.h $(Cs)reorder.h $(Cs)classfun.h $(Cs)classini.h $(Cs)insfun.h $(Cs)memalloc.h $(Cs)msgcom.h \
 $(Cs)msgpass.h $(Cs)msgfun.h $(Cs)router.h $(Cs)prntutil.h $(Cs)strngrtr.h $(Cs)classexm.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)classexm.o $(Cs)classexm.c

$(Ck)classfun.o: $(Cs)classfun.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)bload.h $(Cs)utility.h \
 $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)userdata.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)classcom.h $(Cs)cstrccom.h \
 $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)object.h $(Cs)constrnt.h $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h \
 $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)classini.h $(Cs)cstrcpsr.h $(Cs)inscom.h $(Cs)insfun.h \
 $(Cs)insmngr.h $(Cs)memalloc.h $(Cs)modulutl.h $(Cs)msgfun.h $(Cs)msgpass.h $(Cs)router.h $(Cs)prntutil.h \
 $(Cs)classfun.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)classfun.o $(Cs)classfun.c

$(Ck)classinf.o: $(Cs)classinf.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)classcom.h $(Cs)cstrccom.h \
 $(Cs)object.h $(Cs)constrnt.h $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h \
 $(Cs)pattern.h $(Cs)reorder.h $(Cs)classexm.h $(Cs)classfun.h $(Cs)classini.h $(Cs)memalloc.h \
 $(Cs)insfun.h $(Cs)msgcom.h $(Cs)msgpass.h $(Cs)msgfun.h $(Cs)prntutil.h $(Cs)classinf.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)classinf.o $(Cs)classinf.c

$(Ck)classini.o: $(Cs)classini.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)classcom.h \
 $(Cs)cstrccom.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)object.h $(Cs)constrnt.h \
 $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)classexm.h $(Cs)classfun.h $(Cs)classinf.h $(Cs)classpsr.h $(Cs)cstrcpsr.h $(Cs)inscom.h \
 $(Cs)insfun.h $(Cs)memalloc.h $(Cs)modulutl.h $(Cs)msgcom.h $(Cs)msgpass.h $(Cs)watch.h $(Cs)defins.h \
 $(Cs)insquery.h $(Cs)bload.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)objbin.h $(Cs)objcmp.h \
 $(Cs)objrtbld.h $(Cs)classini.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)classini.o $(Cs)classini.c

$(Ck)classpsr.o: $(Cs)classpsr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)bload.h $(Cs)utility.h \
 $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)userdata.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)classcom.h $(Cs)cstrccom.h \
 $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)object.h $(Cs)constrnt.h $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h \
 $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)classfun.h $(Cs)clsltpsr.h $(Cs)cstrcpsr.h \
 $(Cs)inherpsr.h $(Cs)memalloc.h $(Cs)modulutl.h $(Cs)msgpsr.h $(Cs)router.h $(Cs)prntutil.h \
 $(Cs)classpsr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)classpsr.o $(Cs)classpsr.c

$(Ck)clsltpsr.o: $(Cs)clsltpsr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)classcom.h \
 $(Cs)cstrccom.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)object.h $(Cs)constrnt.h \
 $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)classfun.h $(Cs)cstrnchk.h $(Cs)cstrnpsr.h $(Cs)cstrnutl.h $(Cs)default.h $(Cs)insfun.h \
 $(Cs)memalloc.h $(Cs)prntutil.h $(Cs)router.h $(Cs)clsltpsr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)clsltpsr.o $(Cs)clsltpsr.c

$(Ck)commline.o: $(Cs)commline.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h \
 $(Cs)argacces.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h \
 $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)cstrcpsr.h $(Cs)filecom.h \
 $(Cs)memalloc.h $(Cs)prcdrfun.h $(Cs)prcdrpsr.h $(Cs)constrnt.h $(Cs)router.h $(Cs)prntutil.h \
 $(Cs)strngrtr.h $(Cs)commline.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)commline.o $(Cs)commline.c

$(Ck)conscomp.o: $(Cs)conscomp.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)symbol.h $(Cs)memalloc.h \
 $(Cs)constant.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)cstrccom.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h \
 $(Cs)evaluatn.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)argacces.h $(Cs)cstrncmp.h \
 $(Cs)constrnt.h $(Cs)router.h $(Cs)prntutil.h $(Cs)sysdep.h $(Cs)modulcmp.h $(Cs)network.h $(Cs)match.h \
 $(Cs)pattern.h $(Cs)reorder.h $(Cs)ruledef.h $(Cs)agenda.h $(Cs)dffnxcmp.h $(Cs)dffnxfun.h $(Cs)tmpltcmp.h \
 $(Cs)globlcmp.h $(Cs)genrccmp.h $(Cs)genrcfun.h $(Cs)object.h $(Cs)multifld.h $(Cs)objcmp.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)conscomp.o $(Cs)conscomp.c

$(Ck)constrct.o: $(Cs)constrct.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h \
 $(Cs)memalloc.h $(Cs)router.h $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h \
 $(Cs)symbol.h $(Cs)userdata.h $(Cs)evaluatn.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h \
 $(Cs)extnfunc.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)watch.h \
 $(Cs)prcdrfun.h $(Cs)prcdrpsr.h $(Cs)constrnt.h $(Cs)argacces.h $(Cs)multifld.h $(Cs)sysdep.h \
 $(Cs)commline.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)constrct.o $(Cs)constrct.c

$(Ck)constrnt.o: $(Cs)constrnt.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)memalloc.h $(Cs)multifld.h \
 $(Cs)router.h $(Cs)prntutil.h $(Cs)constrnt.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)constrnt.o $(Cs)constrnt.c

$(Ck)crstrtgy.o: $(Cs)crstrtgy.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h $(Cs)pattern.h \
 $(Cs)evaluatn.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)constrnt.h \
 $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)reorder.h $(Cs)reteutil.h $(Cs)argacces.h $(Cs)crstrtgy.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)crstrtgy.o $(Cs)crstrtgy.c

$(Ck)cstrcbin.o: $(Cs)cstrcbin.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)bload.h $(Cs)utility.h \
 $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)userdata.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)bsave.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)cstrcbin.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)cstrcbin.o $(Cs)cstrcbin.c

$(Ck)cstrccom.o: $(Cs)cstrccom.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h \
 $(Cs)memalloc.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)evaluatn.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)scanner.h \
 $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)argacces.h $(Cs)multifld.h \
 $(Cs)modulutl.h $(Cs)router.h $(Cs)prntutil.h $(Cs)commline.h $(Cs)bload.h $(Cs)exprnbin.h $(Cs)sysdep.h \
 $(Cs)symblbin.h $(Cs)cstrcpsr.h $(Cs)cstrccom.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)cstrccom.o $(Cs)cstrccom.c

$(Ck)cstrcpsr.o: $(Cs)cstrcpsr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)router.h $(Cs)prntutil.h \
 $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)evaluatn.h \
 $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)scanner.h \
 $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)watch.h $(Cs)prcdrpsr.h $(Cs)constrnt.h \
 $(Cs)modulutl.h $(Cs)sysdep.h $(Cs)cstrcpsr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)cstrcpsr.o $(Cs)cstrcpsr.c

$(Ck)cstrnbin.o: $(Cs)cstrnbin.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h \
 $(Cs)memalloc.h $(Cs)router.h $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h \
 $(Cs)symbol.h $(Cs)userdata.h $(Cs)evaluatn.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h \
 $(Cs)extnfunc.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)bload.h \
 $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)bsave.h $(Cs)cstrnbin.h $(Cs)constrnt.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)cstrnbin.o $(Cs)cstrnbin.c

$(Ck)cstrnchk.o: $(Cs)cstrnchk.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)router.h $(Cs)prntutil.h \
 $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)evaluatn.h \
 $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)scanner.h \
 $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)multifld.h $(Cs)cstrnutl.h \
 $(Cs)constrnt.h $(Cs)inscom.h $(Cs)object.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)cstrccom.h \
 $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)insfun.h $(Cs)classcom.h $(Cs)classexm.h $(Cs)cstrnchk.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)cstrnchk.o $(Cs)cstrnchk.c

$(Ck)cstrncmp.o: $(Cs)cstrncmp.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)symbol.h $(Cs)evaluatn.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h \
 $(Cs)pprint.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)memalloc.h $(Cs)router.h $(Cs)prntutil.h $(Cs)sysdep.h \
 $(Cs)cstrncmp.h $(Cs)constrnt.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)cstrncmp.o $(Cs)cstrncmp.c

$(Ck)cstrnops.o: $(Cs)cstrnops.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h \
 $(Cs)memalloc.h $(Cs)router.h $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h \
 $(Cs)symbol.h $(Cs)userdata.h $(Cs)evaluatn.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h \
 $(Cs)extnfunc.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h \
 $(Cs)multifld.h $(Cs)constrnt.h $(Cs)cstrnchk.h $(Cs)cstrnutl.h $(Cs)cstrnops.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)cstrnops.o $(Cs)cstrnops.c

$(Ck)cstrnpsr.o: $(Cs)cstrnpsr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h \
 $(Cs)memalloc.h $(Cs)router.h $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h \
 $(Cs)symbol.h $(Cs)userdata.h $(Cs)evaluatn.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h \
 $(Cs)extnfunc.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h \
 $(Cs)cstrnutl.h $(Cs)constrnt.h $(Cs)cstrnchk.h $(Cs)cstrnpsr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)cstrnpsr.o $(Cs)cstrnpsr.c

$(Ck)cstrnutl.o: $(Cs)cstrnutl.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h \
 $(Cs)memalloc.h $(Cs)router.h $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h \
 $(Cs)symbol.h $(Cs)userdata.h $(Cs)evaluatn.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h \
 $(Cs)extnfunc.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h \
 $(Cs)multifld.h $(Cs)argacces.h $(Cs)cstrnutl.h $(Cs)constrnt.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)cstrnutl.o $(Cs)cstrnutl.c

$(Ck)default.o: $(Cs)default.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h $(Cs)constrnt.h \
 $(Cs)evaluatn.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)cstrnchk.h $(Cs)multifld.h $(Cs)inscom.h $(Cs)object.h \
 $(Cs)constrct.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h \
 $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)insfun.h $(Cs)router.h $(Cs)prntutil.h $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)tmpltdef.h $(Cs)factbld.h \
 $(Cs)cstrnutl.h $(Cs)default.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)default.o $(Cs)default.c

$(Ck)defins.o: $(Cs)defins.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)bload.h $(Cs)utility.h \
 $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)userdata.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)dfinsbin.h $(Cs)defins.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)evaluatn.h $(Cs)constant.h \
 $(Cs)symblcmp.h $(Cs)cstrccom.h $(Cs)object.h $(Cs)constrnt.h $(Cs)multifld.h $(Cs)match.h $(Cs)network.h \
 $(Cs)ruledef.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)dfinscmp.h $(Cs)argacces.h $(Cs)classcom.h \
 $(Cs)classfun.h $(Cs)cstrcpsr.h $(Cs)insfun.h $(Cs)inspsr.h $(Cs)memalloc.h $(Cs)router.h $(Cs)prntutil.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)defins.o $(Cs)defins.c

$(Ck)developr.o: $(Cs)developr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)inscom.h $(Cs)object.h $(Cs)constrnt.h \
 $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)pattern.h \
 $(Cs)reorder.h $(Cs)insfun.h $(Cs)modulutl.h $(Cs)router.h $(Cs)prntutil.h $(Cs)tmpltdef.h $(Cs)factbld.h \
 $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)classcom.h $(Cs)classfun.h $(Cs)objrtmch.h $(Cs)developr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)developr.o $(Cs)developr.c

$(Ck)dffctbin.o: $(Cs)dffctbin.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h \
 $(Cs)dffctdef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)symbol.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)cstrccom.h $(Cs)bload.h \
 $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)bsave.h $(Cs)dffctbin.h $(Cs)modulbin.h $(Cs)cstrcbin.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)dffctbin.o $(Cs)dffctbin.c

$(Ck)dffctbsc.o: $(Cs)dffctbsc.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)memalloc.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)cstrccom.h $(Cs)factrhs.h $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)pattern.h $(Cs)match.h \
 $(Cs)network.h $(Cs)ruledef.h $(Cs)constrnt.h $(Cs)agenda.h $(Cs)reorder.h $(Cs)multifld.h $(Cs)tmpltdef.h \
 $(Cs)factbld.h $(Cs)cstrcpsr.h $(Cs)dffctpsr.h $(Cs)dffctdef.h $(Cs)dffctbin.h $(Cs)modulbin.h \
 $(Cs)cstrcbin.h $(Cs)dffctcmp.h $(Cs)dffctbsc.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)dffctbsc.o $(Cs)dffctbsc.c

$(Ck)dffctcmp.o: $(Cs)dffctcmp.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)symbol.h $(Cs)evaluatn.h $(Cs)constant.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h \
 $(Cs)pprint.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)dffctdef.h $(Cs)cstrccom.h $(Cs)dffctcmp.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)dffctcmp.o $(Cs)dffctcmp.c

$(Ck)dffctdef.o: $(Cs)dffctdef.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h \
 $(Cs)dffctpsr.h $(Cs)dffctbsc.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)symbol.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)bload.h \
 $(Cs)utility.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)dffctbin.h $(Cs)modulbin.h \
 $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)cstrcbin.h \
 $(Cs)dffctcmp.h $(Cs)dffctdef.h $(Cs)cstrccom.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)dffctdef.o $(Cs)dffctdef.c

$(Ck)dffctpsr.o: $(Cs)dffctpsr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)cstrcpsr.h $(Cs)factrhs.h \
 $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)pattern.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)constrnt.h \
 $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)reorder.h $(Cs)multifld.h $(Cs)tmpltdef.h $(Cs)factbld.h $(Cs)bload.h \
 $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)dffctdef.h $(Cs)dffctbsc.h $(Cs)dffctpsr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)dffctpsr.o $(Cs)dffctpsr.c

$(Ck)dffnxbin.o: $(Cs)dffnxbin.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)bload.h $(Cs)utility.h \
 $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)userdata.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)bsave.h $(Cs)memalloc.h $(Cs)cstrcbin.h \
 $(Cs)constrct.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)evaluatn.h \
 $(Cs)constant.h $(Cs)modulbin.h $(Cs)dffnxbin.h $(Cs)dffnxfun.h $(Cs)cstrccom.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)dffnxbin.o $(Cs)dffnxbin.c

$(Ck)dffnxcmp.o: $(Cs)dffnxcmp.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)symbol.h $(Cs)evaluatn.h $(Cs)constant.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h \
 $(Cs)pprint.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)dffnxcmp.h $(Cs)dffnxfun.h $(Cs)cstrccom.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)dffnxcmp.o $(Cs)dffnxcmp.c

$(Ck)dffnxexe.o: $(Cs)dffnxexe.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constrct.h \
 $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h \
 $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)userdata.h $(Cs)symblcmp.h $(Cs)modulpsr.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)utility.h $(Cs)prcdrfun.h $(Cs)prccode.h $(Cs)proflfun.h \
 $(Cs)router.h $(Cs)prntutil.h $(Cs)watch.h $(Cs)dffnxexe.h $(Cs)dffnxfun.h $(Cs)cstrccom.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)dffnxexe.o $(Cs)dffnxexe.c

$(Ck)dffnxfun.o: $(Cs)dffnxfun.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)bload.h $(Cs)utility.h \
 $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)userdata.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)dffnxbin.h $(Cs)dffnxfun.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)evaluatn.h $(Cs)constant.h \
 $(Cs)symblcmp.h $(Cs)cstrccom.h $(Cs)dffnxcmp.h $(Cs)cstrcpsr.h $(Cs)dffnxpsr.h $(Cs)dffnxexe.h \
 $(Cs)watch.h $(Cs)argacces.h $(Cs)memalloc.h $(Cs)router.h $(Cs)prntutil.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)dffnxfun.o $(Cs)dffnxfun.c

$(Ck)dffnxpsr.o: $(Cs)dffnxpsr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)bload.h $(Cs)utility.h \
 $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)userdata.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)network.h $(Cs)match.h $(Cs)evaluatn.h \
 $(Cs)constant.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)ruledef.h $(Cs)conscomp.h $(Cs)constrct.h \
 $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)symblcmp.h $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h \
 $(Cs)genrccom.h $(Cs)genrcfun.h $(Cs)object.h $(Cs)multifld.h $(Cs)cstrcpsr.h $(Cs)dffnxfun.h \
 $(Cs)memalloc.h $(Cs)prccode.h $(Cs)router.h $(Cs)prntutil.h $(Cs)dffnxpsr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)dffnxpsr.o $(Cs)dffnxpsr.c

$(Ck)dfinsbin.o: $(Cs)dfinsbin.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)bload.h $(Cs)utility.h \
 $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)userdata.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)bsave.h $(Cs)memalloc.h $(Cs)cstrcbin.h \
 $(Cs)constrct.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)evaluatn.h \
 $(Cs)constant.h $(Cs)defins.h $(Cs)cstrccom.h $(Cs)object.h $(Cs)constrnt.h $(Cs)multifld.h $(Cs)match.h \
 $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)modulbin.h $(Cs)dfinsbin.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)dfinsbin.o $(Cs)dfinsbin.c

$(Ck)dfinscmp.o: $(Cs)dfinscmp.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)symbol.h $(Cs)evaluatn.h $(Cs)constant.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h \
 $(Cs)pprint.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)defins.h $(Cs)cstrccom.h $(Cs)object.h $(Cs)constrnt.h \
 $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)dfinscmp.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)dfinscmp.o $(Cs)dfinscmp.c

$(Ck)drive.o: $(Cs)drive.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)agenda.h $(Cs)ruledef.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)symbol.h $(Cs)evaluatn.h \
 $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)network.h \
 $(Cs)match.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)engine.h $(Cs)lgcldpnd.h $(Cs)retract.h $(Cs)memalloc.h \
 $(Cs)prntutil.h $(Cs)reteutil.h $(Cs)router.h $(Cs)incrrset.h $(Cs)drive.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)drive.o $(Cs)drive.c

$(Ck)edbasic.o: $(Cs)edbasic.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)ed.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)memalloc.h $(Cs)router.h \
 $(Cs)prntutil.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)edbasic.o $(Cs)edbasic.c

$(Ck)edmain.o: $(Cs)edmain.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)ed.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)memalloc.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)sysdep.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)edmain.o $(Cs)edmain.c

$(Ck)edmisc.o: $(Cs)edmisc.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)ed.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)memalloc.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)cstrcpsr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)edmisc.o $(Cs)edmisc.c

$(Ck)edstruct.o: $(Cs)edstruct.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)ed.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)memalloc.h $(Cs)router.h \
 $(Cs)prntutil.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)edstruct.o $(Cs)edstruct.c

$(Ck)edterm.o: $(Cs)edterm.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)ed.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)memalloc.h $(Cs)router.h \
 $(Cs)prntutil.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)edterm.o $(Cs)edterm.c

$(Ck)emathfun.o: $(Cs)emathfun.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)router.h $(Cs)prntutil.h \
 $(Cs)emathfun.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)emathfun.o $(Cs)emathfun.c

$(Ck)engine.o: $(Cs)engine.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)agenda.h $(Cs)ruledef.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)symbol.h $(Cs)evaluatn.h \
 $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)network.h \
 $(Cs)match.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)argacces.h $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)multifld.h \
 $(Cs)tmpltdef.h $(Cs)factbld.h $(Cs)inscom.h $(Cs)object.h $(Cs)insfun.h $(Cs)memalloc.h $(Cs)modulutl.h \
 $(Cs)prccode.h $(Cs)prcdrfun.h $(Cs)proflfun.h $(Cs)reteutil.h $(Cs)retract.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)ruledlt.h $(Cs)sysdep.h $(Cs)watch.h $(Cs)engine.h $(Cs)lgcldpnd.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)engine.o $(Cs)engine.c

$(Ck)envrnmnt.o: $(Cs)envrnmnt.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h \
 $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)router.h $(Cs)engine.h \
 $(Cs)lgcldpnd.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h \
 $(Cs)pattern.h $(Cs)reorder.h $(Cs)retract.h $(Cs)sysdep.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)envrnmnt.o $(Cs)envrnmnt.c

$(Ck)evaluatn.o: $(Cs)evaluatn.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)commline.h \
 $(Cs)constant.h $(Cs)memalloc.h $(Cs)router.h $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)evaluatn.h $(Cs)expressn.h $(Cs)exprnops.h \
 $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h \
 $(Cs)utility.h $(Cs)prcdrfun.h $(Cs)multifld.h $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)pattern.h $(Cs)match.h \
 $(Cs)network.h $(Cs)ruledef.h $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)reorder.h $(Cs)tmpltdef.h \
 $(Cs)factbld.h $(Cs)proflfun.h $(Cs)sysdep.h $(Cs)dffnxfun.h $(Cs)genrccom.h $(Cs)genrcfun.h $(Cs)object.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)evaluatn.o $(Cs)evaluatn.c

$(Ck)expressn.o: $(Cs)expressn.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)bload.h $(Cs)utility.h \
 $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)userdata.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)memalloc.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)evaluatn.h $(Cs)constant.h \
 $(Cs)symblcmp.h $(Cs)modulpsr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)expressn.o $(Cs)expressn.c

$(Ck)exprnbin.o: $(Cs)exprnbin.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h \
 $(Cs)dffctdef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)symbol.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)cstrccom.h $(Cs)bload.h \
 $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)bsave.h $(Cs)network.h $(Cs)match.h $(Cs)pattern.h \
 $(Cs)reorder.h $(Cs)ruledef.h $(Cs)constrnt.h $(Cs)agenda.h $(Cs)genrcbin.h $(Cs)genrcfun.h $(Cs)object.h \
 $(Cs)multifld.h $(Cs)dffnxbin.h $(Cs)dffnxfun.h $(Cs)tmpltbin.h $(Cs)cstrcbin.h $(Cs)modulbin.h \
 $(Cs)tmpltdef.h $(Cs)factbld.h $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)globlbin.h $(Cs)globldef.h \
 $(Cs)objbin.h $(Cs)insfun.h $(Cs)inscom.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)exprnbin.o $(Cs)exprnbin.c

$(Ck)exprnops.o: $(Cs)exprnops.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)cstrnchk.h \
 $(Cs)constrnt.h $(Cs)cstrnutl.h $(Cs)cstrnops.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)exprnops.o $(Cs)exprnops.c

$(Ck)exprnpsr.o: $(Cs)exprnpsr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)evaluatn.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)scanner.h \
 $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)strngrtr.h $(Cs)memalloc.h \
 $(Cs)argacces.h $(Cs)cstrnchk.h $(Cs)constrnt.h $(Cs)modulutl.h $(Cs)prcdrfun.h $(Cs)network.h \
 $(Cs)match.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)ruledef.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)genrccom.h \
 $(Cs)genrcfun.h $(Cs)object.h $(Cs)multifld.h $(Cs)dffnxfun.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)exprnpsr.o $(Cs)exprnpsr.c

$(Ck)extnfunc.o: $(Cs)extnfunc.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)evaluatn.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)scanner.h \
 $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)memalloc.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)extnfunc.o $(Cs)extnfunc.c

$(Ck)factbin.o: $(Cs)factbin.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h $(Cs)tmpltdef.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)symbol.h $(Cs)evaluatn.h \
 $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)constrnt.h $(Cs)factbld.h $(Cs)pattern.h \
 $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)reorder.h $(Cs)factmngr.h \
 $(Cs)facthsh.h $(Cs)multifld.h $(Cs)bload.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)bsave.h \
 $(Cs)reteutil.h $(Cs)rulebin.h $(Cs)modulbin.h $(Cs)cstrcbin.h $(Cs)factbin.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)factbin.o $(Cs)factbin.c

$(Ck)factbld.o: $(Cs)factbld.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h $(Cs)reteutil.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h \
 $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)symblcmp.h \
 $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)router.h $(Cs)prntutil.h \
 $(Cs)factcmp.h $(Cs)factmch.h $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)multifld.h $(Cs)tmpltdef.h \
 $(Cs)factbld.h $(Cs)factgen.h $(Cs)factlhs.h $(Cs)argacces.h $(Cs)modulutl.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)factbld.o $(Cs)factbld.c

$(Ck)factcmp.o: $(Cs)factcmp.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)factbld.h $(Cs)pattern.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h \
 $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)symblcmp.h \
 $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)reorder.h $(Cs)factcmp.h $(Cs)tmpltdef.h \
 $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)multifld.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)factcmp.o $(Cs)factcmp.c

$(Ck)factcom.o: $(Cs)factcom.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h $(Cs)exprnpsr.h \
 $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)pattern.h $(Cs)match.h $(Cs)network.h \
 $(Cs)ruledef.h $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)reorder.h $(Cs)multifld.h \
 $(Cs)tmpltdef.h $(Cs)factbld.h $(Cs)argacces.h $(Cs)router.h $(Cs)prntutil.h $(Cs)factrhs.h $(Cs)factmch.h \
 $(Cs)tmpltpsr.h $(Cs)tmpltutl.h $(Cs)modulutl.h $(Cs)strngrtr.h $(Cs)tmpltfun.h $(Cs)sysdep.h $(Cs)bload.h \
 $(Cs)exprnbin.h $(Cs)symblbin.h $(Cs)factcom.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)factcom.o $(Cs)factcom.c

$(Ck)factfun.o: $(Cs)factfun.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)extnfunc.h $(Cs)symbol.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)userdata.h \
 $(Cs)argacces.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h \
 $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)prntutil.h $(Cs)tmpltutl.h $(Cs)factmngr.h \
 $(Cs)facthsh.h $(Cs)pattern.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)constrnt.h $(Cs)cstrccom.h \
 $(Cs)agenda.h $(Cs)reorder.h $(Cs)multifld.h $(Cs)tmpltdef.h $(Cs)factbld.h $(Cs)router.h $(Cs)factfun.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)factfun.o $(Cs)factfun.c

$(Ck)factgen.o: $(Cs)factgen.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h $(Cs)memalloc.h \
 $(Cs)router.h $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h \
 $(Cs)userdata.h $(Cs)evaluatn.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)network.h $(Cs)match.h \
 $(Cs)pattern.h $(Cs)reorder.h $(Cs)ruledef.h $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)reteutil.h \
 $(Cs)factmch.h $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)multifld.h $(Cs)tmpltdef.h $(Cs)factbld.h \
 $(Cs)factrete.h $(Cs)factprt.h $(Cs)tmpltlhs.h $(Cs)factgen.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)factgen.o $(Cs)factgen.c

$(Ck)facthsh.o: $(Cs)facthsh.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h $(Cs)memalloc.h \
 $(Cs)router.h $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h \
 $(Cs)userdata.h $(Cs)evaluatn.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)lgcldpnd.h $(Cs)match.h \
 $(Cs)network.h $(Cs)ruledef.h $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)facthsh.h $(Cs)factmngr.h $(Cs)multifld.h $(Cs)tmpltdef.h $(Cs)factbld.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)facthsh.o $(Cs)facthsh.c

$(Ck)factlhs.o: $(Cs)factlhs.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)cstrcpsr.h $(Cs)evaluatn.h \
 $(Cs)constant.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)pattern.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h \
 $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)reorder.h $(Cs)router.h $(Cs)prntutil.h $(Cs)tmpltpsr.h \
 $(Cs)tmpltdef.h $(Cs)factbld.h $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)multifld.h $(Cs)tmpltlhs.h \
 $(Cs)tmpltutl.h $(Cs)modulutl.h $(Cs)factlhs.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)factlhs.o $(Cs)factlhs.c

$(Ck)factmch.o: $(Cs)factmch.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)drive.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)match.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)network.h $(Cs)ruledef.h $(Cs)conscomp.h $(Cs)constrct.h \
 $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)constrnt.h $(Cs)cstrccom.h \
 $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)engine.h $(Cs)lgcldpnd.h $(Cs)retract.h $(Cs)factgen.h \
 $(Cs)factrete.h $(Cs)incrrset.h $(Cs)memalloc.h $(Cs)reteutil.h $(Cs)router.h $(Cs)prntutil.h \
 $(Cs)tmpltdef.h $(Cs)factbld.h $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)multifld.h $(Cs)factmch.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)factmch.o $(Cs)factmch.c

$(Ck)factmngr.o: $(Cs)factmngr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h $(Cs)symbol.h \
 $(Cs)memalloc.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)argacces.h $(Cs)evaluatn.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)router.h $(Cs)prntutil.h \
 $(Cs)strngrtr.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h \
 $(Cs)pattern.h $(Cs)reorder.h $(Cs)factbld.h $(Cs)factqury.h $(Cs)factmngr.h $(Cs)facthsh.h \
 $(Cs)multifld.h $(Cs)tmpltdef.h $(Cs)reteutil.h $(Cs)retract.h $(Cs)factcmp.h $(Cs)filecom.h \
 $(Cs)factfun.h $(Cs)factcom.h $(Cs)factrhs.h $(Cs)factmch.h $(Cs)watch.h $(Cs)factbin.h $(Cs)default.h \
 $(Cs)commline.h $(Cs)engine.h $(Cs)lgcldpnd.h $(Cs)drive.h $(Cs)ruledlt.h $(Cs)tmpltbsc.h $(Cs)tmpltutl.h \
 $(Cs)tmpltfun.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)factmngr.o $(Cs)factmngr.c

$(Ck)factprt.o: $(Cs)factprt.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)symbol.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)userdata.h $(Cs)evaluatn.h \
 $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)scanner.h \
 $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)factgen.h $(Cs)reorder.h $(Cs)ruledef.h \
 $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)match.h $(Cs)network.h $(Cs)pattern.h $(Cs)factprt.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)factprt.o $(Cs)factprt.c

$(Ck)factqpsr.o: $(Cs)factqpsr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)exprnpsr.h \
 $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)factqury.h $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h \
 $(Cs)modulpsr.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)pattern.h $(Cs)match.h \
 $(Cs)network.h $(Cs)ruledef.h $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)reorder.h $(Cs)multifld.h \
 $(Cs)tmpltdef.h $(Cs)factbld.h $(Cs)modulutl.h $(Cs)prcdrpsr.h $(Cs)prntutil.h $(Cs)router.h \
 $(Cs)strngrtr.h $(Cs)factqpsr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)factqpsr.o $(Cs)factqpsr.c

$(Ck)factqury.o: $(Cs)factqury.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)memalloc.h $(Cs)modulutl.h \
 $(Cs)tmpltutl.h $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)pattern.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h \
 $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)reorder.h $(Cs)multifld.h $(Cs)tmpltdef.h \
 $(Cs)factbld.h $(Cs)insfun.h $(Cs)object.h $(Cs)factqpsr.h $(Cs)prcdrfun.h $(Cs)router.h $(Cs)prntutil.h \
 $(Cs)factqury.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)factqury.o $(Cs)factqury.c

$(Ck)factrete.o: $(Cs)factrete.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h \
 $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)userdata.h $(Cs)router.h $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)incrrset.h \
 $(Cs)ruledef.h $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)match.h $(Cs)network.h $(Cs)pattern.h \
 $(Cs)reorder.h $(Cs)reteutil.h $(Cs)drive.h $(Cs)engine.h $(Cs)lgcldpnd.h $(Cs)retract.h $(Cs)factgen.h \
 $(Cs)factmch.h $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)multifld.h $(Cs)tmpltdef.h $(Cs)factbld.h \
 $(Cs)factrete.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)factrete.o $(Cs)factrete.c

$(Ck)factrhs.o: $(Cs)factrhs.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h $(Cs)extnfunc.h \
 $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)userdata.h \
 $(Cs)modulutl.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)evaluatn.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)utility.h $(Cs)pattern.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)constrnt.h \
 $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)reorder.h $(Cs)prntutil.h $(Cs)cstrcpsr.h $(Cs)bload.h $(Cs)exprnbin.h \
 $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)tmpltpsr.h $(Cs)tmpltdef.h $(Cs)factbld.h $(Cs)factmngr.h \
 $(Cs)facthsh.h $(Cs)multifld.h $(Cs)tmpltrhs.h $(Cs)tmpltutl.h $(Cs)strngrtr.h $(Cs)router.h \
 $(Cs)factrhs.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)factrhs.o $(Cs)factrhs.c

$(Ck)filecom.o: $(Cs)filecom.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)utility.h $(Cs)commline.h $(Cs)cstrcpsr.h $(Cs)memalloc.h $(Cs)prcdrfun.h \
 $(Cs)router.h $(Cs)prntutil.h $(Cs)strngrtr.h $(Cs)sysdep.h $(Cs)filecom.h $(Cs)bsave.h $(Cs)bload.h \
 $(Cs)exprnbin.h $(Cs)symblbin.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)filecom.o $(Cs)filecom.c

$(Ck)filertr.o: $(Cs)filertr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h $(Cs)memalloc.h \
 $(Cs)router.h $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h \
 $(Cs)userdata.h $(Cs)evaluatn.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)sysdep.h $(Cs)filertr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)filertr.o $(Cs)filertr.c

$(Ck)generate.o: $(Cs)generate.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h \
 $(Cs)memalloc.h $(Cs)symbol.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)expressn.h $(Cs)exprnops.h \
 $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)argacces.h $(Cs)evaluatn.h $(Cs)moduldef.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)ruledef.h $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)match.h $(Cs)network.h \
 $(Cs)pattern.h $(Cs)reorder.h $(Cs)generate.h $(Cs)globlpsr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)generate.o $(Cs)generate.c

$(Ck)genrcbin.o: $(Cs)genrcbin.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h \
 $(Cs)memalloc.h $(Cs)bload.h $(Cs)utility.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h \
 $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)userdata.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h \
 $(Cs)bsave.h $(Cs)cstrcbin.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)evaluatn.h $(Cs)objbin.h $(Cs)object.h $(Cs)constrnt.h $(Cs)multifld.h $(Cs)match.h \
 $(Cs)network.h $(Cs)ruledef.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)genrccom.h \
 $(Cs)genrcfun.h $(Cs)modulbin.h $(Cs)genrcbin.h $(Cs)router.h $(Cs)prntutil.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)genrcbin.o $(Cs)genrcbin.c

$(Ck)genrccmp.o: $(Cs)genrccmp.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)network.h $(Cs)match.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h \
 $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)ruledef.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)symblcmp.h \
 $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)genrccom.h $(Cs)genrcfun.h $(Cs)object.h \
 $(Cs)multifld.h $(Cs)objcmp.h $(Cs)genrccmp.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)genrccmp.o $(Cs)genrccmp.c

$(Ck)genrccom.o: $(Cs)genrccom.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)network.h $(Cs)match.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h \
 $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)ruledef.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)symblcmp.h \
 $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)bload.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h \
 $(Cs)genrcbin.h $(Cs)genrcfun.h $(Cs)object.h $(Cs)multifld.h $(Cs)genrccmp.h $(Cs)genrcpsr.h \
 $(Cs)classcom.h $(Cs)inscom.h $(Cs)insfun.h $(Cs)watch.h $(Cs)argacces.h $(Cs)cstrcpsr.h $(Cs)genrcexe.h \
 $(Cs)memalloc.h $(Cs)router.h $(Cs)prntutil.h $(Cs)genrccom.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)genrccom.o $(Cs)genrccom.c

$(Ck)genrcexe.o: $(Cs)genrcexe.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)classcom.h \
 $(Cs)cstrccom.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)object.h $(Cs)constrnt.h \
 $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)classfun.h $(Cs)insfun.h $(Cs)argacces.h $(Cs)genrccom.h $(Cs)genrcfun.h $(Cs)prcdrfun.h \
 $(Cs)prccode.h $(Cs)proflfun.h $(Cs)router.h $(Cs)prntutil.h $(Cs)genrcexe.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)genrcexe.o $(Cs)genrcexe.c

$(Ck)genrcfun.o: $(Cs)genrcfun.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)bload.h $(Cs)utility.h \
 $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)userdata.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)classcom.h $(Cs)cstrccom.h \
 $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)object.h $(Cs)constrnt.h $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h \
 $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)classfun.h $(Cs)argacces.h $(Cs)cstrcpsr.h \
 $(Cs)genrccom.h $(Cs)genrcfun.h $(Cs)genrcexe.h $(Cs)memalloc.h $(Cs)prccode.h $(Cs)router.h \
 $(Cs)prntutil.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)genrcfun.o $(Cs)genrcfun.c

$(Ck)genrcpsr.o: $(Cs)genrcpsr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)bload.h $(Cs)utility.h \
 $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)userdata.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)dffnxfun.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)symblcmp.h \
 $(Cs)cstrccom.h $(Cs)classfun.h $(Cs)object.h $(Cs)constrnt.h $(Cs)multifld.h $(Cs)match.h $(Cs)network.h \
 $(Cs)ruledef.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)classcom.h $(Cs)memalloc.h $(Cs)cstrcpsr.h \
 $(Cs)genrccom.h $(Cs)genrcfun.h $(Cs)immthpsr.h $(Cs)modulutl.h $(Cs)prcdrpsr.h $(Cs)prccode.h \
 $(Cs)router.h $(Cs)prntutil.h $(Cs)genrcpsr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)genrcpsr.o $(Cs)genrcpsr.c

$(Ck)globlbin.o: $(Cs)globlbin.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h \
 $(Cs)multifld.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h \
 $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)globldef.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)symblcmp.h \
 $(Cs)cstrccom.h $(Cs)bload.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)bsave.h $(Cs)globlbsc.h \
 $(Cs)globlbin.h $(Cs)modulbin.h $(Cs)cstrcbin.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)globlbin.o $(Cs)globlbin.c

$(Ck)globlbsc.o: $(Cs)globlbsc.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constrct.h \
 $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h \
 $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)userdata.h $(Cs)symblcmp.h $(Cs)modulpsr.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)utility.h $(Cs)watch.h $(Cs)globlcom.h $(Cs)globldef.h \
 $(Cs)cstrccom.h $(Cs)globlbin.h $(Cs)modulbin.h $(Cs)cstrcbin.h $(Cs)globlcmp.h $(Cs)globlbsc.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)globlbsc.o $(Cs)globlbsc.c

$(Ck)globlcmp.o: $(Cs)globlcmp.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)symbol.h $(Cs)evaluatn.h $(Cs)constant.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h \
 $(Cs)pprint.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)globldef.h $(Cs)cstrccom.h $(Cs)globlcmp.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)globlcmp.o $(Cs)globlcmp.c

$(Ck)globlcom.o: $(Cs)globlcom.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)extnfunc.h $(Cs)symbol.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)userdata.h \
 $(Cs)argacces.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h \
 $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)prntutil.h $(Cs)router.h $(Cs)globldef.h \
 $(Cs)cstrccom.h $(Cs)globlcom.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)globlcom.o $(Cs)globlcom.c

$(Ck)globldef.o: $(Cs)globldef.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h \
 $(Cs)modulpsr.h $(Cs)symbol.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h \
 $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)moduldef.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)utility.h $(Cs)multifld.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)strngrtr.h $(Cs)modulutl.h $(Cs)globlbsc.h $(Cs)globlpsr.h $(Cs)globlcom.h \
 $(Cs)commline.h $(Cs)bload.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)globlbin.h $(Cs)modulbin.h \
 $(Cs)cstrcbin.h $(Cs)globldef.h $(Cs)cstrccom.h $(Cs)globlcmp.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)globldef.o $(Cs)globldef.c

$(Ck)globlpsr.o: $(Cs)globlpsr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)pprint.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)scanner.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)memalloc.h $(Cs)multifld.h $(Cs)watch.h \
 $(Cs)modulutl.h $(Cs)cstrcpsr.h $(Cs)globldef.h $(Cs)cstrccom.h $(Cs)globlbsc.h $(Cs)bload.h \
 $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)globlpsr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)globlpsr.o $(Cs)globlpsr.c

$(Ck)immthpsr.o: $(Cs)immthpsr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)classcom.h \
 $(Cs)cstrccom.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)object.h $(Cs)constrnt.h \
 $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)classfun.h $(Cs)memalloc.h $(Cs)cstrnutl.h $(Cs)genrcpsr.h $(Cs)genrcfun.h $(Cs)prccode.h \
 $(Cs)immthpsr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)immthpsr.o $(Cs)immthpsr.c

$(Ck)incrrset.o: $(Cs)incrrset.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)agenda.h $(Cs)ruledef.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)symbol.h $(Cs)evaluatn.h \
 $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)network.h \
 $(Cs)match.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)argacces.h $(Cs)drive.h $(Cs)engine.h $(Cs)lgcldpnd.h \
 $(Cs)retract.h $(Cs)router.h $(Cs)prntutil.h $(Cs)incrrset.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)incrrset.o $(Cs)incrrset.c

$(Ck)inherpsr.o: $(Cs)inherpsr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)classcom.h \
 $(Cs)cstrccom.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)object.h $(Cs)constrnt.h \
 $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)classfun.h $(Cs)memalloc.h $(Cs)modulutl.h $(Cs)router.h $(Cs)prntutil.h $(Cs)inherpsr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)inherpsr.o $(Cs)inherpsr.c

$(Ck)inscom.o: $(Cs)inscom.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)utility.h $(Cs)classcom.h $(Cs)cstrccom.h $(Cs)object.h $(Cs)constrnt.h \
 $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)classfun.h $(Cs)classinf.h $(Cs)insfile.h $(Cs)insfun.h $(Cs)insmngr.h $(Cs)insmoddp.h $(Cs)insmult.h \
 $(Cs)inspsr.h $(Cs)lgcldpnd.h $(Cs)memalloc.h $(Cs)msgcom.h $(Cs)msgpass.h $(Cs)msgfun.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)strngrtr.h $(Cs)sysdep.h $(Cs)commline.h $(Cs)inscom.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)inscom.o $(Cs)inscom.c

$(Ck)insfile.o: $(Cs)insfile.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)utility.h $(Cs)classcom.h $(Cs)cstrccom.h $(Cs)object.h $(Cs)constrnt.h \
 $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)classfun.h $(Cs)memalloc.h $(Cs)inscom.h $(Cs)insfun.h $(Cs)insmngr.h $(Cs)inspsr.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)strngrtr.h $(Cs)symblbin.h $(Cs)sysdep.h $(Cs)factmngr.h $(Cs)facthsh.h \
 $(Cs)tmpltdef.h $(Cs)factbld.h $(Cs)insfile.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)insfile.o $(Cs)insfile.c

$(Ck)insfun.o: $(Cs)insfun.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)utility.h $(Cs)classcom.h $(Cs)cstrccom.h $(Cs)object.h $(Cs)constrnt.h \
 $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)classfun.h $(Cs)cstrnchk.h $(Cs)engine.h $(Cs)lgcldpnd.h $(Cs)retract.h $(Cs)inscom.h $(Cs)insfun.h \
 $(Cs)insmngr.h $(Cs)memalloc.h $(Cs)modulutl.h $(Cs)msgcom.h $(Cs)msgpass.h $(Cs)msgfun.h $(Cs)prccode.h \
 $(Cs)router.h $(Cs)prntutil.h $(Cs)drive.h $(Cs)objrtmch.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)insfun.o $(Cs)insfun.c

$(Ck)insmngr.o: $(Cs)insmngr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)network.h $(Cs)match.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h \
 $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)ruledef.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)symblcmp.h \
 $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)drive.h $(Cs)objrtmch.h $(Cs)object.h $(Cs)multifld.h \
 $(Cs)lgcldpnd.h $(Cs)classcom.h $(Cs)classfun.h $(Cs)engine.h $(Cs)retract.h $(Cs)memalloc.h $(Cs)insfun.h \
 $(Cs)modulutl.h $(Cs)msgcom.h $(Cs)msgpass.h $(Cs)msgfun.h $(Cs)prccode.h $(Cs)router.h $(Cs)prntutil.h \
 $(Cs)insmngr.h $(Cs)inscom.h $(Cs)watch.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)insmngr.o $(Cs)insmngr.c

$(Ck)insmoddp.o: $(Cs)insmoddp.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)network.h $(Cs)match.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h \
 $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)ruledef.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)symblcmp.h \
 $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)objrtmch.h $(Cs)object.h $(Cs)multifld.h \
 $(Cs)argacces.h $(Cs)memalloc.h $(Cs)inscom.h $(Cs)insfun.h $(Cs)insmngr.h $(Cs)inspsr.h $(Cs)miscfun.h \
 $(Cs)msgcom.h $(Cs)msgpass.h $(Cs)msgfun.h $(Cs)prccode.h $(Cs)router.h $(Cs)prntutil.h $(Cs)insmoddp.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)insmoddp.o $(Cs)insmoddp.c

$(Ck)insmult.o: $(Cs)insmult.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)utility.h $(Cs)insfun.h $(Cs)object.h $(Cs)constrnt.h $(Cs)multifld.h $(Cs)match.h \
 $(Cs)network.h $(Cs)ruledef.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)msgfun.h \
 $(Cs)msgpass.h $(Cs)multifun.h $(Cs)router.h $(Cs)prntutil.h $(Cs)insmult.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)insmult.o $(Cs)insmult.c

$(Ck)inspsr.o: $(Cs)inspsr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)classcom.h $(Cs)cstrccom.h \
 $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)evaluatn.h \
 $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)scanner.h \
 $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)object.h $(Cs)constrnt.h $(Cs)multifld.h \
 $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)classfun.h \
 $(Cs)classinf.h $(Cs)prntutil.h $(Cs)router.h $(Cs)inspsr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)inspsr.o $(Cs)inspsr.c

$(Ck)insquery.o: $(Cs)insquery.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)classcom.h $(Cs)cstrccom.h \
 $(Cs)object.h $(Cs)constrnt.h $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h \
 $(Cs)pattern.h $(Cs)reorder.h $(Cs)classfun.h $(Cs)memalloc.h $(Cs)insfun.h $(Cs)insmngr.h $(Cs)insqypsr.h \
 $(Cs)prcdrfun.h $(Cs)router.h $(Cs)prntutil.h $(Cs)insquery.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)insquery.o $(Cs)insquery.c

$(Ck)insqypsr.o: $(Cs)insqypsr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)classcom.h \
 $(Cs)cstrccom.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)object.h $(Cs)constrnt.h \
 $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)insquery.h $(Cs)prcdrpsr.h $(Cs)prntutil.h $(Cs)router.h $(Cs)strngrtr.h $(Cs)insqypsr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)insqypsr.o $(Cs)insqypsr.c

$(Ck)iofun.o: $(Cs)iofun.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)router.h $(Cs)prntutil.h \
 $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)evaluatn.h \
 $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)scanner.h \
 $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)strngrtr.h $(Cs)filertr.h \
 $(Cs)argacces.h $(Cs)memalloc.h $(Cs)commline.h $(Cs)sysdep.h $(Cs)iofun.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)iofun.o $(Cs)iofun.c

$(Ck)lgcldpnd.o: $(Cs)lgcldpnd.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)engine.h $(Cs)lgcldpnd.h \
 $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)pattern.h \
 $(Cs)reorder.h $(Cs)retract.h $(Cs)reteutil.h $(Cs)argacces.h $(Cs)factmngr.h $(Cs)facthsh.h \
 $(Cs)multifld.h $(Cs)tmpltdef.h $(Cs)factbld.h $(Cs)insfun.h $(Cs)object.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)lgcldpnd.o $(Cs)lgcldpnd.c

$(Ck)main.o: $(Cs)main.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)sysdep.h $(Cs)extnfunc.h $(Cs)symbol.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)userdata.h \
 $(Cs)commline.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)main.o $(Cs)main.c

$(Ck)memalloc.o: $(Cs)memalloc.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h \
 $(Cs)memalloc.h $(Cs)router.h $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h \
 $(Cs)symbol.h $(Cs)userdata.h $(Cs)evaluatn.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h \
 $(Cs)extnfunc.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)memalloc.o $(Cs)memalloc.c

$(Ck)miscfun.o: $(Cs)miscfun.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)utility.h $(Cs)memalloc.h $(Cs)multifld.h $(Cs)router.h $(Cs)prntutil.h $(Cs)sysdep.h \
 $(Cs)dffnxfun.h $(Cs)cstrccom.h $(Cs)miscfun.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)miscfun.o $(Cs)miscfun.c

$(Ck)modulbin.o: $(Cs)modulbin.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h \
 $(Cs)constrct.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)userdata.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)utility.h $(Cs)bload.h $(Cs)exprnbin.h $(Cs)sysdep.h \
 $(Cs)symblbin.h $(Cs)bsave.h $(Cs)modulbin.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)modulbin.o $(Cs)modulbin.c

$(Ck)modulbsc.o: $(Cs)modulbsc.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constrct.h \
 $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h \
 $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)userdata.h $(Cs)symblcmp.h $(Cs)modulpsr.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)utility.h $(Cs)modulbin.h $(Cs)prntutil.h $(Cs)modulcmp.h \
 $(Cs)router.h $(Cs)argacces.h $(Cs)bload.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)modulbsc.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)modulbsc.o $(Cs)modulbsc.c

$(Ck)modulcmp.o: $(Cs)modulcmp.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)symbol.h $(Cs)evaluatn.h $(Cs)constant.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h \
 $(Cs)pprint.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)sysdep.h $(Cs)modulcmp.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)modulcmp.o $(Cs)modulcmp.c

$(Ck)moduldef.o: $(Cs)moduldef.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h \
 $(Cs)constant.h $(Cs)router.h $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h \
 $(Cs)symbol.h $(Cs)userdata.h $(Cs)evaluatn.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h \
 $(Cs)extnfunc.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h \
 $(Cs)argacces.h $(Cs)modulcmp.h $(Cs)modulbsc.h $(Cs)bload.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h \
 $(Cs)modulbin.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)moduldef.o $(Cs)moduldef.c

$(Ck)modulpsr.o: $(Cs)modulpsr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h \
 $(Cs)constant.h $(Cs)router.h $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h \
 $(Cs)symbol.h $(Cs)userdata.h $(Cs)evaluatn.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h \
 $(Cs)extnfunc.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h \
 $(Cs)argacces.h $(Cs)cstrcpsr.h $(Cs)modulutl.h $(Cs)bload.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)modulpsr.o $(Cs)modulpsr.c

$(Ck)modulutl.o: $(Cs)modulutl.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)modulutl.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)modulutl.o $(Cs)modulutl.c

$(Ck)msgcom.o: $(Cs)msgcom.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)utility.h $(Cs)classcom.h $(Cs)cstrccom.h $(Cs)object.h $(Cs)constrnt.h \
 $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)classfun.h $(Cs)classinf.h $(Cs)insfun.h $(Cs)insmoddp.h $(Cs)msgfun.h $(Cs)msgpass.h $(Cs)prccode.h \
 $(Cs)router.h $(Cs)prntutil.h $(Cs)bload.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)msgpsr.h \
 $(Cs)watch.h $(Cs)msgcom.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)msgcom.o $(Cs)msgcom.c

$(Ck)msgfun.o: $(Cs)msgfun.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)classcom.h $(Cs)cstrccom.h \
 $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)evaluatn.h \
 $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)scanner.h \
 $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)object.h $(Cs)constrnt.h $(Cs)multifld.h \
 $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)classfun.h \
 $(Cs)memalloc.h $(Cs)insfun.h $(Cs)msgcom.h $(Cs)msgpass.h $(Cs)prccode.h $(Cs)router.h $(Cs)prntutil.h \
 $(Cs)msgfun.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)msgfun.o $(Cs)msgfun.c

$(Ck)msgpass.o: $(Cs)msgpass.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)utility.h $(Cs)classcom.h $(Cs)cstrccom.h $(Cs)object.h $(Cs)constrnt.h \
 $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)classfun.h $(Cs)memalloc.h $(Cs)insfun.h $(Cs)msgcom.h $(Cs)msgpass.h $(Cs)msgfun.h $(Cs)prcdrfun.h \
 $(Cs)prccode.h $(Cs)proflfun.h $(Cs)router.h $(Cs)prntutil.h $(Cs)strngfun.h $(Cs)commline.h $(Cs)inscom.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)msgpass.o $(Cs)msgpass.c

$(Ck)msgpsr.o: $(Cs)msgpsr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)bload.h $(Cs)utility.h \
 $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)userdata.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)classcom.h $(Cs)cstrccom.h \
 $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)object.h $(Cs)constrnt.h $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h \
 $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)classfun.h $(Cs)memalloc.h $(Cs)cstrcpsr.h \
 $(Cs)cstrnchk.h $(Cs)insfun.h $(Cs)msgcom.h $(Cs)msgpass.h $(Cs)msgfun.h $(Cs)prccode.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)strngrtr.h $(Cs)msgpsr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)msgpsr.o $(Cs)msgpsr.c

$(Ck)multifld.o: $(Cs)multifld.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h \
 $(Cs)memalloc.h $(Cs)evaluatn.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h \
 $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)router.h $(Cs)prntutil.h $(Cs)moduldef.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)strngrtr.h \
 $(Cs)object.h $(Cs)constrnt.h $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)cstrccom.h \
 $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)multifld.o $(Cs)multifld.c

$(Ck)multifun.o: $(Cs)multifun.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)memalloc.h $(Cs)multifld.h \
 $(Cs)multifun.h $(Cs)prcdrpsr.h $(Cs)constrnt.h $(Cs)prcdrfun.h $(Cs)router.h $(Cs)prntutil.h \
 $(Cs)object.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)pattern.h \
 $(Cs)reorder.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)multifun.o $(Cs)multifun.c

$(Ck)objbin.o: $(Cs)objbin.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)bload.h $(Cs)utility.h \
 $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)userdata.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)bsave.h $(Cs)classcom.h $(Cs)cstrccom.h \
 $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)object.h $(Cs)constrnt.h $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h \
 $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)classfun.h $(Cs)classini.h $(Cs)cstrcbin.h \
 $(Cs)cstrnbin.h $(Cs)insfun.h $(Cs)memalloc.h $(Cs)modulbin.h $(Cs)msgcom.h $(Cs)msgpass.h $(Cs)msgfun.h \
 $(Cs)prntutil.h $(Cs)router.h $(Cs)objbin.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)objbin.o $(Cs)objbin.c

$(Ck)objcmp.o: $(Cs)objcmp.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)conscomp.h $(Cs)constrct.h \
 $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)symbol.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)utility.h $(Cs)symblcmp.h $(Cs)classcom.h $(Cs)cstrccom.h $(Cs)object.h $(Cs)constrnt.h \
 $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)classfun.h $(Cs)classini.h $(Cs)cstrncmp.h $(Cs)objrtfnx.h $(Cs)objrtmch.h $(Cs)sysdep.h \
 $(Cs)objcmp.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)objcmp.o $(Cs)objcmp.c

$(Ck)objrtbin.o: $(Cs)objrtbin.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)bload.h $(Cs)utility.h \
 $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)userdata.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)bsave.h $(Cs)memalloc.h $(Cs)insfun.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)object.h $(Cs)constrnt.h $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h \
 $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)objrtmch.h $(Cs)reteutil.h $(Cs)rulebin.h \
 $(Cs)modulbin.h $(Cs)cstrcbin.h $(Cs)objrtbin.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)objrtbin.o $(Cs)objrtbin.c

$(Ck)objrtbld.o: $(Cs)objrtbld.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)classcom.h \
 $(Cs)cstrccom.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)object.h $(Cs)constrnt.h \
 $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)classfun.h $(Cs)cstrnutl.h $(Cs)cstrnchk.h $(Cs)cstrnops.h $(Cs)drive.h $(Cs)inscom.h $(Cs)insfun.h \
 $(Cs)insmngr.h $(Cs)memalloc.h $(Cs)reteutil.h $(Cs)rulepsr.h $(Cs)objrtmch.h $(Cs)objrtgen.h \
 $(Cs)objrtfnx.h $(Cs)router.h $(Cs)prntutil.h $(Cs)objrtcmp.h $(Cs)objrtbin.h $(Cs)objrtbld.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)objrtbld.o $(Cs)objrtbld.c

$(Ck)objrtcmp.o: $(Cs)objrtcmp.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)symbol.h $(Cs)evaluatn.h $(Cs)constant.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h \
 $(Cs)pprint.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)objrtfnx.h $(Cs)object.h $(Cs)constrnt.h $(Cs)multifld.h \
 $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)objrtmch.h $(Cs)sysdep.h $(Cs)objrtcmp.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)objrtcmp.o $(Cs)objrtcmp.c

$(Ck)objrtfnx.o: $(Cs)objrtfnx.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)classcom.h \
 $(Cs)cstrccom.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)object.h $(Cs)constrnt.h \
 $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)classfun.h $(Cs)bload.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)drive.h $(Cs)engine.h \
 $(Cs)lgcldpnd.h $(Cs)retract.h $(Cs)memalloc.h $(Cs)objrtmch.h $(Cs)reteutil.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)objrtfnx.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)objrtfnx.o $(Cs)objrtfnx.c

$(Ck)objrtgen.o: $(Cs)objrtgen.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)classfun.h $(Cs)object.h \
 $(Cs)constrct.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)userdata.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)utility.h $(Cs)constrnt.h $(Cs)multifld.h \
 $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)objrtfnx.h $(Cs)objrtmch.h $(Cs)objrtgen.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)objrtgen.o $(Cs)objrtgen.c

$(Ck)objrtmch.o: $(Cs)objrtmch.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)classfun.h $(Cs)object.h \
 $(Cs)constrct.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)userdata.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)utility.h $(Cs)constrnt.h $(Cs)multifld.h \
 $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)memalloc.h $(Cs)drive.h $(Cs)engine.h $(Cs)lgcldpnd.h $(Cs)retract.h $(Cs)incrrset.h $(Cs)reteutil.h \
 $(Cs)ruledlt.h $(Cs)router.h $(Cs)prntutil.h $(Cs)objrtfnx.h $(Cs)objrtmch.h $(Cs)insmngr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)objrtmch.o $(Cs)objrtmch.c

$(Ck)parsefun.o: $(Cs)parsefun.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)cstrcpsr.h $(Cs)memalloc.h \
 $(Cs)multifld.h $(Cs)prcdrpsr.h $(Cs)constrnt.h $(Cs)router.h $(Cs)prntutil.h $(Cs)strngrtr.h \
 $(Cs)parsefun.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)parsefun.o $(Cs)parsefun.c

$(Ck)pattern.o: $(Cs)pattern.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h $(Cs)constrnt.h \
 $(Cs)evaluatn.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)cstrnchk.h $(Cs)cstrnutl.h $(Cs)match.h $(Cs)network.h \
 $(Cs)ruledef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)utility.h \
 $(Cs)symblcmp.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)memalloc.h \
 $(Cs)reteutil.h $(Cs)router.h $(Cs)prntutil.h $(Cs)rulecmp.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)pattern.o $(Cs)pattern.c

$(Ck)pprint.o: $(Cs)pprint.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h $(Cs)memalloc.h \
 $(Cs)utility.h $(Cs)pprint.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)pprint.o $(Cs)pprint.c

$(Ck)prccode.o: $(Cs)prccode.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h $(Cs)constant.h \
 $(Cs)globlpsr.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h \
 $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)multifld.h $(Cs)evaluatn.h $(Cs)object.h $(Cs)constrct.h \
 $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)constrnt.h \
 $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)prcdrpsr.h $(Cs)router.h $(Cs)prntutil.h $(Cs)prccode.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)prccode.o $(Cs)prccode.c

$(Ck)prcdrfun.o: $(Cs)prcdrfun.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)constrnt.h $(Cs)cstrnchk.h \
 $(Cs)cstrnops.h $(Cs)memalloc.h $(Cs)multifld.h $(Cs)prcdrpsr.h $(Cs)router.h $(Cs)prntutil.h \
 $(Cs)prcdrfun.h $(Cs)globldef.h $(Cs)cstrccom.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)prcdrfun.o $(Cs)prcdrfun.c

$(Ck)prcdrpsr.o: $(Cs)prcdrpsr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)constrnt.h $(Cs)cstrnchk.h \
 $(Cs)cstrnops.h $(Cs)cstrnutl.h $(Cs)memalloc.h $(Cs)modulutl.h $(Cs)multifld.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)prcdrpsr.h $(Cs)globldef.h $(Cs)cstrccom.h $(Cs)globlpsr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)prcdrpsr.o $(Cs)prcdrpsr.c

$(Ck)prdctfun.o: $(Cs)prdctfun.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)exprnpsr.h \
 $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)argacces.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h \
 $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)multifld.h $(Cs)router.h $(Cs)prntutil.h \
 $(Cs)prdctfun.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)prdctfun.o $(Cs)prdctfun.c

$(Ck)prntutil.o: $(Cs)prntutil.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h $(Cs)symbol.h \
 $(Cs)utility.h $(Cs)evaluatn.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)argacces.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)router.h $(Cs)prntutil.h $(Cs)multifun.h \
 $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)pattern.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)constrnt.h \
 $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)reorder.h $(Cs)multifld.h $(Cs)tmpltdef.h $(Cs)factbld.h $(Cs)inscom.h \
 $(Cs)object.h $(Cs)insfun.h $(Cs)insmngr.h $(Cs)memalloc.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)prntutil.o $(Cs)prntutil.c

$(Ck)proflfun.o: $(Cs)proflfun.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)classcom.h $(Cs)cstrccom.h \
 $(Cs)object.h $(Cs)constrnt.h $(Cs)multifld.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)agenda.h \
 $(Cs)pattern.h $(Cs)reorder.h $(Cs)dffnxfun.h $(Cs)genrccom.h $(Cs)genrcfun.h $(Cs)memalloc.h \
 $(Cs)msgcom.h $(Cs)msgpass.h $(Cs)router.h $(Cs)prntutil.h $(Cs)sysdep.h $(Cs)proflfun.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)proflfun.o $(Cs)proflfun.c

$(Ck)reorder.o: $(Cs)reorder.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)cstrnutl.h $(Cs)constrnt.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h \
 $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)memalloc.h $(Cs)pattern.h $(Cs)match.h \
 $(Cs)network.h $(Cs)ruledef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h \
 $(Cs)utility.h $(Cs)symblcmp.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)reorder.h $(Cs)prntutil.h $(Cs)router.h \
 $(Cs)rulelhs.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)reorder.o $(Cs)reorder.c

$(Ck)reteutil.o: $(Cs)reteutil.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)drive.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)match.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)network.h $(Cs)ruledef.h $(Cs)conscomp.h $(Cs)constrct.h \
 $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)constrnt.h $(Cs)cstrccom.h \
 $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)engine.h $(Cs)lgcldpnd.h $(Cs)retract.h $(Cs)incrrset.h \
 $(Cs)memalloc.h $(Cs)router.h $(Cs)prntutil.h $(Cs)reteutil.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)reteutil.o $(Cs)reteutil.c

$(Ck)retract.o: $(Cs)retract.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)agenda.h $(Cs)ruledef.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)symbol.h $(Cs)evaluatn.h \
 $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)network.h \
 $(Cs)match.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)argacces.h $(Cs)drive.h $(Cs)engine.h $(Cs)lgcldpnd.h \
 $(Cs)retract.h $(Cs)memalloc.h $(Cs)reteutil.h $(Cs)router.h $(Cs)prntutil.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)retract.o $(Cs)retract.c

$(Ck)router.o: $(Cs)router.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)utility.h $(Cs)filertr.h $(Cs)memalloc.h $(Cs)strngrtr.h $(Cs)sysdep.h $(Cs)router.h \
 $(Cs)prntutil.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)router.o $(Cs)router.c

$(Ck)rulebin.o: $(Cs)rulebin.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h $(Cs)bload.h \
 $(Cs)utility.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)userdata.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)bsave.h \
 $(Cs)reteutil.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)symblcmp.h $(Cs)constrnt.h $(Cs)cstrccom.h \
 $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)engine.h $(Cs)lgcldpnd.h $(Cs)retract.h $(Cs)rulebsc.h \
 $(Cs)rulebin.h $(Cs)modulbin.h $(Cs)cstrcbin.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)rulebin.o $(Cs)rulebin.c

$(Ck)rulebld.o: $(Cs)rulebld.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h $(Cs)constrct.h \
 $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h \
 $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)userdata.h $(Cs)symblcmp.h $(Cs)modulpsr.h \
 $(Cs)evaluatn.h $(Cs)utility.h $(Cs)drive.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)constrnt.h \
 $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)incrrset.h $(Cs)memalloc.h \
 $(Cs)reteutil.h $(Cs)router.h $(Cs)prntutil.h $(Cs)rulebld.h $(Cs)watch.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)rulebld.o $(Cs)rulebld.c

$(Ck)rulebsc.o: $(Cs)rulebsc.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)utility.h $(Cs)router.h $(Cs)prntutil.h $(Cs)watch.h $(Cs)ruledef.h $(Cs)constrnt.h \
 $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)match.h $(Cs)network.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)engine.h \
 $(Cs)lgcldpnd.h $(Cs)retract.h $(Cs)rulebin.h $(Cs)modulbin.h $(Cs)cstrcbin.h $(Cs)rulecmp.h \
 $(Cs)rulebsc.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)rulebsc.o $(Cs)rulebsc.c

$(Ck)rulecmp.o: $(Cs)rulecmp.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)factbld.h $(Cs)pattern.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h \
 $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)symblcmp.h \
 $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)reorder.h $(Cs)reteutil.h $(Cs)rulecmp.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)rulecmp.o $(Cs)rulecmp.c

$(Ck)rulecom.o: $(Cs)rulecom.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)utility.h $(Cs)crstrtgy.h $(Cs)agenda.h $(Cs)ruledef.h $(Cs)constrnt.h \
 $(Cs)cstrccom.h $(Cs)network.h $(Cs)match.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)engine.h $(Cs)lgcldpnd.h \
 $(Cs)retract.h $(Cs)incrrset.h $(Cs)memalloc.h $(Cs)reteutil.h $(Cs)router.h $(Cs)prntutil.h \
 $(Cs)ruledlt.h $(Cs)watch.h $(Cs)rulebin.h $(Cs)modulbin.h $(Cs)cstrcbin.h $(Cs)rulecom.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)rulecom.o $(Cs)rulecom.c

$(Ck)rulecstr.o: $(Cs)rulecstr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)analysis.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)reorder.h $(Cs)ruledef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h \
 $(Cs)modulpsr.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)constrnt.h \
 $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)match.h $(Cs)network.h $(Cs)pattern.h $(Cs)cstrnchk.h $(Cs)cstrnops.h \
 $(Cs)cstrnutl.h $(Cs)prcdrpsr.h $(Cs)router.h $(Cs)prntutil.h $(Cs)rulepsr.h $(Cs)rulecstr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)rulecstr.o $(Cs)rulecstr.c

$(Ck)ruledef.o: $(Cs)ruledef.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)agenda.h $(Cs)ruledef.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)symbol.h $(Cs)evaluatn.h \
 $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)network.h \
 $(Cs)match.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)drive.h $(Cs)engine.h $(Cs)lgcldpnd.h $(Cs)retract.h \
 $(Cs)memalloc.h $(Cs)rulebsc.h $(Cs)rulecom.h $(Cs)rulepsr.h $(Cs)ruledlt.h $(Cs)bload.h $(Cs)exprnbin.h \
 $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)rulebin.h $(Cs)modulbin.h $(Cs)cstrcbin.h $(Cs)rulecmp.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)ruledef.o $(Cs)ruledef.c

$(Ck)ruledlt.o: $(Cs)ruledlt.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h $(Cs)engine.h \
 $(Cs)lgcldpnd.h $(Cs)match.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h \
 $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)network.h $(Cs)ruledef.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)symblcmp.h \
 $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)retract.h $(Cs)reteutil.h \
 $(Cs)drive.h $(Cs)bload.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)ruledlt.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)ruledlt.o $(Cs)ruledlt.c

$(Ck)rulelhs.o: $(Cs)rulelhs.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)agenda.h $(Cs)ruledef.h \
 $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)symbol.h $(Cs)evaluatn.h \
 $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)network.h \
 $(Cs)match.h $(Cs)pattern.h $(Cs)reorder.h $(Cs)argacces.h $(Cs)cstrnchk.h $(Cs)memalloc.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)rulelhs.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)rulelhs.o $(Cs)rulelhs.c

$(Ck)rulepsr.o: $(Cs)rulepsr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)analysis.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)reorder.h $(Cs)ruledef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)constrnt.h $(Cs)cstrccom.h \
 $(Cs)agenda.h $(Cs)match.h $(Cs)network.h $(Cs)pattern.h $(Cs)cstrcpsr.h $(Cs)cstrnchk.h $(Cs)cstrnops.h \
 $(Cs)engine.h $(Cs)lgcldpnd.h $(Cs)retract.h $(Cs)incrrset.h $(Cs)memalloc.h $(Cs)prccode.h \
 $(Cs)prcdrpsr.h $(Cs)router.h $(Cs)prntutil.h $(Cs)rulebld.h $(Cs)rulebsc.h $(Cs)rulecstr.h $(Cs)ruledlt.h \
 $(Cs)rulelhs.h $(Cs)watch.h $(Cs)tmpltfun.h $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)multifld.h $(Cs)tmpltdef.h \
 $(Cs)factbld.h $(Cs)bload.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)rulepsr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)rulepsr.o $(Cs)rulepsr.c

$(Ck)scanner.o: $(Cs)scanner.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)evaluatn.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)scanner.h \
 $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)memalloc.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)scanner.o $(Cs)scanner.c

$(Ck)sortfun.o: $(Cs)sortfun.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)utility.h $(Cs)dffnxfun.h $(Cs)cstrccom.h $(Cs)memalloc.h $(Cs)multifld.h \
 $(Cs)sysdep.h $(Cs)sortfun.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)sortfun.o $(Cs)sortfun.c

$(Ck)strngfun.o: $(Cs)strngfun.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)cstrcpsr.h $(Cs)engine.h \
 $(Cs)lgcldpnd.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h \
 $(Cs)pattern.h $(Cs)reorder.h $(Cs)retract.h $(Cs)memalloc.h $(Cs)prcdrpsr.h $(Cs)router.h $(Cs)prntutil.h \
 $(Cs)strngrtr.h $(Cs)drive.h $(Cs)strngfun.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)strngfun.o $(Cs)strngfun.c

$(Ck)strngrtr.o: $(Cs)strngrtr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h \
 $(Cs)memalloc.h $(Cs)router.h $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h \
 $(Cs)symbol.h $(Cs)userdata.h $(Cs)evaluatn.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h \
 $(Cs)extnfunc.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h \
 $(Cs)strngrtr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)strngrtr.o $(Cs)strngrtr.c

$(Ck)symblbin.o: $(Cs)symblbin.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)bload.h $(Cs)exprnbin.h $(Cs)sysdep.h \
 $(Cs)symblbin.h $(Cs)bsave.h $(Cs)cstrnbin.h $(Cs)constrnt.h $(Cs)memalloc.h $(Cs)router.h $(Cs)prntutil.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)symblbin.o $(Cs)symblbin.c

$(Ck)symblcmp.o: $(Cs)symblcmp.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)symbol.h $(Cs)memalloc.h \
 $(Cs)constant.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)cstrccom.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h \
 $(Cs)evaluatn.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)argacces.h $(Cs)cstrncmp.h \
 $(Cs)constrnt.h $(Cs)router.h $(Cs)prntutil.h $(Cs)sysdep.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)symblcmp.o $(Cs)symblcmp.c

$(Ck)symbol.o: $(Cs)symbol.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h $(Cs)memalloc.h \
 $(Cs)router.h $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h \
 $(Cs)userdata.h $(Cs)evaluatn.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)argacces.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)symbol.o $(Cs)symbol.c

$(Ck)sysdep.o: $(Cs)sysdep.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)utility.h $(Cs)bmathfun.h $(Cs)commline.h $(Cs)constrnt.h $(Cs)cstrcpsr.h \
 $(Cs)emathfun.h $(Cs)filecom.h $(Cs)iofun.h $(Cs)memalloc.h $(Cs)miscfun.h $(Cs)multifld.h $(Cs)multifun.h \
 $(Cs)parsefun.h $(Cs)prccode.h $(Cs)prdctfun.h $(Cs)proflfun.h $(Cs)prcdrfun.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)sortfun.h $(Cs)strngfun.h $(Cs)textpro.h $(Cs)watch.h $(Cs)sysdep.h $(Cs)dffctdef.h \
 $(Cs)cstrccom.h $(Cs)ruledef.h $(Cs)agenda.h $(Cs)match.h $(Cs)network.h $(Cs)pattern.h $(Cs)reorder.h \
 $(Cs)genrccom.h $(Cs)genrcfun.h $(Cs)object.h $(Cs)dffnxfun.h $(Cs)globldef.h $(Cs)tmpltdef.h \
 $(Cs)factbld.h $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)classini.h $(Cs)ed.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)sysdep.o $(Cs)sysdep.c

$(Ck)textpro.o: $(Cs)textpro.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h $(Cs)scanner.h $(Cs)pprint.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symblcmp.h \
 $(Cs)modulpsr.h $(Cs)utility.h $(Cs)commline.h $(Cs)memalloc.h $(Cs)router.h $(Cs)prntutil.h $(Cs)sysdep.h \
 $(Cs)textpro.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)textpro.o $(Cs)textpro.c

$(Ck)tmpltbin.o: $(Cs)tmpltbin.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h $(Cs)bload.h \
 $(Cs)utility.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)userdata.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)bsave.h \
 $(Cs)factbin.h $(Cs)factbld.h $(Cs)pattern.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)match.h $(Cs)network.h \
 $(Cs)ruledef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)symblcmp.h \
 $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)reorder.h $(Cs)cstrnbin.h $(Cs)factmngr.h \
 $(Cs)facthsh.h $(Cs)multifld.h $(Cs)tmpltdef.h $(Cs)tmpltpsr.h $(Cs)tmpltutl.h $(Cs)tmpltbin.h \
 $(Cs)cstrcbin.h $(Cs)modulbin.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)tmpltbin.o $(Cs)tmpltbin.c

$(Ck)tmpltbsc.o: $(Cs)tmpltbsc.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)argacces.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)evaluatn.h $(Cs)constant.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)memalloc.h $(Cs)router.h \
 $(Cs)prntutil.h $(Cs)cstrccom.h $(Cs)factrhs.h $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)pattern.h $(Cs)match.h \
 $(Cs)network.h $(Cs)ruledef.h $(Cs)constrnt.h $(Cs)agenda.h $(Cs)reorder.h $(Cs)multifld.h $(Cs)tmpltdef.h \
 $(Cs)factbld.h $(Cs)cstrcpsr.h $(Cs)tmpltpsr.h $(Cs)tmpltbin.h $(Cs)cstrcbin.h $(Cs)modulbin.h \
 $(Cs)tmpltcmp.h $(Cs)tmpltutl.h $(Cs)tmpltbsc.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)tmpltbsc.o $(Cs)tmpltbsc.c

$(Ck)tmpltcmp.o: $(Cs)tmpltcmp.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)symbol.h $(Cs)evaluatn.h $(Cs)constant.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)userdata.h $(Cs)scanner.h \
 $(Cs)pprint.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)factcmp.h $(Cs)pattern.h $(Cs)match.h $(Cs)network.h \
 $(Cs)ruledef.h $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)reorder.h $(Cs)cstrncmp.h \
 $(Cs)tmpltdef.h $(Cs)factbld.h $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)multifld.h $(Cs)tmpltcmp.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)tmpltcmp.o $(Cs)tmpltcmp.c

$(Ck)tmpltdef.o: $(Cs)tmpltdef.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h \
 $(Cs)exprnops.h $(Cs)expressn.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)cstrccom.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)network.h $(Cs)match.h \
 $(Cs)pattern.h $(Cs)reorder.h $(Cs)ruledef.h $(Cs)constrnt.h $(Cs)agenda.h $(Cs)tmpltpsr.h $(Cs)tmpltdef.h \
 $(Cs)factbld.h $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)multifld.h $(Cs)tmpltbsc.h $(Cs)tmpltutl.h \
 $(Cs)tmpltfun.h $(Cs)router.h $(Cs)prntutil.h $(Cs)modulutl.h $(Cs)cstrnchk.h $(Cs)bload.h $(Cs)exprnbin.h \
 $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)tmpltbin.h $(Cs)cstrcbin.h $(Cs)modulbin.h $(Cs)tmpltcmp.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)tmpltdef.o $(Cs)tmpltdef.c

$(Ck)tmpltfun.o: $(Cs)tmpltfun.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h \
 $(Cs)memalloc.h $(Cs)symbol.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)userdata.h $(Cs)argacces.h $(Cs)evaluatn.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)router.h $(Cs)prntutil.h \
 $(Cs)cstrnchk.h $(Cs)constrnt.h $(Cs)default.h $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)pattern.h $(Cs)match.h \
 $(Cs)network.h $(Cs)ruledef.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)reorder.h $(Cs)multifld.h $(Cs)tmpltdef.h \
 $(Cs)factbld.h $(Cs)commline.h $(Cs)factrhs.h $(Cs)modulutl.h $(Cs)tmpltlhs.h $(Cs)tmpltutl.h \
 $(Cs)tmpltrhs.h $(Cs)tmpltfun.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)tmpltfun.o $(Cs)tmpltfun.c

$(Ck)tmpltlhs.o: $(Cs)tmpltlhs.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h \
 $(Cs)memalloc.h $(Cs)symbol.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)userdata.h $(Cs)router.h $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)evaluatn.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)constrnt.h \
 $(Cs)reorder.h $(Cs)ruledef.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)match.h $(Cs)network.h $(Cs)pattern.h \
 $(Cs)factrhs.h $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)multifld.h $(Cs)tmpltdef.h $(Cs)factbld.h \
 $(Cs)modulutl.h $(Cs)tmpltutl.h $(Cs)tmpltlhs.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)tmpltlhs.o $(Cs)tmpltlhs.c

$(Ck)tmpltpsr.o: $(Cs)tmpltpsr.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h \
 $(Cs)memalloc.h $(Cs)symbol.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)expressn.h \
 $(Cs)exprnops.h $(Cs)userdata.h $(Cs)router.h $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h \
 $(Cs)constrct.h $(Cs)evaluatn.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)factmngr.h \
 $(Cs)facthsh.h $(Cs)pattern.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)constrnt.h $(Cs)cstrccom.h \
 $(Cs)agenda.h $(Cs)reorder.h $(Cs)multifld.h $(Cs)tmpltdef.h $(Cs)factbld.h $(Cs)cstrnchk.h \
 $(Cs)cstrnpsr.h $(Cs)cstrcpsr.h $(Cs)bload.h $(Cs)exprnbin.h $(Cs)sysdep.h $(Cs)symblbin.h $(Cs)default.h \
 $(Cs)watch.h $(Cs)cstrnutl.h $(Cs)tmpltbsc.h $(Cs)tmpltpsr.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)tmpltpsr.o $(Cs)tmpltpsr.c

$(Ck)tmpltrhs.o: $(Cs)tmpltrhs.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)memalloc.h \
 $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h $(Cs)userdata.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)router.h $(Cs)tmpltfun.h \
 $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)pattern.h $(Cs)match.h $(Cs)network.h $(Cs)ruledef.h $(Cs)constrnt.h \
 $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)reorder.h $(Cs)multifld.h $(Cs)tmpltdef.h $(Cs)factbld.h $(Cs)factrhs.h \
 $(Cs)modulutl.h $(Cs)default.h $(Cs)tmpltutl.h $(Cs)tmpltlhs.h $(Cs)tmpltrhs.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)tmpltrhs.o $(Cs)tmpltrhs.c

$(Ck)tmpltutl.o: $(Cs)tmpltutl.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)extnfunc.h $(Cs)symbol.h \
 $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)userdata.h \
 $(Cs)memalloc.h $(Cs)constrct.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)symblcmp.h $(Cs)modulpsr.h \
 $(Cs)evaluatn.h $(Cs)constant.h $(Cs)utility.h $(Cs)router.h $(Cs)prntutil.h $(Cs)argacces.h \
 $(Cs)cstrnchk.h $(Cs)constrnt.h $(Cs)tmpltfun.h $(Cs)factmngr.h $(Cs)facthsh.h $(Cs)pattern.h $(Cs)match.h \
 $(Cs)network.h $(Cs)ruledef.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)reorder.h $(Cs)multifld.h $(Cs)tmpltdef.h \
 $(Cs)factbld.h $(Cs)tmpltpsr.h $(Cs)modulutl.h $(Cs)watch.h $(Cs)tmpltbsc.h $(Cs)tmpltutl.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)tmpltutl.o $(Cs)tmpltutl.c

$(Ck)userdata.o: $(Cs)userdata.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)userdata.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)userdata.o $(Cs)userdata.c

$(Ck)userfunctions.o: $(Cs)userfunctions.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)extnfunc.h \
 $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)scanner.h $(Cs)pprint.h $(Cs)userdata.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)userfunctions.o $(Cs)userfunctions.c

$(Ck)utility.o: $(Cs)utility.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)evaluatn.h $(Cs)constant.h \
 $(Cs)symbol.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h $(Cs)userdata.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)facthsh.h $(Cs)factmngr.h $(Cs)conscomp.h $(Cs)constrct.h \
 $(Cs)moduldef.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)symblcmp.h $(Cs)pattern.h $(Cs)match.h $(Cs)network.h \
 $(Cs)ruledef.h $(Cs)constrnt.h $(Cs)cstrccom.h $(Cs)agenda.h $(Cs)reorder.h $(Cs)multifld.h \
 $(Cs)tmpltdef.h $(Cs)factbld.h $(Cs)memalloc.h $(Cs)prntutil.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)utility.o $(Cs)utility.c

$(Ck)watch.o: $(Cs)watch.c $(Cs)setup.h $(Cs)envrnmnt.h $(Cs)usrsetup.h $(Cs)constant.h $(Cs)memalloc.h \
 $(Cs)router.h $(Cs)prntutil.h $(Cs)moduldef.h $(Cs)conscomp.h $(Cs)constrct.h $(Cs)symbol.h \
 $(Cs)userdata.h $(Cs)evaluatn.h $(Cs)expressn.h $(Cs)exprnops.h $(Cs)exprnpsr.h $(Cs)extnfunc.h \
 $(Cs)scanner.h $(Cs)pprint.h $(Cs)symblcmp.h $(Cs)modulpsr.h $(Cs)utility.h $(Cs)argacces.h $(Cs)watch.h
	$(Cc) $(CLFLAGS) -c -o $(Ck)watch.o $(Cs)watch.c

bin/libdaclips.so: $(CLIPSOBJS)
	$(CC) $(CLIBFLAGS) $(CLIPSOBJS) -o bin/libdaclips.so  
	cp bin/libdaclips.so /usr/local/lib

bin/libmddevice.so: src/client/md_device.cpp src/include/md_device.h src/include/dvLogger.h src/client/dvLogger.cpp src/client/deviceDaemon.cpp src/client/deviceDaemonConfig.cpp \
	src/include/deviceDaemon.h src/include/deviceDaemonConfig.h 
	$(CC) $(DVCFLAGS)  src/client/md_device.cpp src/client/dvLogger.cpp src/client/deviceDaemon.cpp src/client/deviceDaemonConfig.cpp \
	src/server/mdState.cpp  src/server/mdObservable.cpp -o bin/libmddevice.so $(DVINCL) $(DVLIBS) 
	cp bin/libmddevice.so /usr/local/lib

bin/daclips-md: bin/md $(CLIPSMMOBJS)
	$(CC) $(CFLAGS) -DMD_MAND -o bin/daclips-md $(SINCL) $(CLIPSMMINCL) $(LIBS) src/server/auc-md.cpp obj/server/mdObservable.o obj/server/lxi-control.o src/server/mdLogger.cpp  \
	src/server/mdDevice.cpp src/server/mdBehavior.cpp obj/server/mdState.o src/server/masterDaemon.cpp src/server/masterDaemonConfig.cpp $(SLIBS) $(CLIBS) $(KBLIBS)

bin/daclips-cd: bin/md-cd $(CLIPSMMOBJS)
	$(CC) $(CFLAGS) -DMD_MAND $(CINCL) $(CLIPSMMINCL) $(CLIPSMMFLAGS)  src/client/auc-cd.cpp src/client/cdLogger.cpp \
	 src/client/clientDaemon.cpp src/client/clientDaemonConfig.cpp src/client/commander.cpp \
	 -o bin/daclips-cd $(SLIBS) $(CLIBS) $(KBLIBS)

bin/dvdriver: src/client/dvdriver.cpp 
	$(CC) $(CFLAGS) src/client/dvdriver.cpp -o bin/dvdriver $(DVINCL) $(DVLIBS) -l mddevice

doxygen/html/index.html: misc/doxygen.config
	doxygen misc/doxygen.config 

# --- rebuild on copy to a new host
distclean:
	clrbak
	find ./obj -name "*.o" -print | perl -ne "print;chop;unlink"
	rm bin/*
	rm doxygen/*
	touch misc/doxygen.config

cleanclient:
	rm src/client/mdClient*
	rm src/include/mdClient*
	rm obj/client/*

clean:
	clrbak
	find ./obj -name "*.o"   -print | perl -ne "print;chop;unlink"
	find ./obj -name "*.rpo" -print | perl -ne "print;chop;unlink"
	rm bin/*




