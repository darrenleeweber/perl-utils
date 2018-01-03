#! /usr/bin/perl

$cv = 50;

$wd = `pwd`;

while(<@ARGV>){
  if (/-cv/)   { shift; $cv = shift; }
  if (/-wd/)   { shift; $wd = shift; }
  if (/-h/)    { &HELP; }
}

chdir "$wd";

foreach $f (`ls *.var`){
  chop($f); $e = "";
  open(VAR, "$f") || die "\nCan't open VARIANCE file $f\n\n";
  while (<VAR>){
    @v = split;
    if($v[2] > $cv){ $e .= "$v[0] "; }
  }
  printf "%-10s ", $f;
  foreach $v (split(/\s+/,$e)){ printf "%4d",$v; }
  print "\n";
}


sub HELP {
  print "\a\nSORT_VAR\n\n",

  "sort_var -cv <x> -wd <path> [-h]\n\n",

  "-cv <x>    Specifies a critical value (default is 50)\n",
  "-wd <path> Specifies a directory where *.var files can be found.\n",
  "           The default is the current directory (pwd).\n\n",

  "sort_var will scan *.var files created by the scan-variance utility\n",
  "for variance values that exceed a critical value (default > 50)\n",
  "and report the electrodes with excessive variance.\n\n";

  exit 1;
}
