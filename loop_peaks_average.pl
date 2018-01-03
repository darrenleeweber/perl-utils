#! /usr/bin/perl


foreach $f (`ls filter/text/*.txt`){
	
	chop($f);
	
	$out = `echo $f | sed s/filter/peaks/ | sed s/text/sw/ | sed s/txt/peaks/`;
	chop($out);
	
	print "$f  $out ";
	
	if( $f =~ /_1/ ){
		print "target\n";
		system "perl region_peaks_average.pl -epoch -100 1000 -sample 1 -period 100 -number 5 -area targ_sw.area -file $f -out $out";
	} elsif( $f =~ /_2/ ){
		print "distractor\n";
		system "perl region_peaks_average.pl -epoch -100 1000 -sample 1 -period 100 -number 5 -area dist_sw.area -file $f -out $out";
	} elsif( $f =~ /_3/ ){
		print "common\n";
		system "perl region_peaks_average.pl -epoch -100 1000 -sample 1 -period 100 -number 5 -area comm_sw.area -file $f -out $out";
	}
}
