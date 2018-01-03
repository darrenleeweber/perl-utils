#! /usr/bin/perl

$out = "trials.txt";
if(-e "$out"){ system "rm $out"; }

foreach $f (`ls averages/*/*.avg`){
	
	chop($f);
	
	print "$f\n";
	system("avg2trials.exe $f >> $out");
		
}
