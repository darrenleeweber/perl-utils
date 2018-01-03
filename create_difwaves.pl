#! /usr/bin/perl

foreach $f (`ls averages/*/*_1.avg`){
	
	chop($f);
	
	$target = $f;
	($distract = $f) =~ s/_1/_2/;
	($common   = $f) =~ s/_1/_3/;
	print "$target\n";
		
	($tdif = `basename $f`) =~ s/_1.avg/_1-3.dat/;
	system("avg-subtract.exe $target $common scan > $tdif");
	
	($ddif = `basename $f`) =~ s/_1.avg/_2-3.dat/;
	system("avg-subtract.exe $distract $common scan > $ddif");
}
