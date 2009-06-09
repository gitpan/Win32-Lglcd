package Win32::Lglcd;

use 5.008008;
use strict;
use warnings;
use Carp;

require Exporter;
use AutoLoader;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Win32::Lglcd ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	LGLCDBUTTON_BUTTON0
	LGLCDBUTTON_BUTTON1
	LGLCDBUTTON_BUTTON2
	LGLCDBUTTON_BUTTON3
	LGLCD_APPLET_CAP_BASIC
	LGLCD_APPLET_CAP_CAN_CLOSE_AND_REOPEN_DEVICE
	LGLCD_APPLET_CAP_CAN_CLOSE_CONNECTION
	LGLCD_APPLET_CAP_CAN_CLOSE_DEVICE
	LGLCD_APPLET_CAP_CAN_RUN_ON_MULTIPLE_DEVICES
	LGLCD_BMP_FORMAT_160x43x1
	LGLCD_BMP_HEIGHT
	LGLCD_BMP_WIDTH
	LGLCD_DEVICE_FAMILY_JACKBOX
	LGLCD_DEVICE_FAMILY_KEYBOARD_G15
	LGLCD_DEVICE_FAMILY_LCDEMULATOR_G15
	LGLCD_DEVICE_FAMILY_OTHER
	LGLCD_DEVICE_FAMILY_RAINBOW
	LGLCD_DEVICE_FAMILY_SPEAKERS_Z10
	LGLCD_INVALID_CONNECTION
	LGLCD_INVALID_DEVICE
	LGLCD_LCD_FOREGROUND_APP_NO
	LGLCD_LCD_FOREGROUND_APP_YES
	LGLCD_NOTIFICATION_CLOSE_AND_REOPEN_DEVICE
	LGLCD_NOTIFICATION_CLOSE_CONNECTION
	LGLCD_NOTIFICATION_CLOSE_DEVICE
	LGLCD_NOTIFICATION_DEVICE_ARRIVAL
	LGLCD_NOTIFICATION_DEVICE_REMOVAL
	LGLCD_NOTIFICATION_RUN_NEW_INSTANCE_ON_DEVICE
	LGLCD_PRIORITY_ALERT
	LGLCD_PRIORITY_BACKGROUND
	LGLCD_PRIORITY_IDLE_NO_SHOW
	LGLCD_PRIORITY_NORMAL
	lgLcdConnect
	lgLcdConnectEx
	lgLcdEnumerateEx
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	LGLCDBUTTON_BUTTON0
	LGLCDBUTTON_BUTTON1
	LGLCDBUTTON_BUTTON2
	LGLCDBUTTON_BUTTON3
	LGLCD_APPLET_CAP_BASIC
	LGLCD_APPLET_CAP_CAN_CLOSE_AND_REOPEN_DEVICE
	LGLCD_APPLET_CAP_CAN_CLOSE_CONNECTION
	LGLCD_APPLET_CAP_CAN_CLOSE_DEVICE
	LGLCD_APPLET_CAP_CAN_RUN_ON_MULTIPLE_DEVICES
	LGLCD_BMP_FORMAT_160x43x1
	LGLCD_BMP_HEIGHT
	LGLCD_BMP_WIDTH
	LGLCD_DEVICE_FAMILY_JACKBOX
	LGLCD_DEVICE_FAMILY_KEYBOARD_G15
	LGLCD_DEVICE_FAMILY_LCDEMULATOR_G15
	LGLCD_DEVICE_FAMILY_OTHER
	LGLCD_DEVICE_FAMILY_RAINBOW
	LGLCD_DEVICE_FAMILY_SPEAKERS_Z10
	LGLCD_INVALID_CONNECTION
	LGLCD_INVALID_DEVICE
	LGLCD_LCD_FOREGROUND_APP_NO
	LGLCD_LCD_FOREGROUND_APP_YES
	LGLCD_NOTIFICATION_CLOSE_AND_REOPEN_DEVICE
	LGLCD_NOTIFICATION_CLOSE_CONNECTION
	LGLCD_NOTIFICATION_CLOSE_DEVICE
	LGLCD_NOTIFICATION_DEVICE_ARRIVAL
	LGLCD_NOTIFICATION_DEVICE_REMOVAL
	LGLCD_NOTIFICATION_RUN_NEW_INSTANCE_ON_DEVICE
	LGLCD_PRIORITY_ALERT
	LGLCD_PRIORITY_BACKGROUND
	LGLCD_PRIORITY_IDLE_NO_SHOW
	LGLCD_PRIORITY_NORMAL
	lgLcdConnect
	lgLcdConnectEx
	lgLcdEnumerateEx
);

