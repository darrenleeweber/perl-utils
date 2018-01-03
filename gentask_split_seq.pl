#! /usr/bin/perl

$mode = "PCX";
$dur  = "0.3";  $win  = "1.0";
$xpos =   "0";  $ypos =   "0";
$resp =  "-1";  $type =  "99";

srand;

while(<>){
  $e++;

  if(-s "s$e.seq"){ system "rm s$e.seq"; }
  open(SEQ, ">> s$e.seq") || die "Can't open SEQ output\n\n";

  @seq = split;

#  $n = 0;
#  foreach $v (@seq){ unless ($v > 0){ $n++; } }
#  print SEQ "Numevents $n\n",
#  "event mode duration window SOA/ISI xpos ypos resp type filename\n",
#  "----- ---- -------- ------ ------- ---- ---- ---- ---- --------\n";

  $n = 0;
  foreach $v (@seq){
    unless ($v > 0){
      $n++;
      $SOA = rand(0) * (1.5 - 1.7) + 1.7;
      write SEQ;
    }
  }
  close(SEQ);
}
format SEQ =
@>>>> @>>> @#####.# @>>>>> @###.## @>>> @>>> @>>> @>>> @<<<<<<<
 $n, $mode, $dur, $win, $SOA, $xpos, $ypos, $resp, $type, $v
.
