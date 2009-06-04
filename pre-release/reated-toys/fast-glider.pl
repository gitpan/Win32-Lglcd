#!/usr/bin/perl -w
use strict;
use Game::Life::Fast qw/ copy_grid process /;
use Time::HiRes qw( usleep );
use Win32::Lglcd;
my @starting = qw(
		  .......
		  .......
		  ..XXX..
		  ..X....
		  ...X...
		  .......
		  .......
		  ....... );

our $continue_loop = 1;
sub sig_handler {       # 1st argument is signal name
    my($sig) = @_;
    print "Caught a SIG$sig--shutting down\n";
    $continue_loop=0;
}
$SIG{'INT'}  = \&sig_handler;
$SIG{'BREAK'} = \&sig_handler;
my $iterator = 0;
sub onSoftbuttons{ #------------x---------------x----------------x----------------x------------------
	print "** g15-fast-glider:: onSoftbuttons is called with '". join(',',@_)."' **\n";
	#~ $day_offset-- if $_[1]==1;
	#~ $day_offset++ if $_[1]==2;
	#~ $day_offset=0 if $_[1]==4;
	#~ $display_type ^= 1 if $_[1]==8;
    $iterator = 151 if $_[1]==1;
    
	return 0;
}

my $g15 = Win32::Lglcd->new;
$g15->init() or die "can't initialize Win32::Lglcd library!";
$g15->connect('Life game') or die "can't connect to Win32::Lglcd!";
#$g15->use_families(8); # 8 => EMULATOR_ONLY
#~ my @devices = $g15->enumerateEx;
#~ use Data::Dumper; print Dumper( @devices );
$g15->open( callback=>\&onSoftbuttons, paramcallback=>1 ) or die "can't open specified device!";

$g15->foreground();
$g15->foreground(0);
$g15->foreground();
$|=1;
my $alive = "\xFF";
my $death = "\x00";
my $grid_width = 160;
my $grid_height = 43;
my $grid = ' ' x ($grid_width*$grid_height);
my $small_grid = "XXXXXX     X     X     X     X";
$small_grid =~ s/X/$alive/g;
$small_grid =~ s/\s/$death/g;
copy_grid( $small_grid, 5, 5, $grid, $grid_width, $grid_height, ($grid_width-5)/2, ($grid_height-5)/2);

while($continue_loop){	
    Win32::Lglcd::g15_do_event();
	$g15->sendbmp($grid);
	usleep( 10000 );
	process( $grid, $grid_width, $grid_height, $alive, $death );	
	if($iterator++ > 150){
		copy_grid( $small_grid, 5, 5, $grid, $grid_width, $grid_height, ($grid_width-5)/2, ($grid_height-5)/2);
		$iterator=0;
	}
	print "Iterator= $iterator   \r";
	#~ $_ = <>;
	#~ last if /bye|quit|exit|stop/i;
}

$g15->close() or die "can't close devices!"; 
$g15->disconnect() or die "can't disconnect library Win32::Lglcd!";
$g15->deinit() or die "can't free library Win32::Lglcd!";
exit;