our $VERSION = '0.03';
our @callbacks_ref;

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "&Win32::Lglcd::constant not defined" if $constname eq 'constant';
    my ($error, $val) = constant($constname);
    if ($error) { croak $error; }
    {
	no strict 'refs';
	# Fixed between 5.005_53 and 5.005_61
#XXX	if ($] >= 5.00561) {
#XXX	    *$AUTOLOAD = sub () { $val };
#XXX	}
#XXX	else {
	    *$AUTOLOAD = sub { $val };
#XXX	}
    }
    goto &$AUTOLOAD;
}

require XSLoader;
XSLoader::load('Win32::Lglcd', $VERSION);

# Preloaded methods go here.

#constructor
sub new{
	my $classname = shift;
	my $self = bless {}, $classname;
	return $self;
}

sub init{ return !g15_init(); }
sub deinit{ return !g15_deinit(); }
sub get_last_error{ return g15_get_last_error(); }
sub get_error_message{ shift; return g15_get_error_message(shift); }#TODO: check if $_[0] is an object ref or not...
sub get_last_error_message{ return g15_get_error_message( g15_get_last_error() ); }
sub use_families{
	my $self = shift;
	return unless exists $self->{connectionContext};
	my $connection = $self->{connectionContext}->connection;
	return !g15_setDeviceFamiliesToUse( $connection, shift, 0 );
}

sub foreground{
	my $self = shift;
	return unless exists $self->{openContext};
	my $device = $self->{openContext}->device;
	return !g15_setforeground($device,1); 
}

sub background{
	my $self = shift;
	return unless exists $self->{openContext};
	my $device = $self->{openContext}->device;
	return !g15_setforeground($device,0);
}

sub sendbmp{
	my $self = shift;
	return unless exists $self->{openContext};
	my $device = $self->{openContext}->device;
	return g15_sendbmp($device, shift)==0;
}

sub testCallbackSoftbuttons{ #------------x---------------x----------------x----------------x------------------
	print "** testCallbackSoftbuttons is called with '". join(',',@_)."' **\n";
	return 0;
}

sub open{ 
	my $self = shift; #TODO: allow to pass parameters like index, callback...
	my %args = @_;
	return unless exists $self->{connectionContext};
	my $connection = $self->{connectionContext}->connection;
	my $callback = undef;
	my $index = 0;
	$index = $args{index} if exists $args{index};
	my $context;
	if(exists $args{callback}){
		my $codecallback = $args{callback};
		my $paramcallback = 0;
		$paramcallback = $args{paramcallback} if exists $args{paramcallback};
		$callback = g15_create_callback_wrapper( $codecallback, \$paramcallback);
		push @callbacks_ref, $callback;		#hack to take in perl a reference of this variable...
		$context = g15_open($connection, $index, 0, $callback);
	}		
	else{
		$context = g15_open($connection, $index);
	}
	if($context && $self->get_last_error()==0){
		$self->{openContext}=$context;
		return 1;
	}
	return 0;
}

sub close{ 
	my $self = shift;
	return unless exists $self->{openContext};
	my $device = $self->{openContext}->device;
	return !g15_close($device); 
}

