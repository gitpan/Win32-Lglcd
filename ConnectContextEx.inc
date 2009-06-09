MODULE = Win32::Lglcd PACKAGE = ConnectContextExPtr

void
DESTROY(var)
		ConnectContextEx* var;
	CODE:		
		free( var );

LPCTSTR
appFriendlyName(var)
    ConnectContextEx* var;
  CODE:
    RETVAL = var->appFriendlyName;
  OUTPUT:
    RETVAL
    
BOOL
isPersistent(var)
    ConnectContextEx* var;
  CODE:
    RETVAL = var->isPersistent;
  OUTPUT:
    RETVAL
 
BOOL
isAutostartable(var)
    ConnectContextEx* var;
  CODE:
    RETVAL = var->isAutostartable;
  OUTPUT:
    RETVAL
 
ConfigureContext*
onConfigure(var)
    ConnectContextEx* var;
  CODE:
    RETVAL = (ConfigureContext*)&var->onConfigure;
  OUTPUT:
    RETVAL
 
int
connection(var)
    ConnectContextEx* var;
  CODE:
    RETVAL = var->connection;
  OUTPUT:
    RETVAL
 
DWORD
dwAppletCapabilitiesSupported(var)
    ConnectContextEx* var;
  CODE:
    RETVAL = var->dwAppletCapabilitiesSupported;
  OUTPUT:
    RETVAL
 
 
DWORD
dwReserved1(var)
    ConnectContextEx* var;
  CODE:
    RETVAL = var->dwReserved1;
  OUTPUT:
    RETVAL

 
NotificationContext*
onNotify(var)
    ConnectContextEx* var;
  CODE:
    RETVAL = (NotificationContext*)&var->onNotify;
  OUTPUT:
    RETVAL
