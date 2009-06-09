#define PERL_constant_NOTFOUND	1
#define PERL_constant_NOTDEF	2
#define PERL_constant_ISIV	3
#define PERL_constant_ISNO	4
#define PERL_constant_ISNV	5
#define PERL_constant_ISPV	6
#define PERL_constant_ISPVN	7
#define PERL_constant_ISSV	8
#define PERL_constant_ISUNDEF	9
#define PERL_constant_ISUV	10
#define PERL_constant_ISYES	11

#ifndef NVTYPE
typedef double NV; /* 5.6 and later define NVTYPE, and typedef NV to it.  */
#endif
#ifndef aTHX_
#define aTHX_ /* 5.6 or later define this for threading support.  */
#endif
#ifndef pTHX_
#define pTHX_ /* 5.6 or later define this for threading support.  */
#endif

static int
constant_19 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     LGLCDBUTTON_BUTTON0 LGLCDBUTTON_BUTTON1 LGLCDBUTTON_BUTTON2
     LGLCDBUTTON_BUTTON3 */
  /* Offset 18 gives the best switch position.  */
  switch (name[18]) {
  case '0':
    if (memEQ(name, "LGLCDBUTTON_BUTTON", 18)) {
    /*                                 0      */
#ifdef LGLCDBUTTON_BUTTON0
      *iv_return = LGLCDBUTTON_BUTTON0;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '1':
    if (memEQ(name, "LGLCDBUTTON_BUTTON", 18)) {
    /*                                 1      */
#ifdef LGLCDBUTTON_BUTTON1
      *iv_return = LGLCDBUTTON_BUTTON1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '2':
    if (memEQ(name, "LGLCDBUTTON_BUTTON", 18)) {
    /*                                 2      */
#ifdef LGLCDBUTTON_BUTTON2
      *iv_return = LGLCDBUTTON_BUTTON2;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case '3':
    if (memEQ(name, "LGLCDBUTTON_BUTTON", 18)) {
    /*                                 3      */
#ifdef LGLCDBUTTON_BUTTON3
      *iv_return = LGLCDBUTTON_BUTTON3;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_25 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     LGLCD_BMP_FORMAT_160x43x1 LGLCD_DEVICE_FAMILY_OTHER
     LGLCD_PRIORITY_BACKGROUND */
  /* Offset 11 gives the best switch position.  */
  switch (name[11]) {
  case 'E':
    if (memEQ(name, "LGLCD_DEVICE_FAMILY_OTHER", 25)) {
    /*                          ^                    */
#ifdef LGLCD_DEVICE_FAMILY_OTHER
      *iv_return = LGLCD_DEVICE_FAMILY_OTHER;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'I':
    if (memEQ(name, "LGLCD_PRIORITY_BACKGROUND", 25)) {
    /*                          ^                    */
#ifdef LGLCD_PRIORITY_BACKGROUND
      *iv_return = LGLCD_PRIORITY_BACKGROUND;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'O':
    if (memEQ(name, "LGLCD_BMP_FORMAT_160x43x1", 25)) {
    /*                          ^                    */
#ifdef LGLCD_BMP_FORMAT_160x43x1
      *iv_return = LGLCD_BMP_FORMAT_160x43x1;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_27 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     LGLCD_DEVICE_FAMILY_JACKBOX LGLCD_DEVICE_FAMILY_RAINBOW
     LGLCD_LCD_FOREGROUND_APP_NO LGLCD_PRIORITY_IDLE_NO_SHOW */
  /* Offset 23 gives the best switch position.  */
  switch (name[23]) {
  case 'K':
    if (memEQ(name, "LGLCD_DEVICE_FAMILY_JACKBOX", 27)) {
    /*                                      ^          */
#ifdef LGLCD_DEVICE_FAMILY_JACKBOX
      *iv_return = LGLCD_DEVICE_FAMILY_JACKBOX;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'N':
    if (memEQ(name, "LGLCD_DEVICE_FAMILY_RAINBOW", 27)) {
    /*                                      ^          */
#ifdef LGLCD_DEVICE_FAMILY_RAINBOW
      *iv_return = LGLCD_DEVICE_FAMILY_RAINBOW;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'P':
    if (memEQ(name, "LGLCD_LCD_FOREGROUND_APP_NO", 27)) {
    /*                                      ^          */
#ifdef LGLCD_LCD_FOREGROUND_APP_NO
      *iv_return = LGLCD_LCD_FOREGROUND_APP_NO;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'S':
    if (memEQ(name, "LGLCD_PRIORITY_IDLE_NO_SHOW", 27)) {
    /*                                      ^          */
#ifdef LGLCD_PRIORITY_IDLE_NO_SHOW
      *iv_return = LGLCD_PRIORITY_IDLE_NO_SHOW;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant_33 (pTHX_ const char *name, IV *iv_return) {
  /* When generated this function returned values for the list of names given
     here.  However, subsequent manual editing may have added or removed some.
     LGLCD_APPLET_CAP_CAN_CLOSE_DEVICE LGLCD_NOTIFICATION_DEVICE_ARRIVAL
     LGLCD_NOTIFICATION_DEVICE_REMOVAL */
  /* Offset 28 gives the best switch position.  */
  switch (name[28]) {
  case 'E':
    if (memEQ(name, "LGLCD_APPLET_CAP_CAN_CLOSE_DEVICE", 33)) {
    /*                                           ^           */
#ifdef LGLCD_APPLET_CAP_CAN_CLOSE_DEVICE
      *iv_return = LGLCD_APPLET_CAP_CAN_CLOSE_DEVICE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'M':
    if (memEQ(name, "LGLCD_NOTIFICATION_DEVICE_REMOVAL", 33)) {
    /*                                           ^           */
#ifdef LGLCD_NOTIFICATION_DEVICE_REMOVAL
      *iv_return = LGLCD_NOTIFICATION_DEVICE_REMOVAL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 'R':
    if (memEQ(name, "LGLCD_NOTIFICATION_DEVICE_ARRIVAL", 33)) {
    /*                                           ^           */
#ifdef LGLCD_NOTIFICATION_DEVICE_ARRIVAL
      *iv_return = LGLCD_NOTIFICATION_DEVICE_ARRIVAL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

static int
constant (pTHX_ const char *name, STRLEN len, IV *iv_return) {
  /* Initially switch on the length of the name.  */
  /* When generated this function returned values for the list of names given
     in this section of perl code.  Rather than manually editing these functions
     to add or remove constants, which would result in this comment and section
     of code becoming inaccurate, we recommend that you edit this section of
     code, and use it to regenerate a new set of constant functions which you
     then use to replace the originals.

     Regenerate these constant functions by feeding this entire source file to
     perl -x

#!C:\Perl\bin\perl.exe -w
use ExtUtils::Constant qw (constant_types C_constant XS_constant);

my $types = {map {($_, 1)} qw(IV)};
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

print constant_types(); # macro defs
foreach (C_constant ("Win32::Lglcd", 'constant', 'IV', $types, undef, 3, @names) ) {
    print $_, "\n"; # C constant subs
}
print "#### XS Section:\n";
print XS_constant ("Win32::Lglcd", $types);
__END__
   */

  switch (len) {
  case 12:
    if (memEQ(name, "lgLcdConnect", 12)) {
#ifdef lgLcdConnect
      *iv_return = lgLcdConnect;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 14:
    if (memEQ(name, "lgLcdConnectEx", 14)) {
#ifdef lgLcdConnectEx
      *iv_return = lgLcdConnectEx;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 15:
    if (memEQ(name, "LGLCD_BMP_WIDTH", 15)) {
#ifdef LGLCD_BMP_WIDTH
      *iv_return = LGLCD_BMP_WIDTH;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 16:
    /* Names all of length 16.  */
    /* LGLCD_BMP_HEIGHT lgLcdEnumerateEx */
    /* Offset 14 gives the best switch position.  */
    switch (name[14]) {
    case 'E':
      if (memEQ(name, "lgLcdEnumerateEx", 16)) {
      /*                             ^        */
#ifdef lgLcdEnumerateEx
        *iv_return = lgLcdEnumerateEx;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'H':
      if (memEQ(name, "LGLCD_BMP_HEIGHT", 16)) {
      /*                             ^        */
#ifdef LGLCD_BMP_HEIGHT
        *iv_return = LGLCD_BMP_HEIGHT;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 19:
    return constant_19 (aTHX_ name, iv_return);
    break;
  case 20:
    /* Names all of length 20.  */
    /* LGLCD_INVALID_DEVICE LGLCD_PRIORITY_ALERT */
    /* Offset 7 gives the best switch position.  */
    switch (name[7]) {
    case 'N':
      if (memEQ(name, "LGLCD_INVALID_DEVICE", 20)) {
      /*                      ^                   */
#ifdef LGLCD_INVALID_DEVICE
        *iv_return = LGLCD_INVALID_DEVICE;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'R':
      if (memEQ(name, "LGLCD_PRIORITY_ALERT", 20)) {
      /*                      ^                   */
#ifdef LGLCD_PRIORITY_ALERT
        *iv_return = LGLCD_PRIORITY_ALERT;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 21:
    if (memEQ(name, "LGLCD_PRIORITY_NORMAL", 21)) {
#ifdef LGLCD_PRIORITY_NORMAL
      *iv_return = LGLCD_PRIORITY_NORMAL;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 22:
    if (memEQ(name, "LGLCD_APPLET_CAP_BASIC", 22)) {
#ifdef LGLCD_APPLET_CAP_BASIC
      *iv_return = LGLCD_APPLET_CAP_BASIC;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 24:
    if (memEQ(name, "LGLCD_INVALID_CONNECTION", 24)) {
#ifdef LGLCD_INVALID_CONNECTION
      *iv_return = LGLCD_INVALID_CONNECTION;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 25:
    return constant_25 (aTHX_ name, iv_return);
    break;
  case 27:
    return constant_27 (aTHX_ name, iv_return);
    break;
  case 28:
    if (memEQ(name, "LGLCD_LCD_FOREGROUND_APP_YES", 28)) {
#ifdef LGLCD_LCD_FOREGROUND_APP_YES
      *iv_return = LGLCD_LCD_FOREGROUND_APP_YES;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 31:
    if (memEQ(name, "LGLCD_NOTIFICATION_CLOSE_DEVICE", 31)) {
#ifdef LGLCD_NOTIFICATION_CLOSE_DEVICE
      *iv_return = LGLCD_NOTIFICATION_CLOSE_DEVICE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 32:
    /* Names all of length 32.  */
    /* LGLCD_DEVICE_FAMILY_KEYBOARD_G15 LGLCD_DEVICE_FAMILY_SPEAKERS_Z10 */
    /* Offset 23 gives the best switch position.  */
    switch (name[23]) {
    case 'A':
      if (memEQ(name, "LGLCD_DEVICE_FAMILY_SPEAKERS_Z10", 32)) {
      /*                                      ^               */
#ifdef LGLCD_DEVICE_FAMILY_SPEAKERS_Z10
        *iv_return = LGLCD_DEVICE_FAMILY_SPEAKERS_Z10;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'B':
      if (memEQ(name, "LGLCD_DEVICE_FAMILY_KEYBOARD_G15", 32)) {
      /*                                      ^               */
#ifdef LGLCD_DEVICE_FAMILY_KEYBOARD_G15
        *iv_return = LGLCD_DEVICE_FAMILY_KEYBOARD_G15;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 33:
    return constant_33 (aTHX_ name, iv_return);
    break;
  case 35:
    /* Names all of length 35.  */
    /* LGLCD_DEVICE_FAMILY_LCDEMULATOR_G15 LGLCD_NOTIFICATION_CLOSE_CONNECTION
       */
    /* Offset 8 gives the best switch position.  */
    switch (name[8]) {
    case 'T':
      if (memEQ(name, "LGLCD_NOTIFICATION_CLOSE_CONNECTION", 35)) {
      /*                       ^                                 */
#ifdef LGLCD_NOTIFICATION_CLOSE_CONNECTION
        *iv_return = LGLCD_NOTIFICATION_CLOSE_CONNECTION;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'V':
      if (memEQ(name, "LGLCD_DEVICE_FAMILY_LCDEMULATOR_G15", 35)) {
      /*                       ^                                 */
#ifdef LGLCD_DEVICE_FAMILY_LCDEMULATOR_G15
        *iv_return = LGLCD_DEVICE_FAMILY_LCDEMULATOR_G15;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 37:
    if (memEQ(name, "LGLCD_APPLET_CAP_CAN_CLOSE_CONNECTION", 37)) {
#ifdef LGLCD_APPLET_CAP_CAN_CLOSE_CONNECTION
      *iv_return = LGLCD_APPLET_CAP_CAN_CLOSE_CONNECTION;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 42:
    if (memEQ(name, "LGLCD_NOTIFICATION_CLOSE_AND_REOPEN_DEVICE", 42)) {
#ifdef LGLCD_NOTIFICATION_CLOSE_AND_REOPEN_DEVICE
      *iv_return = LGLCD_NOTIFICATION_CLOSE_AND_REOPEN_DEVICE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  case 44:
    /* Names all of length 44.  */
    /* LGLCD_APPLET_CAP_CAN_CLOSE_AND_REOPEN_DEVICE
       LGLCD_APPLET_CAP_CAN_RUN_ON_MULTIPLE_DEVICES */
    /* Offset 23 gives the best switch position.  */
    switch (name[23]) {
    case 'N':
      if (memEQ(name, "LGLCD_APPLET_CAP_CAN_RUN_ON_MULTIPLE_DEVICES", 44)) {
      /*                                      ^                           */
#ifdef LGLCD_APPLET_CAP_CAN_RUN_ON_MULTIPLE_DEVICES
        *iv_return = LGLCD_APPLET_CAP_CAN_RUN_ON_MULTIPLE_DEVICES;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    case 'O':
      if (memEQ(name, "LGLCD_APPLET_CAP_CAN_CLOSE_AND_REOPEN_DEVICE", 44)) {
      /*                                      ^                           */
#ifdef LGLCD_APPLET_CAP_CAN_CLOSE_AND_REOPEN_DEVICE
        *iv_return = LGLCD_APPLET_CAP_CAN_CLOSE_AND_REOPEN_DEVICE;
        return PERL_constant_ISIV;
#else
        return PERL_constant_NOTDEF;
#endif
      }
      break;
    }
    break;
  case 45:
    if (memEQ(name, "LGLCD_NOTIFICATION_RUN_NEW_INSTANCE_ON_DEVICE", 45)) {
#ifdef LGLCD_NOTIFICATION_RUN_NEW_INSTANCE_ON_DEVICE
      *iv_return = LGLCD_NOTIFICATION_RUN_NEW_INSTANCE_ON_DEVICE;
      return PERL_constant_ISIV;
#else
      return PERL_constant_NOTDEF;
#endif
    }
    break;
  }
  return PERL_constant_NOTFOUND;
}

