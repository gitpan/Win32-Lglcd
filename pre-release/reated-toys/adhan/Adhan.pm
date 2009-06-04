package G15::Adhan;

use 5.008008;
use strict;
use warnings;
use Win32::Lglcd;
use Religion::Islam::PrayerTimes;
require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use G15::Adhan ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

our $basedir='./';
our ($prayer, $last_called_time, $next_salat, $next_salat_time, $next_salat_rawtime, $autodls,$display_type);
$display_type = 0;
# Preloaded methods go here.
sub initialize_prayers{
	$prayer = Religion::Islam::PrayerTimes->new();
	configure($prayer);
	$last_called_time = time();
	#($next_salat, $next_salat_time, $next_salat_rawtime) = get_next_salat( $prayer );	
}
sub configure{
	my $prayer = shift;
	my %config = (
			JuristicMethod => 1,
			CalculationMethod => 1,
			DaylightSaving => 0,
			PrayerLocation => 'Not configured',
			Latitude => 49.357777,
			Longitude => 5.995556,
			Altitude => 0,
			TimeZone => 0,
			FajerAngle => 18,
			IshaAngle => 18,
			TimeMode => 1,
		);
	#Open the adhan.conf file...
	if(open (my $FH, '<', $basedir.'/adhan.conf')){
		while(<$FH>){
			if(/^\s*([a-zA-Z0-9]+)\s*:\s*([a-zA-Z0-9]+)/){
				$config{$1} = $2;
			}
		}
		close $FH;
	}
	
	if($config{DaylightSaving} =~ /^auto$/i){
		$autodls=1;
		$config{DaylightSaving}=0;
	}
	
	$prayer->JuristicMethod( $config{JuristicMethod} );
	$prayer->CalculationMethod( $config{CalculationMethod} );
	$prayer->DaylightSaving( $config{DaylightSaving} );
	$prayer->PrayerLocation(
			Latitude =>  $config{Latitude} ,
			Longitude =>  $config{Longitude} ,
			Altitude =>  $config{Altitude} ,
			TimeZone =>  $config{TimeZone} 
	);
	$prayer->FajerAngle( $config{FajerAngle} );
	$prayer->IshaAngle( $config{IshaAngle} );
	$prayer->TimeMode( $config{TimeMode} );
}
sub get_salats{
	my ($prayer, $time) = @_;
	my ($sec,$min,$hour,$mday,$mon,$year) = localtime( $time );
	return $prayer->PrayerTimes($prayer->GDateAjust($year+1900, $mon+1, $mday));
}
my $day_offset = 0;
sub onSoftbuttons{ #------------x---------------x----------------x----------------x------------------
	#~ print "** NEW testCallbackSoftbuttons is called with '". join(',',@_)."' **\n";
	$day_offset-- if $_[1]==1;
	$day_offset++ if $_[1]==2;
	$day_offset=0 if $_[1]==4;
	$display_type ^= 1 if $_[1]==8;
	return 0;
}

$|=1;	#see as soon as possible infos, warns and errors...
my $g15 = Win32::Lglcd->new;
my $res;
$g15->init() or die "can't initialize Win32::Lglcd library!";
$g15->connect('Adhan') or die "can't connect to Win32::Lglcd!";
#$g15->use_families(8); # 8 => EMULATOR_ONLY
my @devices = $g15->enumerateEx;
#~ use Data::Dumper; print Dumper( @devices );
$g15->open( callback=>\&onSoftbuttons, paramcallback=>1 ) or die "can't open specified device!\n" . $g15->get_last_error_message() . $/;

$g15->background();
$g15->foreground();
#TODO: display a splash screen on G15 devices... for 2 secondes...
#$g15->sendbmp(__DATA__)
#sleep(2);

#~ $g15->sendbmp($pict);

#TODO: write a "$g15->do_mainloop" loop
initialize_prayers();

