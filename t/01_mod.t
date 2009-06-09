# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 01_mod.t'

#########################

# change 'tests => 2' to 'tests => last_test_to_print';

use Test::More tests => 13;
BEGIN { use_ok('Win32::Lglcd') };


my $fail = 0;
foreach my $constname (qw(
	LGLCDBUTTON_BUTTON0 LGLCDBUTTON_BUTTON1 LGLCDBUTTON_BUTTON2
	LGLCDBUTTON_BUTTON3 LGLCD_APPLET_CAP_BASIC
	LGLCD_APPLET_CAP_CAN_CLOSE_AND_REOPEN_DEVICE
	LGLCD_APPLET_CAP_CAN_CLOSE_CONNECTION LGLCD_APPLET_CAP_CAN_CLOSE_DEVICE
	LGLCD_APPLET_CAP_CAN_RUN_ON_MULTIPLE_DEVICES LGLCD_BMP_FORMAT_160x43x1
	LGLCD_BMP_HEIGHT LGLCD_BMP_WIDTH LGLCD_DEVICE_FAMILY_JACKBOX
	LGLCD_DEVICE_FAMILY_KEYBOARD_G15 LGLCD_DEVICE_FAMILY_LCDEMULATOR_G15
	LGLCD_DEVICE_FAMILY_OTHER LGLCD_DEVICE_FAMILY_RAINBOW
	LGLCD_DEVICE_FAMILY_SPEAKERS_Z10 LGLCD_INVALID_CONNECTION
	LGLCD_INVALID_DEVICE LGLCD_LCD_FOREGROUND_APP_NO
	LGLCD_LCD_FOREGROUND_APP_YES LGLCD_NOTIFICATION_CLOSE_AND_REOPEN_DEVICE
	LGLCD_NOTIFICATION_CLOSE_CONNECTION LGLCD_NOTIFICATION_CLOSE_DEVICE
	LGLCD_NOTIFICATION_DEVICE_ARRIVAL LGLCD_NOTIFICATION_DEVICE_REMOVAL
	LGLCD_NOTIFICATION_RUN_NEW_INSTANCE_ON_DEVICE LGLCD_PRIORITY_ALERT
	LGLCD_PRIORITY_BACKGROUND LGLCD_PRIORITY_IDLE_NO_SHOW
	LGLCD_PRIORITY_NORMAL lgLcdConnect lgLcdConnectEx lgLcdEnumerateEx)) {
  next if (eval "my \$a = $constname; 1");
  if ($@ =~ /^Your vendor has not defined Win32::Lglcd macro $constname/) {
    print "# pass: $@";
  } else {
    print "# fail: $@";
    $fail = 1;
  }

}

ok( $fail == 0 , 'Constants' );
#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.
$|=1;
my $pict = "\xFF\x01" x (80*43);
if(eval "use File::Slurp; 1;"){
	# $pict = read_file('logo_pb.raw', binmode=> ':raw');
	$pict = read_file('t/test.ppm', binmode=> ':raw');
}

my $g15 = Win32::Lglcd->new;
my $res;
ok( $g15->init(), 'initialize' ) or warn $g15->get_last_error_message;
ok( $g15->connect('test Win32::Lglcd'), 'connect' );
#use Data::Dumper; print "--DEBUG--\n".Dumper( Win32::Lglcd::myTestFunc() )."\n";
#$res = Win32::Lglcd::myTestFunc();
#print join( '|', $res->appFriendlyName, $res->isPersistent, $res->isAutostartable,$res->onConfigure, $res->connection);
unless( $g15->enumerate()>0 ){
    #Try to create an emulator...
	if( eval 'use Win32::API; 1;' ){
		Win32::API->Import( 'user32', 'HWND FindWindow( LPCTSTR lpClassName, LPCTSTR lpWindowName );' );
		Win32::API->Import( 'user32', 'LRESULT SendMessage( HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);' ); 
		my $hwnd = FindWindow( "Logitech LCD Monitor Window", "LCDMon" );
		SendMessage( $hwnd, 273, 1133, 0 );
		#let time to LCDMon to create the emulator window before to continue...
		sleep(1);
	}
}
ok( $g15->enumerate()>0, 'enumerate' );
#ok( $g15->use_families(8) ); # 8 => EMULATOR
ok( $g15->open(), 'open' );
ok( $g15->background(), 'background');
ok( !$g15->sendbmp($pict), 'sendbmp ERROR_ACESS_DENIED');
ok( $g15->foreground(), 'foreground');
ok( $g15->sendbmp($pict), 'sendbmp');
#~ while(<>!~/^quit$/i){use Data::Dumper; print "--DEBUG--\n".Dumper( $g15->softbuttons_state('hash') )."\n";}
#~ <>;
ok( $g15->close(), 'close');
ok( $g15->disconnect(), 'disconnect');
#todo: TEST the connectEx with / without the callbacks...
ok( $g15->deinit(), 'deinitialize');