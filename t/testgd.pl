package 
	GD::Image;	#don't let it viewed as a GD::Image package (this may erase pod doc of the original package)
sub libg15{
	my $image = shift;
	my %args = @_;
	my $data="";
	#TODO: send a warn if dimension are not 160x43, but process normally
	# or use and x,y offset to extract part ... of image or to redim the part to extract...
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
	warn "GD::Image::libg15 picture is not in the 'normal' size !\n" if $width!=160 || $height!=43;
	
	for my $y($starty..$starty+$height-1){
		for my $x($startx..$startx+$width-1){
			$data.= $image->getPixel($x,$y)==$white ? $zero:$one;
		}
		$data.=$eol if $eol ne '';
	}	
	return $data;
}
1;

package main;
use GD;
use Benchmark;
my $start = new Benchmark;
my $im = new GD::Image(160,43,0);
my $white = $im->colorAllocate(255,255,255);
my $black = $im->colorAllocate(0,0,0);       
$im->rectangle(0,0,159,42,$black);
$im->filledEllipse(80,21,140,34,$black);
$im->string(gdSmallFont,20,15,"Conceptware",$white);
#ConvertData to libg15 format !
$|=1;
my $pict = $im->libg15( 0=>'_', 1=>'0', eol=>"\n", x=>12, y=>13, width=>80, height=>25, white=>$black );
print $pict;
my $end = new Benchmark;
warn ("Bench = " . timestr( timediff($end, $start) ) . "\n");
