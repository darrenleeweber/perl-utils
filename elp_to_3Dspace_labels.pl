#! /usr/local/bin/perl

# This script extracts x,y,z values from an elp file
# and creates a formated output capable of being imported into
# 3d space

#####################################################
# Input from STDIN

$n = 0;

while(<>){

  # Exclude first 2 lines of EMSE filetype code
  $n++;  if($n < 3){ next; }

  # Identify input data type
  if(/nsensors/i){ $nsensors = "y"; next; }
  if(/%S/i){ $state = "y"; next; }
  if(/%N/i){ @d = split(/\s+/, $_); $name = $d[1]; next; }

  # Extract input data by data type
  if($nsensors){ @d = split(/\s+/, $_); $sensors = $d[1]; $nsensors = ""; next; }
  if(/%F/){
  	$fm++;
    if($fm == 1){
    	@d = split(/\s+/, $_); $name = "Nasion"; $code = 110;
		printf "%10s\t%3d\t%10.6f\t%10.6f\t%10.6f\n",$name,$code,($d[2] * -100),($d[1] * 100),($d[3] * 100);
	}
    elsif($fm == 2) {
        @d = split(/\s+/, $_); $name = "Left"; $code = 108;
        printf "%10s\t%3d\t%10.6f\t%10.6f\t%10.6f\n",$name,$code,($d[2] * -100),($d[1] * 100),($d[3] * 100);
	}
    elsif($fm == 3){
        @d = split(/\s+/, $_); $name = "Right"; $code = 114;
        printf "%10s\t%3d\t%10.6f\t%10.6f\t%10.6f\n",$name,$code,($d[2] * -100),($d[1] * 100),($d[3] * 100);
	}
	next;
  }
  if($name){
    @d = split(/\s+/, $_); $code = 69;
    printf "%10s\t%3d\t%10.6f\t%10.6f\t%10.6f\n",$name,$code,($d[1] * -100),($d[0] * 100),($d[2] * 100);
	$name = "";
	next;
  }
}
