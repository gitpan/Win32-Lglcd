MODULE = Win32::Lglcd PACKAGE = OpenContextPtr

void
DESTROY(var)
		OpenContext* var;
	CODE:		
		free( var );

SoftbuttonsChangedContext*
onSoftbuttonsChanged(var)
    OpenContext* var;
  CODE:
    RETVAL = (SoftbuttonsChangedContext*)&var->onSoftbuttonsChanged;
  OUTPUT:
    RETVAL

int
device(var)
    OpenContext* var;
  CODE:
    RETVAL = var->device;
  OUTPUT:
    RETVAL
 
int
index(var)
    OpenContext* var;
  CODE:
    RETVAL = var->index;
  OUTPUT:
    RETVAL
 
int
connection(var)
    OpenContext* var;
  CODE:
    RETVAL = var->connection;
  OUTPUT:
    RETVAL
 
 