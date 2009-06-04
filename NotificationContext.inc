MODULE = Win32::Lglcd PACKAGE = NotificationContextPtr

void
DESTROY(var)
		NotificationContext* var;
	CODE:		
		free( var );

SV*
notificationCallback(var)
		NotificationContext* var;
	CODE:		
		RETVAL = var->notificationCallback;
  OUTPUT:
    RETVAL
    
PVOID
notifyContext(var)
		NotificationContext* var;
	CODE:		
		RETVAL = var->notifyContext;
  OUTPUT:
    RETVAL
    
