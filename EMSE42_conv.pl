#! /usr/bin/perl

# get arguments
while (<@ARGV>) {
  if (/-h/)   { &HELP; }
}

# convert input file from DOS to UNIX ASCII format
$input = "input.$$";
system "tr -d '\r' > $input";

# store voltage values only in tmp1
$tmp1 = "tmp1.$$";
open(TMP1, ">> $tmp1") || die "\nEMSE_conv: can't open $tmp1\n\n";
open(INPUT, "$input") || die "\n","EMSE_conv: can't open INPUT\n\n";
while(<INPUT>){
  unless(/^\s+/){
    $x++;
    if($x == 3){ @dat = split; $nelec = $dat[1]; }

    if( ($x > 4) && ($x <= ($nelec + 4)) ) {
      $elabel++; @edat = split;
      push(@elec,$edat[0]);	# get electrode labels
    } elsif ( $x > ($nelec + 4) ){
      print TMP1;		# output voltage data
    }
  }
}
close(INPUT); system "rm $input"; close(TMP1);

# multiply voltage values by 1 million and store in tmp2
$tmp2 = "tmp2.$$";
system "tbcat $tmp1 | tbrot | tbmul -k 1000000 | tbtext -f f %14.8f > $tmp2";
system "rm $tmp1";

# output voltage values in ASCII format
# according to numeric order of electrodes
$n = 0;
open(TMP2,"$tmp2") || die "\nEMSE42_conv: can't open $tmp2\n\n";
while(<TMP2>){
  $dat{$elec[$n]} = $_;
  $n++;
}
close(TMP2); system "rm $tmp2";

foreach $e (sort {$a <=> $b} keys %dat){
  unless($e <= 0){		# Ignore Alphabetic $e
    print " \"$e\" $dat{$e}";
  }
}


sub HELP {
  print "\n\aEMSE_conv [-help]\n\n",

      "This routine converts an average file from EMSE into a\n",
      "series of ASCII values, with numeric electrodes in rows (by\n",
      "ascending numeric order, eg 1..124) and time points in columns,\n",
      "which can be input into tbcat to create table files.\n\n",

      "The input is ASCII text from EMSE *.avg files on the standard\n",
      "input and the output is ASCII compatible with tbutilities on the\n",
      "standard output.\n\n",

      "For example:\n\n",

      "cat EMSE.AVG | EMSE_conv | tbcat > EMSE.tbl\n\n",

      "    creates a TABLE file called EMSE.tbl\n\n",

      "cat EMSE.AVG | EMSE_conv > EMSE.dat\n\n",

      "    creates an ASCII file called EMSE.dat\n\n",

      "Note that voltage values from EMSE are multiplied by 1 million\n",
      "to provide microvolt values rather than volt values.\n\n",

      "LIMITATION: Electrodes are sorted in numeric order and any\n",
      "electrodes with an alphabetic label are ignored.  Please\n",
      "contact PSDLW, if you have a problem with that.\n\n";
  exit;
}
