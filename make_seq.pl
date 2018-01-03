#! /usr/bin/perl

while (<@ARGV>){
  if(/-f/){ shift; $seqfile=shift; }
}

unless($seqfile){
  print "\n\nUSEAGE: make.seq -f <file>\n\n";
  exit;
}

$tmp = "temp.$$";
system "mv $seqfile $tmp";

open(SEQ, ">> $seqfile") || die "Can't open SEQ output file\n\n";

print SEQ "Numevents ???\n";
print SEQ "event mode duration window SOA/ISI xpos ypos resp type filename\n";
print SEQ "----- ---- -------- ------ ------- ---- ---- ---- ---- --------\n";

$event = 0;
$mode = "PCX";
$dur = "0.2";
$win = "1.0";
$soa = "2.0";
$xpos = "0.0";
$ypos = "0.0";
$resp = "1";
$type = "0";
$file = "";

open(TMP, "$tmp") || die "Can't open $tmp which is a copy of $seqfile\n\n";
while(<TMP>){
  $event++; @v = split;

  $type = $v[0]; $file = $v[1];

  printf SEQ "%5s %4s %8s %6s %7s %4s %4s %4s %4s %-8s\n", $event, $mode, $dur, $win, $soa, $xpos, $ypos, $resp, $type, $file;
  
}
close(SEQ);
close(TMP); system "rm $tmp";










