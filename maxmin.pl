#! /usr/bin/perl

while (<>){

  @points = split; $min = 1000000; $max = -1000000; $n = 0;

  foreach $p (@points){

    if($p < $min){ $min = $p; }

    if($p > $max){ $max = $p; }

  }

  print "max = $max     min = $min\n";

}
