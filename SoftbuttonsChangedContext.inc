MODULE = Win32::Lglcd PACKAGE = SoftbuttonsChangedContextPtr

void
DESTROY(var)
		SoftbuttonsChangedContext* var;
	CODE:		
		free( var );

SV*
softbuttonsChangedCallback(var)
		SoftbuttonsChangedContext* var;
	CODE:		
		RETVAL = var->softbuttonsChangedCallback;
  OUTPUT:
    RETVAL
    
PVOID
softbuttonsChangedContext(var)
		SoftbuttonsChangedContext* var;
	CODE:		
		RETVAL = var->softbuttonsChangedContext;
  OUTPUT:
    RETVAL
    
