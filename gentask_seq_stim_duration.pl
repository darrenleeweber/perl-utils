#! /usr/bin/perl

while(<>){
  $n++;
  if($n == 1){

    @v = split;
    $v[2] = "2.0"; $v[4] = "3.00";
    printf "%5s %4s %8s %6s %7s %4s %4s %4s %4s %8s\n", $v[0], $v[1], $v[2], $v[3], $v[4], $v[5], $v[6], $v[7], $v[8], $v[9];

  } elsif ($n == 2) {

    @v = split;
    $v[2] = "2.0"; $v[4] = "ASAP";
    printf "%5s %4s %8s %6s %7s %4s %4s %4s %4s %8s\n", $v[0], $v[1], $v[2], $v[3], $v[4], $v[5], $v[6], $v[7], $v[8], $v[9];

  } elsif ($n == 3) {

    @v = split;
    $v[2] = "2.0"; $v[4] = "ASAP";
    printf "%5s %4s %8s %6s %7s %4s %4s %4s %4s %8s\n", $v[0], $v[1], $v[2], $v[3], $v[4], $v[5], $v[6], $v[7], $v[8], $v[9];

  } elsif ($n == 4) {

    @v = split;
    $v[4] = "4.00";
    printf "%5s %4s %8s %6s %7s %4s %4s %4s %4s %8s\n", $v[0], $v[1], $v[2], $v[3], $v[4], $v[5], $v[6], $v[7], $v[8], $v[9];

  } else {
    print;
  }
}
