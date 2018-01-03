#! /usr/bin/perl


foreach $f (`ls filter/dif/text/*.txt`){ 
	
	chop($f);
	
	$out = `echo $f | sed s/filter/peaks/ | sed s/.text// | sed s/txt/peaks/`;
	chop($out);
	
	print "$f  $out\n";
	
	if( $f =~ /_1-3/ ){
		system "perl region_peaks.pl -epoch -100 1000 -sample 1 -area targ_dif_peaks.area -file $f -out $out";
	} elsif( $f =~ /_2-3/ ){
		system "perl region_peaks.pl -epoch -100 1000 -sample 1 -area dist_dif_peaks.area -file $f -out $out";
	}
}
