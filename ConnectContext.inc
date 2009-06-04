MODULE = Win32::Lglcd PACKAGE = ConnectContextPtr

void
DESTROY(var)
		ConnectContext* var;
	CODE:		
		free( var );

LPCTSTR
appFriendlyName(var)
    ConnectContext* var;
  CODE:
    RETVAL = var->appFriendlyName;
  OUTPUT:
    RETVAL
    
BOOL
isPersistent(var)
    ConnectContext* var;
  CODE:
    RETVAL = var->isPersistent;
  OUTPUT:
    RETVAL
 
BOOL
isAutostartable(var)
    ConnectContext* var;
  CODE:
    RETVAL = var->isAutostartable;
  OUTPUT:
    RETVAL
 
ConfigureContext*
onConfigure(var)
    ConnectContext* var;
  CODE:
    RETVAL = (ConfigureContext*)&var->onConfigure;
  OUTPUT:
    RETVAL
 
int
connection(var)
    ConnectContext* var;
  CODE:
    RETVAL = var->connection;
  OUTPUT:
    RETVAL
 
 