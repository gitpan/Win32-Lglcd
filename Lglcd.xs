//#define PERL_NO_GET_CONTEXT     /* we want efficiency */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#include <Lglcd\lglcd.h>
#include "const-c.inc"
#include "struct-xs.inc"

#include "windows.h"

static CRITICAL_SECTION gs_Perl_CS;
int use_criticalsection = 1;

typedef struct{
	SV *callbackSub;
	PVOID callbackContext;
	PVOID myperl;
} CallbackWrapper;

STATIC DWORD CALLBACK defaultConfigCallback(connection,pContext)
int connection;
const PVOID pContext;
{
    DWORD ret=0;
	CallbackWrapper *env_ptr = (CallbackWrapper*)pContext;
    if (use_criticalsection) EnterCriticalSection(&gs_Perl_CS);
	PERL_SET_CONTEXT(env_ptr->myperl);
	printf("** defaultConfigCallback is called with %08X**\n", pContext);
	if (env_ptr && env_ptr->callbackSub){
		dSP;
		
		ENTER;
		SAVETMPS;
		PUSHMARK(SP);
		XPUSHs(sv_2mortal(newSViv(connection)));
		XPUSHs(sv_2mortal(newSViv(env_ptr->callbackContext)));
		PUTBACK;
		ret = perl_call_sv(env_ptr->callbackSub, G_SCALAR);
		SPAGAIN;
	//#	//if(SvTRUE(ERRSV)) {
	//#	//	POPs;
	//#	//	retval = 1;
	//#	//	} else {
	//#	//	retval = POPi;
	//#	//}
		FREETMPS;
		LEAVE;
	}
    if (use_criticalsection) LeaveCriticalSection(&gs_Perl_CS);
	return ret;
}

STATIC DWORD CALLBACK defaultNotificationCallback(connection,pContext,notificationCode,notifyParm1,notifyParm2,notifyParm3,notifyParm4)
int connection;
const PVOID pContext;
DWORD notificationCode;
DWORD notifyParm1;
DWORD notifyParm2;
DWORD notifyParm3;
DWORD notifyParm4;
{	
    DWORD ret=0;
	CallbackWrapper *env_ptr = (CallbackWrapper*)pContext;
    if (use_criticalsection) EnterCriticalSection(&gs_Perl_CS);
	PERL_SET_CONTEXT(env_ptr->myperl);
	printf("** defaultNotificationCallback is called with %08X**\n", pContext);
	if (env_ptr && env_ptr->callbackSub){
		dSP;

		ENTER;
		SAVETMPS;
		PUSHMARK(SP);
		XPUSHs(sv_2mortal(newSViv(connection)));
		XPUSHs(sv_2mortal(newSViv(notificationCode)));
		XPUSHs(sv_2mortal(newSViv(notifyParm1)));
		XPUSHs(sv_2mortal(newSViv(notifyParm2)));
		XPUSHs(sv_2mortal(newSViv(notifyParm3)));
		XPUSHs(sv_2mortal(newSViv(notifyParm4)));
		XPUSHs(sv_2mortal(newSViv(env_ptr->callbackContext)));
		PUTBACK;
		printf("**->going into PERL\n");
		ret = perl_call_sv(env_ptr->callbackSub, G_SCALAR|G_EVAL);
		printf("**->returned from PERL\n");
		SPAGAIN;
		printf("**->SPAGAIN\n");
		POPi;
		printf("**->POPi\n");
		PUTBACK;
		printf("**->PUTBACK\n");
	//#	//if(SvTRUE(ERRSV)) {
	//#	//	POPs;
	//#	//	retval = 1;
	//#	//	} else {
	//#	//	retval = POPi;
	//#	//}
		FREETMPS;
		printf("**->FREETMPS\n");
		LEAVE;
		printf("**->LEAVE\n");
	}
    if (use_criticalsection) LeaveCriticalSection(&gs_Perl_CS);
	return ret;
}

