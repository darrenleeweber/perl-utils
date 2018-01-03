#! /usr/bin/perl

###########################################################
# matrix_ascii_size.pl
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
	if(/-h/){ shift; &HELP;	}
}

$row = 0; $col = 0;

if($file){
  open( F, "< $file" ) || die "Can't open $file\n";
} else {
  open( F, "<&=STDIN") || die "Can't alias STDIN\n";
}

# read input and determine number of rows & columns
while(<F>){
  if($row < 1){
    @values = split;
    foreach $v (@values){ $col++; }
  }
  $row++;
}
close(F);

print STDERR ";;;\t$row rows, $col columns\n";


########################################################################
sub HELP {
	die	"\a\nUSEAGE: matrix_ascii_size.pl -f <file.txt> [-help]\n\n",

		"determines rows & columns in text data file.  If no -f option\n",
	        "given, assumes STDIN (but -f is faster).  All output to STDERR.\n\n";
}
