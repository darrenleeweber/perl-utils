#!/usr/local/bin/perl

$dir = `pwd`;
system "pushd $dir";

while (<@ARGV>){
  if (/-c/) { shift; $complete = "y"; }
  if(/-values/){ $v_only = "yes", shift; }
  if (/-h/) { &HELP; }
}

$input = "input.$$";
system "tr -d '\r' > $input";

open (INPUT, "$input") || die "\n","Sorry, couldn't open INPUT\n\n";
MATCH: while (<INPUT>) {
  if (/^Standard deviation values/){
    $sd = "yes"; next MATCH;
  }
  if($sd){
    
    s/\'//g;  @val = split;

    if($complete){

      ($values{$val[0]} = $_) =~ s/^............//; # remove first 12 characters

    } else {

      $n = 0; $min = 1000000; $max = -1000000;
      foreach $v (@val){
	unless($n == 0){
	  if($min > $v){ $min = $v; }
	  if($max < $v){ $max = $v; }
	}
	$n++;
      }
      $min{$val[0]} = $min;
      $max{$val[0]} = $max;
    }
  }
}
close(INPUT); system "rm $input";

if($complete){

  foreach $k (sort {$a <=> $b} keys %values){
    
    if($k =~ /\d/g){   # include only digits in output (digit \d).
      unless($v_only){ printf "\"%10d\"", $k; }
      @vals = split(/\s+/, $values{$k});
      shift(@vals); # remove first value (zero - not sure why???)
      foreach $v (@vals){
	printf "%10.4f", $v;
      }
      print "\n";
    } else {
      print STDERR "\n$k excluded from STDOUT\n\n";
    }
  }

} else {

  foreach $k (sort {$a <=> $b} keys %min){
    printf "\"%15s\" %10.4f %10.4f\n",$k,$min{$k},$max{$k};
  }
}

system "popd";

sub HELP {
  print "\n\a", "SCAN-VARIANCE\n\n",
  "Usage: scan-variance [-c][-h]\n\n",

  "-c             will print a complete set of variance values for\n",
  "               electrodes 1..128 or x1..x2.\n",
  "-h             specifies this help information.\n\n",

  "SCAN-VARIANCE accepts a text file (*.dat) created by the ASCII-EXPORT\n",
  "command (in which you must specify ROWS=elect and VARIANCE on) of the\n",
  "STATS module of SCAN. It scans the *.dat file for variance values and\n",
  "reports the max/min value for each electrode (unless -c option specified).\n",
  "This information can be used to identify bad electrodes, since bad\n",
  "electrodes may have extremely small or large variation.\n\n";

  exit 1;
}
