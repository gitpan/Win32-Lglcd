MODULE = Win32::Lglcd PACKAGE = DeviceDescPtr

void
DESTROY(var)
		DeviceDesc* var;
	CODE:		
		free( var );
		
DWORD Width(var)
		DeviceDesc* var;
	CODE:
		RETVAL = var->Width;
	OUTPUT:
		RETVAL

DWORD Height(var)
		DeviceDesc* var;
	CODE:
		RETVAL = var->Height;
	OUTPUT:
		RETVAL

DWORD Bpp(var)
		DeviceDesc* var;
	CODE:
		RETVAL = var->Bpp;
	OUTPUT:
		RETVAL

DWORD NumSoftButtons(var)
		DeviceDesc* var;
	CODE:
		RETVAL = var->NumSoftButtons;
	OUTPUT:
		RETVAL
