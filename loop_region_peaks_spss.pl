#! /usr/bin/perl -w

use strict;
use diagnostics;

while(<@ARGV>){
  if(/-comp/) { shift; $::comp = shift; }
  if(/-exp/)  { shift; $::exp = shift; }
  if(/-con/)  { shift; $::con = shift; }
  if(/-dpath/){ shift; $::datapath = shift; }
  if(/-spath/){ shift; $::scriptpath = shift; }
  if(/-neg/)  { shift; $::neg = "yes"; }
  if(/-pos/)  { shift; $::pos = "yes"; }
  if(/-h/)    { &HELP; }
}

#########################################################
# Declarations

$::spssprodCMD = "/c/progra~1/spss/spssprod.exe -s";

unless($::scriptpath){
  $::scriptpath = "/d/MyDocuments/programming/perl/";
}
unless($::datapath){
  $::datapath = "/d/data_emse/ptsdpet/scd14hz/";
}

#########################################################
#MAIN

if ($::neg) {
  @::attrib = ("neg_amp","neg_lat");
} elsif ($::pos) {
  @::attrib = ("pos_amp","pos_lat");
} else {
  @::attrib = ("pos_amp","pos_lat","neg_amp","neg_lat");
}

%::uppercase = ("a","A","b","B","c","C","d","D","e","E","f","F","g","G","h","H","i","I","j","J","k","K","l","L","m","M","n","N","o","O","p","P","q","Q","r","R","s","S","t","T","u","U","v","V","w","W","x","X","y","Y","z","Z");

$::pwd = `pwd`; chop($::pwd);
if($^O =~ /win/){
  if($::pwd =~ /^\/cygdrive/){
    $::pwd =~ s/^\/cygdrive\///;
    $::pwd =~ s/(^.)/$1:/;
  }
  if($::pwd =~ /\//){
    $::pwd =~ s/\//\\/g;
  }
  ($::pwdos = $::pwd) =~ s/(^[a-z])/$::uppercase{$1}/;
  if($::datapath =~ /^\//){
    $::datapath =~ s/^\///;
    $::datapath =~ s/(^.)/$1:/;
  }
  if($::datapath =~ /\//){
    ($::datapathDOS = $::datapath) =~ s/\//\\/g;
    $::datapathDOS =~ s/(^[a-z])/$::uppercase{$1}/;
  }
  $::nl = "\r\n";
} else {
  $::nl = "\n";
}

@::localtime = localtime(time);
#($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)
$::mday = $::localtime[3];
$::mon  = $::localtime[4] + 1;
$::year = $::localtime[5] + 1900;
$::year =~ s/^..//;


foreach $::a (@::attrib){

  # SPSS data filenames
  $::expSAV = join("", "all_", $::comp, "_", $::exp, "_", $::a, ".sav");
  $::conSAV = join("", "all_", $::comp, "_", $::con, "_", $::a, ".sav");

  # SPSS syntax files (created by region_peaks_collate.pl)
  $::expSPS = join("", "all_", $::comp, "_", $::exp, "_", $::a, ".sps");
  $::conSPS = join("", "all_", $::comp, "_", $::con, "_", $::a, ".sps");

  # Create merge SPSS syntax file to combine exp and con data files
  $::spssmergeSAV = join("", "all_", $::comp, "_", $::a, "_merge.sav");
  $::spssmergeSPS = join("", "all_", $::comp, "_", $::a, "_merge.sps");
  open(SPSSMERGE,">$::datapath$::spssmergeSPS") || die "Cannot open $::spssmergeSPS\n";
  print SPSSMERGE "MATCH FILES$::nl";
  if($^O =~ /win/){
    print SPSSMERGE " /FILE='$::datapathDOS$::expSAV'$::nl";
    print SPSSMERGE " /FILE='$::datapathDOS$::conSAV'$::nl";
  } else {
    print SPSSMERGE " /FILE='$::datapath$::expSAV'$::nl";
    print SPSSMERGE " /FILE='$::datapath$::conSAV'$::nl";
  }
  print SPSSMERGE " /RENAME (data subjects = d0 d1)$::nl";
  print SPSSMERGE " /DROP= d0 d1.$::nl";
  print SPSSMERGE "EXECUTE.$::nl";
  if($^O =~ /win/){
    print SPSSMERGE "SAVE OUTFILE='$::datapathDOS$::spssmergeSAV' /COMPRESSED.$::nl";
  } else {
    print SPSSMERGE "SAVE OUTFILE='$::datapath$::spssmergeSAV' /COMPRESSED.$::nl";
  }
  close(SPSSMERGE);

  #############################
  # Create SPSS production file
  $::spssprod = join("", "all_", $::comp, "_", $::a, ".spp");
  open(SPSSPROD, ">$::spssprod") || die "Cannot open $::spssprod\n";

  print SPSSPROD "*Creator/owner: anybody.$::nl";
  print SPSSPROD "*Date: $::mday/$::mon/$::year.$::nl$::nl";
  if($^O =~ /win/){
    print SPSSPROD "INCLUDE FILE='$::pwdos\\$::expSPS'.$::nl";
    print SPSSPROD "INCLUDE FILE='$::pwdos\\$::conSPS'.$::nl";
    print SPSSPROD "INCLUDE FILE='$::pwdos\\$::spssmergeSPS'.$::nl$::nl";
  } else {
    print SPSSPROD "INCLUDE FILE='$::pwd/$::expSPS'.$::nl";
    print SPSSPROD "INCLUDE FILE='$::pwd/$::conSPS'.$::nl";
    print SPSSPROD "INCLUDE FILE='$::pwd/$::spssmergeSPS'.$::nl$::nl";
  }
  print SPSSPROD "*Comments:.$::nl";
  print SPSSPROD "* .$::nl$::nl";
  print SPSSPROD "*Output Folder: $::pwd.$::nl";
  print SPSSPROD "*Exported Chart Format: JPEG File.$::nl";
  print SPSSPROD "*Exported File Format: 0.$::nl";
  print SPSSPROD "*Export Objects: 3.$::nl";
  print SPSSPROD "*Output Type: 0.$::nl";
  print SPSSPROD "*Print output on completion: Off.$::nl$::nl";

  close(SPSSPROD);
  print STDERR ";;;\tCreated SPSS production file in $::spssprod\n";

  # create .sav file with production automation file
  system("$::spssprodCMD $::spssprod");
}
exit;


sub HELP {
print STDERR <<HELP;

USEAGE: loop_region_peaks_spss.pl -options

  -comp		component string (eg, n80)
  -exp		experimental condition string
  -con		control condition string
  -dpath	datapath
  -spath	perl script path
  -neg		process only negative peaks
  -pos		process only positive peaks
  -h		this

  This script can be run after the loop_region_peaks.pl
  script, provided that script is run with the -spss option
  for the region_peaks_collate.pl script.

HELP
exit;
}
