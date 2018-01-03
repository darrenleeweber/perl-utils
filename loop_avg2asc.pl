#! /usr/bin/perl

# This script runs under a dos window to convert all .avg files
# in $datapath into ascii files, using the avg2asc utility. Change to the
# datapath directory and run the following command:
# perl D:\MyDocuments\programming\perl\loop_avg2asc.pl

$datapath = "D:\\MyDocuments\\research\\ptsdtwin\\avg\\14hz_lowpass";
$avg2asc  = "C:\\cygwin\\usr\\local\\bin\\avg2asc.exe ";

chdir($datapath);

use File::Find;
find(\&files, $datapath);		# Find all files in $datapath

sub files {

	unless(/.avg/){ return; }

	$f = $_;
	
	($out = $f) =~ s/.avg/.txt/;
	
	print "Converting $_ to ascii file $out\n";

	system("$avg2asc $f row > $out");
}
