MODULE = Win32::Lglcd PACKAGE = CallbackWrapperPtr

void
DESTROY(var)
		CallbackWrapper* var;
	CODE:		
		printf("DESTROYING a callbackwrapper\n");
    SvREFCNT_dec( var->callbackSub );
    SvREFCNT_dec( var->callbackSub );
		free( var );
