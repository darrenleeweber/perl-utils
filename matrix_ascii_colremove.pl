#! /usr/bin/perl

###########################################################
# matrix_ascii_colremove.pl
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
  if(/-c/){ shift; $colrm = shift; }
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
    if($row < 1){
      @row = split;
      foreach $x (@row){ $col++; }
    }
    $row++;
  }
  close(F);

  print STDERR ";;; colrm.pl processing $row rows, $col columns\n";
  
  # Remove columns in $colrm
  &REMOVE;

  # Ouput new hash
  for($r = 0; $r < $row; $r++){ print "$rows{$r}\n"; }
  
} else {
  &HELP;
}

###############################################################################
sub REMOVE{
  
  @colrm = split(',',$colrm);           # define remove columns array
  
  for ($r = 0; $r <= $row; $r++){       # loop over rows of data matrix
    
    @r = split(/\s+/,$data{$r});        # split row vector into array
    
    $count = 1;
    foreach $c (@r){
      $skip = 0;
      foreach $colrm (@colrm){          # check each column for exclusion
	if($count == $colrm){ $skip = 1; }  # skip any excluded columns
      }
      unless($skip){ $rows{$r} .= "$c "; }   # space delimited format
      $count++;
    }
  }
}

sub HELP {
  die	"\a\nUSEAGE: matrix_ascii_colremove.pl -f <file> -c <c1[,c2,...,cn]> [-help]\n\n",
        "Removes column(s) of data from a text data matrix.  Assumes white\n",
        "space delimited text input.  Output to STDOUT.\n\n",
        "Column numbers begin at 1!\n\n";
}