STATIC DWORD CALLBACK defaultSoftbuttonsChangedCallback(device,dwButtons,pContext)
int device;
DWORD dwButtons;
const PVOID pContext;
{
	PerlInterpreter *me;
	CallbackWrapper *env_ptr = (CallbackWrapper*)pContext;
	DWORD ret=0;
	//~ printf("** EnterCriticalSection..." );
	if (use_criticalsection) EnterCriticalSection(&gs_Perl_CS);
	//~ printf("ok\n");
	//~ printf("** TryEnterCriticalSection..." );
	//~ if(!TryEnterCriticalSection(&gs_Perl_CS)){
		//~ printf("FALSE !!!\n");
		//~ return ret;
	//~ }
	//~ printf("TRUE;\twith myperl=%08X\t", env_ptr->myperl);
	
	//~ PERL_SET_CONTEXT(env_ptr->myperl);
	PERL_SET_CONTEXT(env_ptr->myperl);
	//~ Perl_atfork_lock();
	//~ Perl_reentrant_init(env_ptr->myperl);
	//CLONEf_KEEP_PTR_TABLE  | CLONEf_COPY_STACKS | CLONEf_CLONE_HOST
	//~ me = perl_clone(env_ptr->myperl, /*CLONEf_KEEP_PTR_TABLE | */0);
	//~ printf("cloned=%08X\t", me);
	//~ PERL_SET_CONTEXT(me);
	
	//#	//printf("** defaultSoftbuttonsChangedCallback is called with %08X**\n", pContext);
	SvREFCNT_inc(env_ptr->callbackSub);
	if (env_ptr && env_ptr->callbackSub){
		dSP;
		ENTER;
		SAVETMPS;
		PUSHMARK(SP);
		XPUSHs(sv_2mortal(newSViv(device)));
		XPUSHs(sv_2mortal(newSViv(dwButtons)));
		XPUSHs(sv_2mortal(newSViv(env_ptr->callbackContext)));
		PUTBACK;
		//~ printf("**->going into PERL\n");
		ret = perl_call_sv(env_ptr->callbackSub, G_SCALAR);
		//~ printf("**->returned from PERL\n");
		SPAGAIN;		
		//~ printf("**->SPAGAIN done\n");

		if(SvTRUE(ERRSV)){
			ret = 0;
			//~ printf("**->no POPi to do\n");
		} 
		else {
			if(ret>0){
				ret = POPi;
				//~ printf("**->POPi done\n");
			}			
		}
		PUTBACK;		
		//~ printf("**->PUTBACK done\n");		
		FREETMPS;
		//~ printf("**->FREETMPS done\n");
		LEAVE;
		//~ printf("**->LEAVE done\n");		
	}
	SvREFCNT_dec(env_ptr->callbackSub);	
	//~ Perl_atfork_unlock();
	//~ Perl_reentrant_free(env_ptr->myperl);
	//~ //env_ptr->myperl = PERL_GET_INTERP;
	//~ if(me && me!=env_ptr->myperl){
		//~ printf("**->Releasing cloned Interpreter");
		//~ perl_destruct( me );
		//~ perl_free( me );
		//~ printf("... Cloned Interpreter is now free\n");
	//~ }
	
	//~ printf("**->Before LeaveCriticalSection\n");
	if (use_criticalsection) LeaveCriticalSection(&gs_Perl_CS);
	//~ printf("** LeaveCriticalSection\n" );
	return ret;
}

void useCriticalSection(){
    use_criticalsection = 1;
    EnterCriticalSection(&gs_Perl_CS);
}

void DoNotUseCriticalSection(){
    use_criticalsection = 0;
    LeaveCriticalSection(&gs_Perl_CS);
}

int last_error = 0;
//------------x--------------x----------------x-----------------x-------------------x
MODULE = Lglcd		PACKAGE = Win32::Lglcd
INCLUDE: const-xs.inc

void
g15_do_event()
	CODE:
		//~ printf("** g15_do_event::LeaveCriticalSection\n");
		LeaveCriticalSection(&gs_Perl_CS);
		//~ printf("** g15_do_event::EnterCriticalSection...waiting...\n");
		EnterCriticalSection(&gs_Perl_CS);
		//~ printf("** g15_do_event::EnterCriticalSection...OK\n");

int
g15_get_last_error()
	CODE:
		RETVAL = last_error;
	OUTPUT:
		RETVAL

