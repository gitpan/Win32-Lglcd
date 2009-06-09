MODULE = Win32::Lglcd PACKAGE = DeviceDescExPtr

void
DESTROY(var)
		DeviceDescEx* var;
	CODE:		
		free( var );
		
DWORD Width(var)
		DeviceDescEx* var;
	CODE:
		RETVAL = var->Width;
	OUTPUT:
		RETVAL

DWORD Height(var)
		DeviceDescEx* var;
	CODE:
		RETVAL = var->Height;
	OUTPUT:
		RETVAL

DWORD Bpp(var)
		DeviceDescEx* var;
	CODE:
		RETVAL = var->Bpp;
	OUTPUT:
		RETVAL

DWORD NumSoftButtons(var)
		DeviceDescEx* var;
	CODE:
		RETVAL = var->NumSoftButtons;
	OUTPUT:
		RETVAL

DWORD deviceFamilyId(var)
		DeviceDescEx* var;
	CODE:
		RETVAL = var->deviceFamilyId;
	OUTPUT:
		RETVAL

LPCTSTR deviceDisplayName(var)
		DeviceDescEx* var;
	CODE:
		RETVAL = var->deviceDisplayName;
	OUTPUT:
		RETVAL

DWORD Reserved1(var)
		DeviceDescEx* var;
	CODE:
		RETVAL = var->Reserved1;
	OUTPUT:
		RETVAL

DWORD Reserved2(var)
		DeviceDescEx* var;
	CODE:
		RETVAL = var->Reserved2;
	OUTPUT:
		RETVAL