sub disconnect{ 
	my $self = shift;
	return unless exists $self->{connectionContext};
	my $connection = $self->{connectionContext}->connection;
	return !g15_disconnect($connection); 
}

sub setfamilies{ 
	my $self = shift; 
	my ($connection, $dwDeviceFamiliesSupported, $dwReserved1) = @_;
	return !g15_setDeviceFamiliesToUse($connection, $dwDeviceFamiliesSupported, $dwReserved1); 
}

sub testConfigureCallback{ #------------x---------------x----------------x----------------x------------------
	print "** testConfigureCallback is called with '". join(',',@_)."' **\n";
	return 0;
}

sub testNotificationCallback{ #------------x---------------x----------------x----------------x------------------
	print "** testNotificationCallback is called with '". join(',',@_)."' **\n";
	return 0;
}

sub connect{
	my ($self, $appname ) = @_;
	
	my $callback = g15_create_callback_wrapper(\&testConfigureCallback,0);
	push @callbacks_ref, $callback;		#hack to take in perl a reference of this variable...

	my $callback2 = g15_create_callback_wrapper(\&testNotificationCallback,0);
	push @callbacks_ref, $callback2;		#hack to take in perl a reference of this variable...

	#~ my $context = g15_connect($appname, # isAutostartable=FALSE, isPersistent=FALSE, configCallback=NULL, configContext=NULL, connection=LGLCD_INVALID_CONNECTION
						#~ 0, 0, $callback
						#~ );	
	my $context = g15_connect_ex($appname, # isAutostartable=FALSE, isPersistent=FALSE, configCallback=NULL, configContext=NULL, connection=LGLCD_INVALID_CONNECTION
						0, 0, $callback, $callback2
						);
	if($context && $self->get_last_error()==0){
		$self->{connectionContext}=$context;
		return 1;
	}
	return 0;
}

#return the list of devices
sub enumerate{
	my $self = shift;
	my @devices;
	my $i=0;
	return unless exists $self->{connectionContext};
	my $connection = $self->{connectionContext}->connection;
	while(1){
		my $dev = g15_enumerate($connection, $i++);
		last unless $dev;
		my $device = {
			width => $dev->Width(),
			height => $dev->Height(),
			bpp => $dev->Bpp(),
			softbuttons => $dev->NumSoftButtons(),
		};
		push @devices, $device;
	}
	return @devices;
}

sub enumerateEx{
	my $self = shift;
	my @devices;
	my $i=0;
	my $connection = $self->{connectionContext}->connection;
	while(1){
		my $dev = g15_enumerate_ex($connection, $i++);
		last unless $dev;
		my $device = {
			width => $dev->Width(),
			height => $dev->Height(),
			bpp => $dev->Bpp(),
			softbuttons => $dev->NumSoftButtons(),
			family => $dev->deviceFamilyId(),
			displayname => $dev->deviceDisplayName(),
			reserved1 => $dev->Reserved1(),
			reserved2 => $dev->Reserved2(),
		};
		push @devices, $device;
	}
	return @devices;
}

sub softbuttons_state{
	my $self = shift;
	return unless exists $self->{openContext};
	my $device = $self->{openContext}->device;
	my $buttons = g15_softbuttons_state( $device );
	return if($buttons==0xffff_ffff);
	return $buttons unless @_ && $_[0] eq 'hash';
	my %hashButtons;
	for my $i(0..31){	#DWORD is a 32bits value
		$hashButtons{"BUTTON".$i."_PRESSED"} = ($buttons & 2**$i) ? 1:0;
	}
	return %hashButtons;
}
# Autoload methods go after =cut, and are processed by the autosplit program.
1;

package 
	GD::Image;	#don't let it viewed as a GD::Image package (this may erase pod doc of the original package)
