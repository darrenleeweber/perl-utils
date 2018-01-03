#!/usr/bin/perl -w

use strict;
use diagnostics;

unless(@ARGV){ print "\a\nNo input arguments\n"; &HELP; }

$::attributes = "all";
$::notime = "";
$::addcond = "";
$::spss = "";

while(<@ARGV>){
    if(/-h/){ &HELP; }
    if(/-cond/){ shift; $::conditions = shift; }
    if(/-attrib/){shift; $::attributes = shift; }
    if(/-files/){  shift; $::files = shift; }
    if(/-path/){ shift; $::path = shift; }
    if(/-output/){ shift; $::outfile = shift; }
    if(/-notime/){ shift; $::notime = "yes"; }
    if(/-addcond/){ shift; $::addcond = "yes"; }
    if(/-spss/){ shift; $::spss = "yes"; }
}

unless($::files){
    #Search for all files?
    print STDERR "\a\n;;; Sorry, no files string specified.\n";
    &HELP;
}
unless($::path){  $::path = '.'; }


if($::attributes =~ /all/i){
  $::amp = "OK";  $::lat = "OK";
} else {
    if($::attributes =~ /amp/i){ $::amp = "OK"; } else { $::amp = ""; }
    if($::attributes =~ /lat/i){ $::lat = "OK"; } else { $::lat = ""; }
}

%::electrodes = ("","");

$::foundfiles = 0;
use File::Find; find(\&PROCESS, $::path);

if($::foundfiles > 0){
    &OUTPUT;
    if($::spss){ &SPSS; }
} else {
    print STDERR "\a\nNo files ending in '$::files.points' exist in $::path\n\n";
}
exit;



############################################################
############################################################
# SUBROUTINES

############################################################
sub PROCESS {
  # process files in path that end with $::files.points
  
  if(/$::files.points$/){
    if($::conditions){
      $::continue = "No";
      @::conditions = split(/,/, $::conditions);
      foreach $::c (@::conditions){
	#print STDERR ";;; $::subject ... $::c ... ";
	if(/$::c/){ $::continue = "OK"; }
      }
      #print STDERR "$::continue\n";
      if($::continue ne "OK"){ return; }
    }
    $::foundfiles++;
    if($::foundfiles == 1){ print STDERR "\n\n"; }
    print STDERR ";;; Collating $::_\n";
    
    ($::subject = $::_) =~ s/.points$//;
    push(@::subjects, $::subject);
    
    open(FILE, "$::_") || die "Can't open $::_";
    while(<FILE>){
      if(/:/){
	@::input = split(/:/);
	if($::input[0] =~ /Region/){ next; }
	if($::input[0] =~ /\S/){
	  ($::region = $::input[0]) =~ s/\s//g;
	  $::regions{$::subject} .= "$::region,";
	  $::electrodes{"$::subject$::region"} = $::input[1];
	  @::values = split(/\s+/,$::input[2]);
	  $::time = $::values[1];
	  $::avgamp = $::values[4];
	  ($::timing{"$::subject$::region"} .= "$::time : ") =~ s/\s//g;
	  ($::point_amp{"$::subject$::region$::time"} = $::avgamp) =~ s/\s//g;
	  #print STDERR ";;; $::region => points avg amp is $::avgamp\n";
	}
	next;
      }
    }
  }
  close(FILE);
}


############################################################
sub OUTPUT{

  # If necessary, redirect output file
  if($::outfile){
    $::output = "$::path$::outfile";
    open(STDOUT, ">$::output") || die "\a\nCan't redirect STDOUT to $::output\n";
  }
  
  $::printheadings ="";
  
  foreach $::subject (@::subjects){
    ($::sub = $::subject) =~ s/$::files//;
    # Output headings
    unless($::printheadings){
      $::heading = "Subjects"; print $::heading;
      if ( length($::heading) < length($::sub) ) {
	$::spaces = length($::sub) - length($::heading);
	for ($::i = 0; $::i < $::spaces; $::i++) {
	  print " ";
	}
      }
      print "\tData    \t";
      
      @::regions = split(/,/, $::regions{$::subject});
      
      foreach $::region (@::regions){
	@::times = split(/:/,$::timing{"$::subject$::region"});
	foreach $::time (@::times){
	  $::time =~ s/.0//g;
	  if ($::notime) {
	    if ($::addcond) {
	      @::conditions = split(/,/, $::conditions);
	      foreach $::c (@::conditions){
		if ($::subject =~ /$::c/) {
		  $::addcond = $::c;
		}
	      }
	      ($::reg = $::region) =~ s/_//g;
	      print "$::reg$::addcond\t";
	    } else {
	      print "$::region\t";
	    }
	  } else {
	    print "$::{region}_$::time\t";
	  }
	}
      }
      print "\n";  $::printheadings = "done";
    }
    
    # Output amplitude
    if ($::amp eq "OK") {
      print "$::sub\tamp \t";
      foreach $::region (@::regions){
	@::times = split(/:/,$::timing{"$::subject$::region"});
	foreach $::time (@::times){
	  $::key = "$::subject$::region$::time";
	  print "$::point_amp{$::key}\t";
	}
      }
      print "\n";
    }
    
    # Output point time for each region
    if ($::lat eq "OK") {
      print "$::sub\tlat    \t";
      foreach $::region (@::regions){
	@::times = split(/:/,$::timing{"$::subject$::region"});
	foreach $::time (@::times){
	  print "$::time\t";
	}
      }
      print "\n";
    }
  }
  if ($::outfile) {
    close(STDOUT);
    print STDERR "\n;;;\tCompleted output to $::outfile\n";
  }
}

############################################################
sub SPSS{

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
    $::nl = "\r\n";
  } else {
    $::nl = "\n";
  }

  ($::spssfile = $::outfile) =~ s/.txt/.sps/;
  open(SPSS, ">$::spssfile") || die "\a\nCannot open $::spssfile\n\n";
  print SPSS "GET DATA /TYPE = TXT$::nl";
  if($^O =~ /win/){
    print SPSS " /FILE = '$::pwdos\\$::outfile'$::nl";
  } else {
    print SPSS " /FILE = '$::pwd/$::outfile'$::nl";
  }
  print SPSS " /DELCASE = LINE$::nl";
  print SPSS " /DELIMITERS = \"\\t\"$::nl";
  print SPSS " /ARRANGEMENT = DELIMITED$::nl";
  print SPSS " /FIRSTCASE = 2$::nl";
  print SPSS " /IMPORTCASE = ALL$::nl";
  print SPSS " /VARIABLES =$::nl";

  $::subject = $::subjects[0];
  ($::sub = $::subject) =~ s/$::files//;

  print SPSS " Subjects ";
  if ( length("Subjects") < length($::sub) ) {
    $::spaces = length($::sub);
    print SPSS "A$::spaces$::nl";
  } else {
    print SPSS "A8$::nl";
  }
  print SPSS " Data\tA8$::nl";

  @::regions = split(/,/, $::regions{$::subject});

  foreach $::region (@::regions){
    @::times = split(/:/,$::timing{"$::subject$::region"});
    foreach $::time (@::times){
      $::time =~ s/-/_/g;
      $::time =~ s/.0//g;
      if ($::notime) {
	if ($::addcond) {
	  @::conditions = split(/,/, $::conditions);
	  foreach $::c (@::conditions){
	    if ($::subject =~ /$::c/) {
	      $::addcond = $::c;
	    }
	  }
	  ($::reg = $::region) =~ s/_//g;
	  print SPSS " $::reg$::addcond\tF5.2$::nl";
	} else {
	  print SPSS " $::region\tF5.2$::nl";
	}
      } else {
	$::reg  = $::region;
	$::reg .= "_$::time";
	print SPSS " $::reg\tF5.2$::nl";
      }
    }
  }
  print SPSS " .\nCACHE.\nEXECUTE.$::nl";
  ($::savfile = $::spssfile) =~ s/.sps/.sav/;
  if($^O =~ /win/){
    print SPSS "SAVE OUTFILE='$::pwdos\\$::savfile'$::nl";
  } else {
    print SPSS "SAVE OUTFILE='$::pwd/$::savfile'$::nl";
  }
  print SPSS " /COMPRESSED.$::nl";
  close(SPSS);
  print STDERR ";;;\tCreated SPSS syntax file in $::spssfile\n";

}


############################################################
sub HELP {
    print STDERR <<HELP;

Useage: region_points_collate.pl -files <filepattern> -path <path>
                                 -attrib <attribute,attribute,...>
                                 -cond <condition>
                                 -addcond
                                 -notime
                                 -spss

    See also 'loop_region_points_avg.pl' for an example of
    how to both find ERP component point averages and collate the
    measures into a single text file, using this utility.

    <filepattern> is a partial filename string that identifies
    files to be processed.  This string is used in a regular
    expression to find all files in <path> *ending* with both
    that string and the file extension '.points'.  This file
    extension is created by the 'region_points_avg.pl' routine.
    If <path> is not provided, it is assumed to be the
    current working directory.
    
    <condition,condition,...> is a series of strings that identify
    condition filename substrings. If your filenames contain a
    condition substring, use this option to process only those
    files with <condition> in the filename.  This is very useful
    when working with many files in the same directory, all with
    various conditions.  It allows you to focus the collation
    process on one or more specific conditions.
    
    <attribute,attribute,...> is a series of strings that identify
    peak attributes to collate.  There must be no spaces between
    the attribute elements, only commas.  The possible values are:

    amp  => average amplitude
    lat  => point latency, time t

    all => all of the above

    The -addcond option adds the condition label from the
    area file to the variable name in the collated data file.

    The -notime option modifies the output headings by removing
    the ERP component timing from the region headings.  This is
    useful when importing the output directly into SPSS 10 for
    windows, which allows only 8 characters for variable names.
    The drawback here is when there is more than one time window
    for a region.  The data from this region will appear in seperate
    columns, but there will be no timing in the headers to indicate
    different time windows.  The -spss option will generate some
    spss syntax files to load the output of this program.
    
    Here is an example of the output for all attributes and several
    conditions for one subject.  This space delimited output is easily
    imported into excel and/or SPSS, especially when only one
    attribute, is selected:

    Subjects                regions:        L_IC    R_IC    L_SC    R_SC
    c01oac_scd14hz_100      lat             100.0   100.0   100.0   100.0
    c01oac_scd14hz_100      amp             12.25   10.53   13.42   11.08
    c01ouc_scd14hz_100      lat             100.0   100.0   100.0   100.0
    c01ouc_scd14hz_100      amp             10.89   10.82   11.90   11.21
    
HELP
exit;
}
