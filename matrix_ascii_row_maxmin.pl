#! /usr/bin/perl

while(<@ARGV>){
  if(/-h/){ &HELP; }
}

while (<>){

  @points = split; $min = 1000000; $max = -1000000;

  foreach $p (@points){

    if($p < $min){ $min = $p; }
    if($p > $max){ $max = $p; }

  }
  print "max = $max\t\tmin = $min\n";
}

sub HELP {
  print "\nDetermines max and min values for each input row.\n\n",

        "STDIN should be ascii data separated by whitespace.\n",
        "Output to STDOUT.\n\n";

  exit;
}
