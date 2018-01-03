#! /usr/bin/perl -w

use strict;
use diagnostics;

while(<@ARGV>){
    if(/-force/){ shift; $::force = "yes"; }
    if(/-comp/) { shift; $::comp = shift; }
    if(/-file/) { shift; $::files = shift; }
    if(/-neg/)  { shift; $::neg = "yes"; }
    if(/-pos/)  { shift; $::pos = "yes"; }
    if(/-spss/) { shift; $::spss = "yes"; }
    if(/-h/)    { &HELP; }
}

unless($::comp){ &HELP; }

#########################################################
# Declarations

$::scriptpath = "/d/MyDocuments/programming/perl/";
$::datapath = "/d/data_emse/ptsdpet/scd14hz/";

$::area = join("", $::datapath, "region_$::comp.area");

unless($::files){
  $::files = "oac_ouc_scd14hz.dat";	# define filename matching expression
  $::orig = ".dat";			# original input filename extension
} else {
  $::files =~ /(\.\w+)/;		# original input filename extension
  $::orig = $1;
}
$::repl = "_dif_$::comp.peaks";	       	# replacement output filename extension
$::lat = "";				#"-lat_range 20"; # limit control condition latency

#########################################################
#MAIN

$::foundfiles = "no";
use File::Find;
find(\&files, $::datapath);		# Find all files in $::datapath


if ($::foundfiles eq "yes") {

  ($::file = $::repl) =~ s/.peaks//;

  if ($::neg) {
    @::attrib = ("neg_amp","neg_lat","neg_el");
  } elsif ($::pos) {
    @::attrib = ("pos_amp","pos_lat","pos_el");
  } else {
    @::attrib = ("pos_amp","pos_lat","pos_el","neg_amp","neg_lat","neg_el");
  }
  $::script = join("",$::scriptpath, "region_peaks_collate.pl");

  foreach $::a (@::attrib){

    $::outfile = join("", "all", $::file, "_", $::a, ".txt");
    $::command = "$::script -files $::file -path $::datapath -cond oac_ouc -attrib $::a -output $::outfile -notime -addcond";
    if($::spss && !($::a =~ /el/)){ $::command .= " -spss"; }
    system("perl $::command");
    if($::spss && !($::a =~ /el/)){ &SPSS; }
  }
} else {
  print STDERR ";;; No files matching '$::files' found in $::datapath\n";
}
exit;


###############################################################################
sub files {

  # Only process filenames matching $::files
  if (/$::files/) {

    $::foundfiles = "yes";

    $::input = $::_;

    # create output filename, based on input filename
    ($::output = $::input) =~ s/$::orig/$::repl/;

    # Check the last modification time of the output file
    @::stat = stat("$::datapath$::output");
    $::modtime = $::stat[9];
    $::currenttime = $^T;
    $::timesincemod = $::currenttime - $::modtime;

    unless($::force){
      # Allow 6 hours before automatic update of peak values
      if ($::timesincemod <= 21600) {
	print STDERR ";;;\tFiles recently processed, skipping. Use -force option to over-ride.\n";
	return;
      }
    }

    print STDERR "\n;;;\t$::input\t$::output\n";

    $::script = join("",$::scriptpath, "region_peaks.pl");
    $::command = "$::script -epoch -200 1500 -sample 2.5 $::lat -area $::area -expin $::datapath$::input -expout $::datapath$::output";

    system("perl $::command");

  }
}

###############################################################################
sub SPSS {
  
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

  # Create SPSS production file
  $::SPS      = join("", "all", $::file, "_", $::a, ".sps");
  $::spssprod = join("", "all", $::file, "_", $::a, ".spp");
  open(SPSSPROD, ">$::spssprod") || die "Cannot open $::spssprod\n";
  
  print SPSSPROD "*Creator/owner: anybody.$::nl";
  print SPSSPROD "*Date: $::mday/$::mon/$::year.$::nl$::nl";
  if($^O =~ /win/){
    print SPSSPROD "INCLUDE FILE='$::pwdos\\$::SPS'.$::nl";
  } else {
    print SPSSPROD "INCLUDE FILE='$::pwd/$::SPS'.$::nl";
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
  $::spssprodCMD = "/c/progra~1/spss/spssprod.exe -s";
  system("$::spssprodCMD $::spssprod");
}


sub HELP {
  print STDERR "\n\nUseage: loop_region_peaks_dif.pl -comp <c> -files <f> -exp <e> [-pos][-neg][-spss][-force][-h]\n\n",
    "-comp <c>  The name of the component being measured.\n",
    "           This identifies a file called 'region_<c>.area,\n",
    "           which is a particular format (see region_peaks.pl).\n",
    "-files <f> A partial filename used for pattern matching.\n",
    "           This script will search the current directory for\n",
    "           all files matching this pattern.  Please specify\n",
    "           this partial filename with the file extension (eg, xxx.dat)\n",
    "-exp <e>   The filename pattern that identifies the experimental condition\n",
    "-pos       Only measure positive peaks.\n",
    "-neg       Only measure negative peaks.\n",
    "-spss      Generate spss syntax and production files.\n",
    "-force     Force peak detection and recreation of .peaks files.\n",
    "           Otherwise this script allows 6 hours to reprocess data.\n",
    "-h         This info.\n\n";
  exit;
}
