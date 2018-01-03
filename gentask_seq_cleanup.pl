#! /usr/bin/perl

LINE: while(<>){

  if(/Num/){ $n = 1; print; next LINE; }

  if(/event/){
    @d = split;
    printf "%5s %4s %8s %6s %7s %4s %4s %4s %4s %8s\n", $d[0], $d[1], $d[2], $d[3], $d[4], $d[5], $d[6], $d[7], $d[8], $d[9];
    next LINE;
  }

  if(/--/){
    foreach $field (0..9){ $d[$field] =~ s/\S/-/g; }
    printf "%5s %4s %8s %6s %7s %4s %4s %4s %4s %8s\n", $d[0], $d[1], $d[2], $d[3], $d[4], $d[5], $d[6], $d[7], $d[8], $d[9];
    next LINE;
  }

  @d = split;

  if(/^\s+PCX/ || /ASAP/){
    $n++;
    $~ = "TEXT";		# set format for STDOUT to TEXT
  } else {
    $d[0] = $n++;
    $~ = "DIGITS";		# set format for STDOUT to DIGITS
  }
  write;
}

format DIGITS =
@>>>> @>>> @#####.# @>>>>> @###.## @>>> @>>> @>>> @>>> @<<<<<<<
$d[0], $d[1], $d[2], $d[3], $d[4], $d[5], $d[6], $d[7], $d[8], $d[9]
.

format TEXT =
@>>>> @>>> @#####.# @>>>>> @>>>>>> @>>> @>>> @>>> @>>> @<<<<<<<
$n, $d[0], $d[1], $d[2], $d[3], $d[4], $d[5], $d[6], $d[7], $d[8]
.
