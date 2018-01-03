#! /usr/bin/perl

###########################################################
# matrix_ascii_max_column_order.pl
#
# Author: Darren Weber (2000) <darrenlweber@hotmail.com>
#
# See help section below for useage.
#
# There are no implied warranties or guarantees 
# in the provision of this code. See gnu GPL (www.gnu.org).
###########################################################


while(<@ARGV>){
  if(/-f/){ shift; $file = shift; }
  if(/-h/){ shift; &HELP; }
}

if($file){
  open( F, "< $file" ) || die "Can't open $file\n";
} else {
  open( F, "<&=STDIN") || die "Can't alias STDIN\n";
}

while(<F>){
  s/^\s+//;		# remove leading spaces
  @data = split;	# split data into array
  $n = 0; %data = {};
  foreach $d (@data){
    $n++;
    $data{$d} = $n;	# associate data value $d with column number $n
  }

  foreach $d (sort {$a<=>$b} @data){
    print "$data{$d} ";
  }
  print "\n";
  
}
close(F);


###############################################################################

sub HELP {
	die	"\a\nUSEAGE: matrix_ascii_max_column_order.pl -f <file.txt> [-help]\n\n",

		"This script helps to determine what electrodes have the largest\n",
	        "to smallest values at any time point of EEG data.\n\n",

		"Input is a text file with columns of ordered electrodes and rows\n",
	        "of ordered time points.\n\n",

		"Output is the same size as the input matrix.  Each row comprises\n",
	        "column numbers corresponding to the ascending row values of the\n",
	        "input.\n\n",

		"-f <file.txt>\tASCII text file, space delimited, data only.\n",
	        "             \twithout -f, assumes STDIN.  All output to STDOUT.\n\n";
}
	
	
	
