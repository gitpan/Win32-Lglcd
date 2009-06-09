MODULE = Win32::Lglcd PACKAGE = ConfigureContextPtr

void
DESTROY(var)
		ConfigureContext* var;
	CODE:		
		free( var );

SV*
configCallback(var)
		ConfigureContext* var;
	CODE:		
		RETVAL = var->configCallback;
  OUTPUT:
    RETVAL
    
PVOID
configContext(var)
		ConfigureContext* var;
	CODE:		
		RETVAL = var->configContext;
  OUTPUT:
    RETVAL
    
