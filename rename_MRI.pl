#! /usr/bin/perl

while (<@ARGV>){
  if(/-p/){ shift; $p = shift; }
  if(/-s/){ shift; $s = shift; }
}

unless($p && $s){ die "\n\nUSEAGE: ren_MRI -p <fileprefix> -s <filesuffix>\n\n"; }

foreach $f (`ls ${p}???.$s`){
  chop($f); ($n = $f) =~ s/$p//; $nf = "${p}0$n";
  print "Moving $f $nf\n";  system "mv $f $nf";
}

foreach $f (`ls ${p}??.$s`){
  chop($f); ($n = $f) =~ s/$p//; $nf = "${p}00$n";
  print "Moving $f $nf\n";  system "mv $f $nf";
}

foreach $f (`ls ${p}?.$s`){
  chop($f); ($n = $f) =~ s/$p//; $nf = "${p}000$n";
  print "Moving $f $nf\n";  system "mv $f $nf";
}