sub Lglcd{
	my $image = shift;
	my %args = @_;
	my $data="";
	my $white = $image->colorExact( 255, 255, 255 );
	my ($startx, $starty, $width, $height) = (0, 0, 160, 43);
	my ($zero, $one, $eol) = ("\x00" , "\xFF", '');
	#Read subroutine args...
	$startx = $args{x} if exists $args{x};
	$starty = $args{y} if exists $args{y};
	$width = $args{width} if exists $args{width};
	$height = $args{height} if exists $args{height};
	$white = $args{white} if exists $args{white};
	$zero = $args{0} if exists $args{0};
	$one = $args{1} if exists $args{1};
	$eol = $args{eol} if exists $args{eol};
	warn "GD::Image::Lglcd picture is not in the 'normal' size !\n" if $width!=160 || $height!=43;
	
	for my $y($starty..$starty+$height-1){
		for my $x($startx..$startx+$width-1){
			$data.= $image->getPixel($x,$y)==$white ? $zero:$one;
		}
		$data.=$eol if $eol ne '';
	}	
	return $data;
}
1;
__END__

=head1 NAME

Win32::Lglcd - Perl extension for writting perl's app for logitech devices.

=head1 SYNOPSIS

  use Win32::Lglcd;
   
  my $g15 = Win32::Lglcd->new;
  
  $g15->init();
  
  $g15->connect('App Name');

  sub onSoftButtonChanged{
    my ($connection, $button, $params) = @_;
    ...
    return 0;
  }
  
  $g15->open(callback=>\&onSoftButtonChanged);
  
  $g15->foreground();
  
  while( ... ){ #App main loop
  
    ...  #prepare $pict
	
    $g15->sendbmp($pict);
  
    Win32::Lglcd::g15_do_event();
  }
  
  $g15->close();
  
  $g15->disconnect();
  
  $g15->deinit();  

=head1 DESCRIPTION

This module provide an interface to Lglcd library from Perl. It's allow to 
write application that can communicate with the Logitech LCD manager.

Actually, configuration and notification callbacks are not supported.
The softbuttons callback work but it need a regular call 
to Win32::Lglcd::g15_do_event sub.

=head1 FUNCTIONS

=head2 new

Object creator.

  my $lcd = new Win32::Lglcd;

=head2 init

To be called before any other subs.

  $lcd->init;

=head2 deinit

To be called at the end of use of this module, it will free all resources allocated by the library.

  $lcd->deinit;

=head2 get_last_error

Return the last error code
  my $errcode = $lcd->get_last_error;

=head2 get_error_message ERROR_CODE

Return the error message matching with C<ERROR_CODE>.

  print "Error: " . $lcd->get_error_message( $errcode );

=head2 get_last_error_message

Return the last error message.

  print "Last error: " . $lcd->get_last_error_message;

=head2 use_families FAMILY_TYPE

Set the type of family devices to use, C<FAMILY_TYPE> could one of the following constants:

  LGLCD_DEVICE_FAMILY_JACKBOX
  LGLCD_DEVICE_FAMILY_KEYBOARD_G15
  LGLCD_DEVICE_FAMILY_LCDEMULATOR_G15
  LGLCD_DEVICE_FAMILY_OTHER
  LGLCD_DEVICE_FAMILY_RAINBOW
  LGLCD_DEVICE_FAMILY_SPEAKERS_Z10

  $lcd->use_families( LGLCD_DEVICE_FAMILY_LCDEMULATOR_G15 );

=head2 foreground

Ask LCD manager to put application in foreground.

  $lcd->foreground;

=head2 background

Ask LCD manager to put application in background.

  $lcd->background;

=head2 sendbmp PICTURE

Send the C<PICTURE> image to the LCD device, it must have the right format.

  $lcd->sendbmp( $pict );

Tips: you can use the sub C<GD::Image::Lglcd> just provided with this package.

  $lcd->sendbmp( $gdimage->Lglcd );


=head2 open index=>value, callback=>{...}, paramcallback=>...

