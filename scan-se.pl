#!/usr/bin/perl

$nth = 1;
$sefile = "sevalues";

while (<@ARGV>) {
  if (/-f/)  { shift; $sefile = shift; }
  if (/-p/)  { shift; $print  = "y";   }
  if (/-h/){
    die "\n","SCAN-SE [-f <file>] [-p]\n\n",
             "SCAN-SE accepts a text file with a column of electrodes\n",
             "followed by columns of voltage values (the usual output of\n",
             "SCAN-EXPORT) and calculates surface energy values for every\n",
             "second time slice of the input.  It will print surface energy\n",
             "values to the standard output if you specify the -p option or\n",
             "a file specified by -f <file> (default is 'sevalues').\n\n";
  }
}

$dir = `pwd`;
system "pushd $dir";

# create binary electrode co-ordinate table > _elec.tbl
unless (-s "_elec.tbl"){ system "tbcat /users/psdlw/bin/elec.dat | tbcolrm -f 1 | tbscanelec -radius 1000 | tbrot | tbmul -k 0.007 > _elec.tbl"; }

$tmp1 = "tmp1.$$";
open(TMP1, ">>$tmp1") || die "\n","Sorry, couldn't open TMP1\n\n";
while (<>) { print TMP1 ; }
close(TMP1);

$tmp2 = "tmp2.$$";
system "tbcat $tmp1 | tbrot | tbtext > $tmp2";

if (-s "$sefile"){ system "rm $sefile"; }

open(TMP2, "$tmp2") || die "Sorry, couldn't open TMP2\n\n";
while (<TMP2>) {
  $n++; if ($n == 1){ @electrodes = split(/\s+/); }
  $pass = $n;
  unless((chop $pass) =~ /[13579]/){
    open(TBSE, "| tbcat | tbmul -k -1 | tbcat -bin _elec.tbl - | tbmapint -surface -m 3 -omega2 0.5 -radius -1 -quiet | tbtext -f r >> $sefile" ) || die "\n","Sorry, couldn't open TBSE\n\n";
    print TBSE;
    close(TBSE);
  }
}
close(TMP2);

system "rm $tmp1";
system "rm $tmp2";

if ($print){
  open(SEVALUES,"$sefile") || die "\n","Sorry, couldn't open SEVALUES\n\n";
  while (<SEVALUES>){ print; }
  close(SEVALUES);
}

system "popd";
