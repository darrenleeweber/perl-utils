#! /usr/local/bin/perl

###########################################################
# rowXcol.pl
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
	if(/-h/){ shift; &HELP;	}
}


if($file){
	
    # read input and determine number of rows & columns
    $row = 0; $col = 0;
	open( F, "< $file" ) || die "Can't open $file\n";
	while(<F>){
          $data{$row} = $_;
          if($row < 1){
              @values = split;
              foreach $v (@values){ $col++; }
          }
          $row++;
	}
	close(F);

    print STDERR ";;;\trowXcol.pl found      $row rows, $col columns\n";
	
} else {
	&HELP;
}

sub HELP {
	die	"\a\nUSEAGE: rowXcol.pl -f <file.txt> [-help]\n\n",

		"determines rows & columns in text data file.\n\n";
}
