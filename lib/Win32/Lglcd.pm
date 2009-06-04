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

our $VERSION = '0.02';
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
# Below is stub documentation for your module. You'd better edit it!
I'll take time !!!

=head1 NAME

Win32::Lglcd - Perl extension for writting perl's app for logitech devices.

=head1 SYNOPSIS

  use Win32::Lglcd;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Win32::Lglcd, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.

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

While the applet is running, it crash when softbutton are clicked before the callback of previous as leaved.
May be a re-entrance matter. It is in my todo list.

=head1 TODO List

- improve test units
- write applet's skeleton / base object
- avoiding callback re-entrance

=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

N. Georges, E<lt>xlat.@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by N. Georges

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