It starts the communication with an attached device.

  index: specifies the index of the device to open.

  callback: a sub onSoftbuttonsChanged take in args (device,dwButtons,context)

  paramcallback: a reference to what you want to retrieve in you callback.

  $lcd->open( callback => &\onSoftbuttons );

=head2 close

Close a connection with LCD manager.

  $lcd->close;

=head2 disconnect

Disconnect current openned connection with a device.

  $lcd->disconnect;

=head2 setfamilies

Used to inform the LCD Manager of what device types the app is interested in using.
This will filter the result of enumerate and enumerateEx subs.

=head2 connect APPNAME

Establish a connection to the LCD manager, C<APPNAME> is the application name.

  $lcd->connect('Perl Applet');

=head2 enumerate

Retrieve information about all the currently attached and supported LCD devices.

  foreach $dev( $lcd->enumerate ){
    print 
      $dev{width} . "x" . 
      $dev{height} . "x" . 
      $dev{bpp} . ":" . 
      $dev{softbuttons}. "\n";
  }

=head2 enumerateEx

Same as enumerate but with more informations.

  foreach $dev( $lcd->enumerateEx ){
    print 
      $dev{displayname} . "(" . 
      $dev{family} . "," . 
      $dev{reserved1} . "," . 
      $dev{reserved2} . "), " . 
      $dev{width} . "x" . 
      $dev{height} . "x" . 
      $dev{bpp} . ":" . 
      $dev{softbuttons}. "\n";
  }  

=head2 softbuttons_state

Use to retrieve the state of each soft buttons.
It return a hash which keys are BUTTON0_PRESSED to BUTTON32_PRESSED.

  my %keys_state = $lcd->softbuttons_state;

=head2 GD::Image::Lglcd

C<GD::Image::Lglcd> provide an helper sub to convert GD picture into a LGLCD compatible bitmap.

  use GD;
  use Benchmark;
  use Win32::Lglcd;		#here you include GD::Image::Lglcd sub
  my $start = new Benchmark;
  my $im = new GD::Image(160,43,0);
  my $white = $im->colorAllocate(255,255,255);
  my $black = $im->colorAllocate(0,0,0);       
  $im->rectangle(0,0,159,42,$black);
  $im->filledEllipse(80,21,140,24,$black);
  $im->string(gdSmallFont,20,15,"LCD Logo",$white);
  #ConvertData to Lglcd format !
  $|=1;
  my $pict = $im->Lglcd( 0=>'_', 1=>'0', eol=>"\n", x=>12, y=>13, width=>80, height=>25, white=>$black );
  print $pict;
  my $end = new Benchmark;
  warn ("Bench = " . timestr( timediff($end, $start) ) . "\n");

=head2 EXPORT

All by default.

=head2 Exportable constants

  LGLCDBUTTON_BUTTON0
  LGLCDBUTTON_BUTTON1
  LGLCDBUTTON_BUTTON2
  LGLCDBUTTON_BUTTON3
  LGLCD_APPLET_CAP_BASIC
  LGLCD_APPLET_CAP_CAN_CLOSE_AND_REOPEN_DEVICE
  LGLCD_APPLET_CAP_CAN_CLOSE_CONNECTION
  LGLCD_APPLET_CAP_CAN_CLOSE_DEVICE
  LGLCD_APPLET_CAP_CAN_RUN_ON_MULTIPLE_DEVICES
  LGLCD_BMP_FORMAT_160x43x1
  LGLCD_BMP_HEIGHT
  LGLCD_BMP_WIDTH
  LGLCD_DEVICE_FAMILY_JACKBOX
  LGLCD_DEVICE_FAMILY_KEYBOARD_G15
  LGLCD_DEVICE_FAMILY_LCDEMULATOR_G15
  LGLCD_DEVICE_FAMILY_OTHER
  LGLCD_DEVICE_FAMILY_RAINBOW
  LGLCD_DEVICE_FAMILY_SPEAKERS_Z10
  LGLCD_INVALID_CONNECTION
  LGLCD_INVALID_DEVICE
  LGLCD_LCD_FOREGROUND_APP_NO
  LGLCD_LCD_FOREGROUND_APP_YES
  LGLCD_NOTIFICATION_CLOSE_AND_REOPEN_DEVICE
  LGLCD_NOTIFICATION_CLOSE_CONNECTION
  LGLCD_NOTIFICATION_CLOSE_DEVICE
  LGLCD_NOTIFICATION_DEVICE_ARRIVAL
  LGLCD_NOTIFICATION_DEVICE_REMOVAL
  LGLCD_NOTIFICATION_RUN_NEW_INSTANCE_ON_DEVICE
  LGLCD_PRIORITY_ALERT
  LGLCD_PRIORITY_BACKGROUND
  LGLCD_PRIORITY_IDLE_NO_SHOW
  LGLCD_PRIORITY_NORMAL
  lgLcdConnect
  lgLcdConnectEx
  lgLcdEnumerateEx