my $blink = 1;
use GD;
while(1){
	Win32::Lglcd::g15_do_event();
	sleep(1); #every seconds... or ... another nicer wait function which let do Idle/Yields...
	my $im = new GD::Image(160,43,0);
	my $white = $im->colorAllocate(255,255,255);
	my $black = $im->colorAllocate(0,0,0);       
	#$im->rectangle(0,0,159,42,$black);

	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time + 60*60*24*$day_offset );	
	#May have a bug on DTS switching...
	$year+=1900;
	$mon++;
	
	if($autodls==1){
		$prayer->DaylightSaving( $isdst );
	}
	#~ printf "%02d/%02d/%04d => DTS : $isdst\n", $mday, $mon, $year;
	
	my ($yg0, $mg0, $dg0) = $prayer->GDateAjust($year, $mon, $mday);
	my %result = $prayer->PrayerTimes($yg0, $mg0, $dg0);
	my %salats;
	foreach(qw/ Fajr Sunrise Zohar Aser Maghrib Isha /){
		my ($h, $m, $ap) = $prayer->FormatTime($result{$_});
		$salats{$_} = "$h:$m";
	}
	$im->string(gdTinyFont,0,0, "Fajr:    $salats{Fajr}",$black);
	$im->string(gdTinyFont,0,7,"Sunrise: $salats{Sunrise}",$black);
	$im->string(gdTinyFont,0,15,"Zohar:   $salats{Zohar}",$black);
	$im->string(gdTinyFont,80,0, "Aser:    $salats{Aser}",$black);
	$im->string(gdTinyFont,80,7,"Maghrib: $salats{Maghrib}",$black);
	$im->string(gdTinyFont,80,15,"Isha:    $salats{Isha}",$black);
	my @ltime = localtime(time + 60*60*24*$day_offset );
	if($display_type==1){
		my ($rh0, $yh0, $mh0, $dh0) = $prayer->G2HA( $yg0, $mg0, $dg0);
		$im->string(gdTinyFont,0,23,"$yh0-$mh0-$dh0 ",$black);
	}
	else{
		my @dayname = qw[ Dimanche Lundi Mardi Mercredi Jeudi Vendredi Samedi ];
		my @monthname = qw[ Janvier Février Mars Avril Mai Juin Juillet Aôut Septembre Octobre Novembre Decembre ];
		$im->string(gdTinyFont,0,23,"$dayname[$ltime[6]] $ltime[3] $monthname[$ltime[4]] ".($ltime[5]+1900),$black);
	}
	#Now, draw the bottom's buttons
	foreach my $couple ( 
		[41,11], [40,12], [41,12], [42,12], [39,13], [40,13], [41,13], [42,13], [43,13],
		[41,60], [40,59], [41,59], [42,59], [39,58], [40,58], [41,58], [42,58], [43,58],
		){
		my ($y, $x) = @{$couple};
		$im->setPixel( $x -1, $y -1, $black );
	}
	if($ltime[6]==5){
		#invert colors for times...
		if(abs($result{'Zohar'} - (($sec/60+$min)/60+$hour))*60 <= 20){
			$blink ^= 1;
		}else{ $blink=1; }
		($black,$white) = ($white,$black) if $blink;
		$im->filledRectangle(0, 31, 159, 37, $white);
	}
	$im->string(gdTinyFont,0,30, sprintf('%02d:%02d:%02d',$ltime[2], $ltime[1], $ltime[0]) . " - (c) n.georges" ,$black);	
	#ConvertData to Win32::Lglcd format !
	#~ $|=1;
	my $pict = $im->Lglcd;
	$g15->sendbmp($pict);

}

# SHOULD NOT APPEND
$g15->close() or die "can't close devices!"; 
$g15->disconnect() or die "can't disconnect library libg15!";
$g15->deinit() or die "can't free library Win32::Lglcd!";

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

G15::Adhan - Perl extension for blah blah blah

=head1 SYNOPSIS

  use G15::Adhan;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for G15::Adhan, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Nicolas GEORGES, E<lt>xlat@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Nicolas GEORGES

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut

