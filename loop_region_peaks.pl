#! /usr/bin/perl -w

use strict;
use diagnostics;

while(<@ARGV>){
    if(/-force/){ shift; $::force = "yes"; }
    if(/-comp/) { shift; $::comp = shift; }
    if(/-exp/)  { shift; $::exp = shift; }
    if(/-con/)  { shift; $::con = shift; }
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
  $::files = "oac_scd14hz.dat";		# define filename matching expression
  $::orig = ".dat";			# original input filename extension
} else {
  $::files =~ /(\.\w+)/;		# original input filename extension
  $::orig = $1;
}
$::repl = "_$::comp.peaks";	       	# replacement output filename extension
$::lat = "";				#"-lat_range 20"; # limit control condition latency

unless($::exp){ $::exp = "oac"; }
unless($::con){ $::con = "ouc"; }

#########################################################
#MAIN

$::foundfiles = "no";
use File::Find;
find(\&files, $::datapath);		# Find all files in $::datapath


if ($::foundfiles eq "yes") {

  ($::file = $::repl) =~ s/.peaks//;
  foreach $::c ($::exp, $::con){

    if ($::neg) {
      @::attrib = ("neg_amp","neg_lat","neg_el");
    } elsif ($::pos) {
      @::attrib = ("pos_amp","pos_lat","pos_el");
    } else {
      @::attrib = ("pos_amp","pos_lat","pos_el","neg_amp","neg_lat","neg_el");
    }
    $::script = join("",$::scriptpath, "region_peaks_collate.pl");

    foreach $::a (@::attrib){

      $::outfile = join("", "all", $::file, "_", $::c, "_", $::a, ".txt");
      $::command = "$::script -files $::file -path $::datapath -cond $::c -attrib $::a -output $::outfile -notime -addcond";
      if($::spss && !($::a =~ /el/)){ $::command .= " -spss"; }
      system("perl $::command");
    }
  }
  if($::spss) { &SPSSMERGE; }
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

    $::expin = $::input;
    $::expout = $::output;

    ($::conin  = $::input)  =~ s/$::exp/$::con/;
    ($::conout = $::output) =~ s/$::exp/$::con/;

    # Check the last modification time of the output file
    @::stat = stat("$::datapath$::expout");
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

    #print STDERR "\n;;;\t$::input\t$::output\n";
    print STDERR "\n;;;\t$::expin\t$::expout attended common";
    print STDERR "\n;;;\t$::conin\t$::conout unattended common\n";

    $::script = join("",$::scriptpath, "region_peaks.pl");
    $::command = "$::script -epoch -200 1500 -sample 2.5 $::lat -area $::area -expin $::datapath$::expin -expout $::datapath$::expout -conin $::datapath$::conin -conout $::datapath$::conout";

    system("perl $::command");

  }
}

###############################################################################
sub SPSSMERGE {
  $::script = join("",$::scriptpath, "loop_region_peaks_spss.pl");
  if ($::neg) {
    $::command = "$::script -comp $::comp -exp $::exp -con $::con -neg";
  } elsif ($::pos) {
    $::command = "$::script -comp $::comp -exp $::exp -con $::con -pos";
  } else {
    $::command = "$::script -comp $::comp -exp $::exp -con $::con";
  }
  #system("perl $::command");
  print("\n\n####################################\n",
	"Check data files and run:\n",
	"perl $::command\n");
}


sub HELP {
  print STDERR "\n\nUseage: loop_region_peaks.pl -comp <c> -files <f> -exp <e> -con <c> [-pos][-neg][-spss][-force][-h]\n\n",
    "-comp <c>  The name of the component being measured.\n",
    "           This identifies a file called 'region_<c>.area,\n",
    "           which is a particular format (see region_peaks.pl).\n",
    "-files <f> A partial filename used for pattern matching.\n",
    "           This script will search the current directory for\n",
    "           all files matching this pattern.  Please specify\n",
    "           this partial filename with the file extension (eg, xxx.dat)\n",
    "-exp <e>   The filename pattern that identifies the experimental condition\n",
    "-con <c>   The filename pattern that identifies the control condition\n",
    "-pos       Only measure positive peaks.\n",
    "-neg       Only measure negative peaks.\n",
    "-spss      Generate spss syntax and production files.\n",
    "-force     Force peak detection and recreation of .peaks files.\n",
    "           Otherwise this script allows 6 hours to reprocess data.\n",
    "-h         This info.\n\n";
  exit;
}
