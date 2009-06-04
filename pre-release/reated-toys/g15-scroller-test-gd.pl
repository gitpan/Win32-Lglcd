use GD;
use Win32::Lglcd;
use Time::HiRes qw(usleep);

$|=1;

#Allow to close applet with CTRL+C
my $continue_loop = 1;
sub sig_handler {       # 1st argument is signal name
    my($sig) = @_;
    print "Caught a SIG$sig--shutting down\n";
    $continue_loop=0;
}
$SIG{'INT'}  = \&sig_handler;
$SIG{'BREAK'} = \&sig_handler;

my $delay = 150;
sub onSoftButtonChanged{
	my ($connection, $button, $params) = @_;
	$|=1;
	print "+";
	$xinc +=1 if $button==1;
	$xinc -=1 if $button==2;
	$xinc +=10 if $button==3;
	$xinc -=10 if $button==4;
	$xinc = 1 if $xinc < 1;
	#~ print $delay;
    print $xinc;
	print "-(button=$button,params=$params)\n";
	return 0;
}

my $g15 = Win32::Lglcd->new;
$g15->init() or die "can't initialize Win32::Lglcd library!";
$g15->connect('Conceptware') or die "can't connect to Win32::Lglcd!";
#$g15->use_families(8); # 8 => EMULATOR_ONLY
#~ my @devices = $g15->enumerateEx;
#~ use Data::Dumper; print Dumper( @devices );
$g15->open(callback=>\&onSoftButtonChanged) or die "can't open specified device!";

$g15->foreground();

my $im = new GD::Image(320,43,0);
my $white = $im->colorAllocate(255,255,255);
my $black = $im->colorAllocate(0,0,0);       
#$im->rectangle(0,0,159,42,$black);
$im->string(gdGiantFont,10,5, "Conceptware - Luxembourg - MAMER -" ,$black);
$im->string(gdGiantFont,0,25, "- Luxembourg - MAMER - Conceptware" ,$black);

my $x = 0;
our $xinc = 1;

while($continue_loop){
	$x+=$xinc;
	$xinc=-$xinc,$x+=$xinc if $x>=160 or $x<=0;
	my $pict = $im->Lglcd( 'x'=> $x );
	$g15->sendbmp($pict);

	foreach(1..10){
		Win32::Lglcd::g15_do_event();
		usleep(50);
	}
}

$g15->close() or die "can't close devices!"; 
$g15->disconnect() or die "can't disconnect library Win32::Lglcd!";
$g15->deinit() or die "can't free library Win32::Lglcd!";
exit;