LPCTSTR
g15_get_error_message(error)
	int error;
	CODE:
		switch(error){
			case 0:		RETVAL = "ERROR_SUCCESS";	break;
			case 5:		RETVAL = "ERROR_ACCESS_DENIED";	break;
			case 1062:	RETVAL = "ERROR_SERVICE_NOT_ACTIVE"; break;
			case 1450L:		RETVAL = "ERROR_NO_SYSTEM_RESOURCES";	break;
			//#TODO: complete other error message from "C:\Program Files\Microsoft Visual Studio\VC98\Include\WINERROR.H"
			default:	RETVAL = "Unknow error";	break;
		}
	OUTPUT:
		RETVAL

int
g15_init()
	CODE:
		RETVAL = last_error = lgLcdInit();
		printf("** InitializeCriticalSection\n" );
		InitializeCriticalSection(&gs_Perl_CS);
		EnterCriticalSection(&gs_Perl_CS);
	OUTPUT:	
		RETVAL

void
g15_deinit()
	CODE:
		lgLcdDeInit();
		printf("** DeleteCriticalSection\n" );
		DeleteCriticalSection(&gs_Perl_CS);

CallbackWrapper*
g15_create_callback_wrapper(paramCallback=NULL,paramContext=NULL)
	SV* paramCallback;
	PVOID paramContext;
	CODE:
		if(paramCallback==NULL){
			RETVAL=NULL;
		}
		else{
			printf("**ALLOCATING a callbackWrapper\n");
			RETVAL = (CallbackWrapper*)malloc(sizeof(CallbackWrapper));
			RETVAL->callbackSub = newSVsv(paramCallback);
			SvREFCNT_inc( RETVAL->callbackSub );
			SvREFCNT_inc( RETVAL->callbackSub );
			RETVAL->callbackContext = paramContext;
			RETVAL->myperl = PERL_GET_INTERP;	//#//aTHX;	#~//May I should use a Clone method on the interpreter...
		}
	OUTPUT:
		RETVAL

ConnectContext*
g15_connect(appname,isAutostartable=FALSE,isPersistent=FALSE,configCallback=NULL,connection=LGLCD_INVALID_CONNECTION)
	char* appname;
	BOOL isAutostartable;
	BOOL isPersistent;
	CallbackWrapper* configCallback;
	int connection;
	CODE:
				//# //TODO: free this struct !!! maybe on disconnect !!! <-----------------------
		RETVAL = (ConnectContext*)malloc(sizeof(ConnectContext));
		ZeroMemory(RETVAL, sizeof(ConnectContext));
		RETVAL->appFriendlyName = appname;
		RETVAL->isAutostartable = isAutostartable;
		RETVAL->isPersistent = isPersistent;
		RETVAL->onConfigure.configCallback = (lgLcdOnConfigureCB*)defaultConfigCallback;
		RETVAL->onConfigure.configContext = (PVOID)configCallback;
		RETVAL->connection = connection;
		last_error = lgLcdConnect(RETVAL);
		if(last_error){
			free(RETVAL );
		}
	OUTPUT:
		RETVAL

ConnectContextEx*
g15_connect_ex(appname,isAutostartable=FALSE,isPersistent=FALSE,configCallback=NULL,notificationCallback=NULL,connection=LGLCD_INVALID_CONNECTION)
	char* appname;
	BOOL isAutostartable;
	BOOL isPersistent;
	CallbackWrapper* configCallback;
	CallbackWrapper* notificationCallback;
	int connection;
	CODE:
				//# //TODO: free this struct !!! maybe on disconnect !!! <-----------------------
		RETVAL = (ConnectContextEx*)malloc(sizeof(ConnectContextEx));
		ZeroMemory(RETVAL, sizeof(ConnectContextEx));
		RETVAL->appFriendlyName = appname;
		RETVAL->isAutostartable = isAutostartable;
		RETVAL->isPersistent = isPersistent;
		RETVAL->onConfigure.configCallback = (lgLcdOnConfigureCB*)defaultConfigCallback;
		RETVAL->onConfigure.configContext = (PVOID)configCallback;
		RETVAL->dwAppletCapabilitiesSupported = 8;
		RETVAL->onNotify.notificationCallback = (lgLcdOnNotificationCB*)defaultNotificationCallback;
		RETVAL->onNotify.notifyContext = (PVOID)notificationCallback;
		RETVAL->connection = connection;
		last_error = lgLcdConnectEx(RETVAL);
		if(last_error){
			free(RETVAL );
		}
	OUTPUT:
		RETVAL

