use 5.008008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Win32::Lglcd',
    VERSION_FROM      => 'lib/Win32/Lglcd.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Win32/Lglcd.pm', # retrieve abstract from module
       AUTHOR         => 'Nicolas GEORGES <xlat@cpan.org>') : ()),
    #~ LDLOADLIBS => 'Lglcd/lglcd.lib',
    #~ CCFLAGS => '-Wl,-lLglcd/lglcd.lib',
    LDFROM			  => "./Lglcd/lglcd.lib",
    MYEXTLIB		  => 'Lglcd.obj ./Lglcd/lglcd.lib',
    #~ LIBS              => ['-lLglcd/lglcd.lib'], # e.g., '-lm'
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
    INC               => '-I.  -I./Lglcd', # e.g., '-I. -I/usr/include/other'
	# Un-comment this if you add C files to link with later:
    # OBJECT            => '$(O_FILES)', # link all the C files too
);
if  (eval {require ExtUtils::Constant; 1}) {
  # If you edit these definitions to change the constants used by this module,
  # you will need to use the generated const-c.inc and const-xs.inc
  # files to replace their "fallback" counterparts before distributing your
  # changes.
  my @names = (qw(LGLCDBUTTON_BUTTON0 LGLCDBUTTON_BUTTON1 LGLCDBUTTON_BUTTON2
		 LGLCDBUTTON_BUTTON3 LGLCD_APPLET_CAP_BASIC
		 LGLCD_APPLET_CAP_CAN_CLOSE_AND_REOPEN_DEVICE
		 LGLCD_APPLET_CAP_CAN_CLOSE_CONNECTION
		 LGLCD_APPLET_CAP_CAN_CLOSE_DEVICE
		 LGLCD_APPLET_CAP_CAN_RUN_ON_MULTIPLE_DEVICES
		 LGLCD_BMP_FORMAT_160x43x1 LGLCD_BMP_HEIGHT LGLCD_BMP_WIDTH
		 LGLCD_DEVICE_FAMILY_JACKBOX LGLCD_DEVICE_FAMILY_KEYBOARD_G15
		 LGLCD_DEVICE_FAMILY_LCDEMULATOR_G15 LGLCD_DEVICE_FAMILY_OTHER
		 LGLCD_DEVICE_FAMILY_RAINBOW LGLCD_DEVICE_FAMILY_SPEAKERS_Z10
		 LGLCD_INVALID_CONNECTION LGLCD_INVALID_DEVICE
		 LGLCD_LCD_FOREGROUND_APP_NO LGLCD_LCD_FOREGROUND_APP_YES
		 LGLCD_NOTIFICATION_CLOSE_AND_REOPEN_DEVICE
		 LGLCD_NOTIFICATION_CLOSE_CONNECTION
		 LGLCD_NOTIFICATION_CLOSE_DEVICE
		 LGLCD_NOTIFICATION_DEVICE_ARRIVAL
		 LGLCD_NOTIFICATION_DEVICE_REMOVAL
		 LGLCD_NOTIFICATION_RUN_NEW_INSTANCE_ON_DEVICE
		 LGLCD_PRIORITY_ALERT LGLCD_PRIORITY_BACKGROUND
		 LGLCD_PRIORITY_IDLE_NO_SHOW LGLCD_PRIORITY_NORMAL lgLcdConnect
		 lgLcdConnectEx lgLcdEnumerateEx));
  ExtUtils::Constant::WriteConstants(
                                     NAME         => 'Win32::Lglcd',
                                     NAMES        => \@names,
                                     DEFAULT_TYPE => 'IV',
                                     C_FILE       => 'const-c.inc',
                                     XS_FILE      => 'const-xs.inc',
                                  );

}
else {
  use File::Copy;
  use File::Spec;
  foreach my $file ('const-c.inc', 'const-xs.inc') {
    my $fallback = File::Spec->catfile('fallback', $file);
    copy ($fallback, $file) or die "Can't copy $fallback to $file: $!";
  }
}

use File::Copy;
copy( 'C:\Program Files\Logitech\GamePanel Software\LCD Manager\SDK\SDK\Src\lglcd.h', './Lglcd/lglcd.h' )
	unless -e './Lglcd/lglcd.h';
	
copy( 'C:\Program Files\Logitech\GamePanel Software\LCD Manager\SDK\SDK\Libs\x86\lglcd.lib', './Lglcd/lglcd.lib' )
	unless -e './Lglcd/lglcd.lib';