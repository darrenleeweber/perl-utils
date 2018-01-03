#! /usr/bin/perl

###########################################################
# row_order.pl
#
# Author: Darren Weber (2000) <darrenlweber@hotmail.com>
#
# See help section below for useage.
#
# Use this code as you will, anytime, anywhere, in good 
# faith.  There are no implied warranties or guarantees 
# in the provision of this code.
# See gnu GPL for more details (www.gnu.org).
###########################################################


while(<@ARGV>){
  if(/-f/){ shift; $file = shift; }
  if(/-h/){ shift; &HELP; }
}

if($file){
	
  open( F, "< $file" ) || die "Can't open $file\n";
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

} else {
  &HELP;
}

###############################################################################

sub HELP {
	die	"\a\nUSEAGE: row_order.pl -f <file.txt> [-help]\n\n",

		"This is a bizzare little script that helps to determine what\n",
		"electrodes have the largest to smallest values at any time point.\n",
		"It assumes that input will be a text file with columns of ordered\n",
		"electrodes and rows of ordered time points (hope you know what I mean).\n\n",

		"The script orders the input row values and outputs their column\n",
		"number in ascending order.\n\n",

		"-f <file.txt>\tASCII text file, space delimited, data only.\n\n";
}
	
	
	
