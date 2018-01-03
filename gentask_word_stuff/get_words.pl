#! /usr/bin/perl

# Lets get the words first, from "wdgroups.txt"

$r = 1;			# run number
$wdp = 9;			# number of words per task + 1
$n = 0;

open(WDGRP, "wdgroups.txt") || die "Can't open wdgroups.txt\n\n";
while(<WDGRP>){
  @row = split;
  $pos = 1;
  foreach $wd (@row){
    $i = "${r}_${pos}";
    $wds{$i} .= "$wd "; $pos++; 
  }
  $n++; if($n == $wdp){ $r++; $n = 0; }
}
close(WDGRP);


# O.K., now lets create some output in the right manner

while(<@ARGV>){
  if(/-r/)     { shift; $r = shift; } # This defines the run number
  if(/-t/)     { shift; $t = shift; } # This defines the task number
}

$i = "${r}_$t";			# index for words of row $r and task $t

#foreach $t (1..4){
#  printf "%8s \n", $wds{$i};
#}
#print "\n";

@wds = split(/\s+/, $wds{$i});

$A = $wds[0];
$B = $wds[1];
$C = $wds[2];
$D = $wds[3];
$m = $wds[4];
$n = $wds[5];
$o = $wds[6];
$p = $wds[7];

while(<>){
  if   (/\bA\b/){ s/\bA\b/u$A/ && print; }
  elsif(/\bB\b/){ s/\bB\b/u$B/ && print; }
  elsif(/\bC\b/){ s/\bC\b/u$C/ && print; }
  elsif(/\bD\b/){ s/\bD\b/u$D/ && print; }
  elsif(/\bm\b/){ s/\bm\b/l$m/ && print; }
  elsif(/\bn\b/){ s/\bn\b/l$n/ && print; }
  elsif(/\bo\b/){ s/\bo\b/l$o/ && print; }
  elsif(/\bp\b/){ s/\bp\b/l$p/ && print; }
  else          {                 print; }
}