=head1 Know bugs

While the applet is running, it crash when softbutton are clicked before 
the callback of previous as leaved. May be a re-entrance matter.

=head1 TODO List

  - write applet's skeleton / base object
  - add a parameter to choose the way to avoid the callback 're-entrance' 
crash.
  - implement configuration and notification callbacks.

=head1 SAMPLE

  use GD;
  use Win32::Lglcd;
  use Time::HiRes qw(usleep);
  
  $|=1;
  my $continue_loop = 1;		#Allow to close applet with CTRL+C
  sub sig_handler {			#1st argument is signal name
      my($sig) = @_;
      print "Caught a SIG$sig--shutting down\n";
      $continue_loop=0;
  }
  $SIG{'INT'}  = \&sig_handler;
  $SIG{'BREAK'} = \&sig_handler;
  
  my $delay = 150;
  sub onSoftButtonChanged{
  	my ($connection, $button, $params) = @_;
  	$xinc +=1 if $button==1;
  	$xinc -=1 if $button==2;
  	$xinc +=10 if $button==3;
  	$xinc -=10 if $button==4;
  	$xinc = 1 if $xinc < 1;
  	return 0;
  }
  
  my $g15 = Win32::Lglcd->new;
  $g15->init() or die "can't initialize Win32::Lglcd library!";
  $g15->connect('ScrollingText') or die "can't connect to Win32::Lglcd!";
  #~ $g15->use_families(LGLCD_DEVICE_FAMILY_LCDEMULATOR_G15);
  #~ my @devices = $g15->enumerateEx;
  #~ use Data::Dumper; print Dumper( @devices );
  $g15->open(callback=>\&onSoftButtonChanged) or die "can't open specified device!";
  $g15->foreground();
  my $im = new GD::Image(320,43,0);
  my $white = $im->colorAllocate(255,255,255);
  my $black = $im->colorAllocate(0,0,0);
  #$im->rectangle(0,0,159,42,$black);
  $im->string(gdGiantFont,10,5, "Scrolling text - test app - blah -" ,$black);
  $im->string(gdGiantFont,0,25, "- blah - Scrolling text - test app" ,$black);
  my $x = 0;
  our $xinc = 1;
  while($continue_loop){
  	$x+=$xinc;
  	$xinc=-$xinc,$x+=$xinc if $x>=160 or $x<=0;
  	my $pict = $im->Lglcd( 'x'=> $x );
  	$g15->sendbmp($pict);
  	foreach(1..10){
  		Win32::Lglcd::g15_do_event();	#a internal process message for callbacks (avoid crash)
  		usleep(50);
  	}
  }
  $g15->close() or die "can't close devices!"; 
  $g15->disconnect() or die "can't disconnect library Win32::Lglcd!";
  $g15->deinit() or die "can't free library Win32::Lglcd!";
  exit;

=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

=head1 AUTHOR

N. Georges, E<lt>xlat.@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by N. Georges

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
