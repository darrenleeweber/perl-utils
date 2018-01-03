#! /usr/bin/perl

###########################################################
# row2col.pl
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
  if(/-c/){ shift; $cols = shift; }
  if(/-h/){ shift; &HELP; }
}

if($file){
	
  # read input and determine number of rows & columns
  $row = 0; $col = 0;
  open( F, "< $file" ) || die "Can't open $file\n";
  while(<F>){
    s/^\s+//; # remove leading spaces
    $data{$row} = $_; # store data in hash for later access

    # determine number of columns from first row of file
    if($row < 1){ &COLS; }
    $row++;
  }
  close(F);

  print STDERR ";;;\trow2col.pl processing $row rows, $col columns\n";

  # transpose row/column to column/row hash
  &TRANSPOSE;
  
  # Ouput transposed hash
  for($c = 0; $c < $col; $c++){ print "$columns{$c}\n"; }
  
} else {
  &HELP;
}

###############################################################################
sub TRANSPOSE{
  for($c = 0; $c < $col; $c++){
    for ($r = 0; $r <= $row; $r++){
      
      @v = split(/\s+/,$data{$r});
      
      $columns{$c} .= "$v[$c] "; # space delimited format
    }
  }
}

sub COLS{
  @row = split;
  foreach $c (@row){
    if($cols){
      if($col < $cols){ $col++; } # process only $cols columns
    } else {
      $col++;
    }
  }
}

sub HELP {
	die	"\a\nUSEAGE: row2col.pl -f <file.txt> -c <cols> [-help]\n\n",

		"transpose text data matrix.\n\n",

		"-f <file.txt>\tASCII text file, space delimited, data only,\n",
		"-c <cols>\tOnly process <cols> columns of input file.\n\n";
}
	
	
	
