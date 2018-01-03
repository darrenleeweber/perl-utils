#! /usr/bin/perl -w

srand;				# Set random number generator
$ftype = "*.*";			# Set file type to all files/directories

$cd = `pwd`; chop($cd); chdir "$cd"; # Move to current directory

while (<@ARGV>){
  if(/-ftype/){ shift; $ftype = shift; }
}

$n = 0;
foreach $f (`ls $ftype`){ chop($f); $a[$n] = $f; $n++; }

$n = 0;
while ($n < @a){ print "$a[rand(@a)]\n"; $n++; }