DeviceDesc*
g15_enumerate(connection,index)
		int connection;
		int index;
	CODE:
		RETVAL = (DeviceDesc*)malloc(sizeof(DeviceDesc));
		last_error = lgLcdEnumerate(connection, index, RETVAL);
		if(last_error){
			free(RETVAL);
			RETVAL = NULL;
		}
	OUTPUT:
		RETVAL

DeviceDescEx*
g15_enumerate_ex(connection,index)
		int connection;
		int index;
	CODE:
		RETVAL = (DeviceDescEx*)malloc(sizeof(DeviceDescEx));
		last_error = lgLcdEnumerateEx(connection, index, RETVAL);
		if(last_error){
			free(RETVAL);
			RETVAL = NULL;
		}
	OUTPUT:
		RETVAL
		

OpenContext*
g15_open(connection,index=0,device=LGLCD_INVALID_DEVICE,softbuttonsChangedCallback=NULL)
		int connection;
		int index;
		int device;
		CallbackWrapper* softbuttonsChangedCallback;
	CODE:
		RETVAL = (OpenContext*)malloc(sizeof(OpenContext));
		ZeroMemory(RETVAL, sizeof(OpenContext));
		RETVAL->connection = connection;
		RETVAL->index = index;
		RETVAL->device = device;
		RETVAL->onSoftbuttonsChanged.softbuttonsChangedCallback = (lgLcdOnNotificationCB)defaultSoftbuttonsChangedCallback;
		RETVAL->onSoftbuttonsChanged.softbuttonsChangedContext = (PVOID)softbuttonsChangedCallback;
		last_error = lgLcdOpen(RETVAL);
		if(last_error){
			free(RETVAL);
			RETVAL=NULL;
		}
	OUTPUT:
		RETVAL
		
int 
g15_close(device)
		int device;
	CODE:
		last_error = lgLcdClose(device);
		RETVAL = last_error;
	OUTPUT:
		RETVAL

int 
g15_disconnect(connection)
		int connection;
	CODE:
		last_error = lgLcdDisconnect(connection);
		RETVAL = last_error;
	OUTPUT:
		RETVAL
	
int
g15_setforeground(device, foreground)
		int device;
		BOOL foreground;
	CODE:
		last_error = lgLcdSetAsLCDForegroundApp(device, foreground);
		RETVAL = last_error;
	OUTPUT:
		RETVAL

int
g15_sendbmp(device,bmp)
	int device;
	char*  bmp;
	CODE:
		DWORD priority = LGLCD_PRIORITY_NORMAL;
		lgLcdBitmap160x43x1     lcdBitmap;
		priority = LGLCD_SYNC_COMPLETE_WITHIN_FRAME(priority);
		lcdBitmap.hdr.Format = LGLCD_BMP_FORMAT_160x43x1;
		memcpy(&lcdBitmap.pixels, bmp, sizeof(lcdBitmap.pixels));
		last_error = lgLcdUpdateBitmap(device, &lcdBitmap.hdr, priority);
		RETVAL = last_error;
	OUTPUT:
		RETVAL

int
g15_setDeviceFamiliesToUse(connection, dwDeviceFamiliesSupported, dwReserved1)
		int connection;
		DWORD dwDeviceFamiliesSupported;
		DWORD dwReserved1;
	CODE:
		last_error = lgLcdSetDeviceFamiliesToUse(connection, dwDeviceFamiliesSupported, dwReserved1);
		RETVAL = last_error;
	OUTPUT:
		RETVAL

DWORD
g15_softbuttons_state(device)
	int device;
	CODE:
		RETVAL = 0;
		last_error = lgLcdReadSoftButtons( device, &RETVAL);
		if(last_error){
			RETVAL = -1;
		}
	OUTPUT:
		RETVAL

# --------------------- Include structures
INCLUDE: CallbackWrapper.inc
INCLUDE: DeviceDesc.inc
INCLUDE: DeviceDescEx.inc
INCLUDE: ConfigureContext.inc
INCLUDE: NotificationContext.inc
INCLUDE: SoftbuttonsChangedContext.inc
INCLUDE: ConnectContext.inc
INCLUDE: ConnectContextEx.inc
INCLUDE: OpenContext.inc