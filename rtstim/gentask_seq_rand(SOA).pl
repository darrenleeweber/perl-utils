#! /usr/bin/perl

$n = 1;

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

  $d[0] = $n++;

  # to create random ISI between a and b, use next command
  # $d[4] = rand() * (b - a) + a
  
  # Note that $d[2] is stimulus duration
  #           $d[3] is response window maximum
  #           $d[4] is SOA/ISI

  $d[4] = rand() * (2.1 - 1.9) + 1.9;

#  $d[2] = $d[4] + 0.2;    $d[3] = 2;

  if($d[4] =~ /ASAP/){
    $~ = "TEXT";		# set format for STDOUT to TEXT
  } else {
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
$d[0], $d[1], $d[2], $d[3], $d[4], $d[5], $d[6], $d[7], $d[8], $d[9]
.
