#!/usr/bin/perl -w

use strict;
use diagnostics;

unless(@ARGV){ print "\a\nNo input arguments\n"; &HELP; }

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
  $::start = "OK";  $::stop = "OK";
  $::pos_amp = "OK";    $::pos_lat = "OK";    $::pos_el = "OK";
  $::neg_amp = "OK";    $::neg_lat = "OK";    $::neg_el = "OK";
} else {
    if($::attributes =~ /start/i){ $::start = "OK"; } else { $::start = ""; }
    if($::attributes =~ /stop/i){ $::stop = "OK"; } else { $::stop = ""; }
    if($::attributes =~ /pos_amp/i){ $::pos_amp = "OK"; } else { $::pos_amp = ""; }
    if($::attributes =~ /pos_lat/i){ $::pos_lat = "OK"; } else { $::pos_lat = ""; }
    if($::attributes =~ /pos_el/i){ $::pos_el = "OK"; } else { $::pos_el = ""; }
    if($::attributes =~ /neg_amp/i){ $::neg_amp = "OK"; } else { $::neg_amp = ""; }
    if($::attributes =~ /neg_lat/i){ $::neg_lat = "OK"; } else { $::neg_lat = ""; }
    if($::attributes =~ /neg_el/i){ $::neg_el = "OK"; } else { $::neg_el = ""; }
}

%::electrodes = ("","");

$::foundfiles = 0;
use File::Find; find(\&PROCESS, $::path);

if($::foundfiles > 0){
    &OUTPUT;
    if($::spss){ &SPSS; }
} else {
    print STDERR "\a\nNo files ending in '$::files.peaks' exist in $::path\n\n";
}
exit;



############################################################
############################################################
# SUBROUTINES

############################################################
sub PROCESS {
    # process files in path that end with $::files.peaks

    if(/$::files.peaks$/){
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

        ($::subject = $::_) =~ s/.peaks$//;
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
                    &GETPOS; next;
                } else {
                    #got another row of positive or negative peak values
                    if($::input[2] =~ /\S/){ &GETPOS; next;
                    } else {                 &GETNEG; next;
                    }
                }
            }
        }
        close(FILE);
    }
}

############################################################
sub GETPOS{
    $::input[2] =~ s/\s//g;
    $::timing = $::input[2];
    $::timing{"$::subject$::region"} .= "$::input[2]:";
    if( $::input[4] =~ /N/ ){
        #print STDERR ";;; $::region => no positive component specified or found\n";
        ($::pos_el{"$::subject$::region$::timing"} = $::input[4]) =~ s/\s//g;
        ($::pos_amp{"$::subject$::region$::timing"} = $::input[4]) =~ s/\s//g;
        ($::pos_lat{"$::subject$::region$::timing"} = $::input[4]) =~ s/\s//g;
    } else {
        #print STDERR ";;; $::region => positive amp is $::input[4]\n";
        ($::pos_el{"$::subject$::region$::timing"} = $::input[3]) =~ s/\s//g;
        ($::pos_amp{"$::subject$::region$::timing"} = $::input[4]) =~ s/\s//g;
        ($::pos_lat{"$::subject$::region$::timing"} = $::input[6]) =~ s/\s//g;
    }
}    

############################################################
sub GETNEG{
    if( $::input[5] =~ /N/ ){
        #print STDERR ";;; $::region => no negative component specified or found\n";
        ($::neg_el{"$::subject$::region$::timing"} = $::input[5]) =~ s/\s//g;
        ($::neg_amp{"$::subject$::region$::timing"} = $::input[5]) =~ s/\s//g;
        ($::neg_lat{"$::subject$::region$::timing"} = $::input[5]) =~ s/\s//g;
    } else {
        #print STDERR ";;; $::region => negative amp is $::input[5]\n";
        ($::neg_el{"$::subject$::region$::timing"} = $::input[3]) =~ s/\s//g;
        ($::neg_amp{"$::subject$::region$::timing"} = $::input[5]) =~ s/\s//g;
        ($::neg_lat{"$::subject$::region$::timing"} = $::input[6]) =~ s/\s//g;
    }
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

    # Output start/stop times for each region
    # currently assume only one start/stop per region
    if ($::start eq "OK") {
      print "$::sub\tstart    \t";
      foreach $::region (@::regions){
	@::times = split(/:/,$::timing{"$::subject$::region"});
	foreach $::time (@::times){
	  @::timing = split(/-/,$::time);
	  print "$::timing[0]\t";
	}
      }
      print "\n";
    }

    if ($::stop eq "OK") {
      print "$::sub\tstop    \t";
      foreach $::region (@::regions){
	@::times = split(/:/,$::timing{"$::subject$::region"});
	foreach $::time (@::times){
	  @::timing = split(/-/,$::time);
	  print "$::timing[1]\t";
	}
      }
      print "\n";
    }

    # Output positive electrode,amplitude,latency
    if ($::pos_el eq "OK") {
      print "$::sub\tpos_elec\t";
      foreach $::region (@::regions){
	@::times = split(/:/,$::timing{"$::subject$::region"});
	foreach $::time (@::times){
	  $::key = "$::subject$::region$::time";
	  print "$::pos_el{$::key}\t";
	}
      }
      print "\n";
    }

    if ($::pos_amp eq "OK") {
      print "$::sub\tpos_amp \t";
      foreach $::region (@::regions){
	@::times = split(/:/,$::timing{"$::subject$::region"});
	foreach $::time (@::times){
	  $::key = "$::subject$::region$::time";
	  print "$::pos_amp{$::key}\t";
	}
      }
      print "\n";
    }

    if ($::pos_lat eq "OK") {
      print "$::sub\tpos_lat \t";
      foreach $::region (@::regions){
	@::times = split(/:/,$::timing{"$::subject$::region"});
	foreach $::time (@::times){
	  $::key = "$::subject$::region$::time";
	  print "$::pos_lat{$::key}\t";
	}
      }
      print "\n";
    }

    # Output negative electrode,amplitude,latency
    if ($::neg_el eq "OK") {
      print "$::sub\tneg_elec\t";
      foreach $::region (@::regions){
	@::times = split(/:/,$::timing{"$::subject$::region"});
	foreach $::time (@::times){
	  $::key = "$::subject$::region$::time";
	  print "$::neg_el{$::key}\t";
	}
      }
      print "\n";
    }

    if ($::neg_amp eq "OK") {
      print "$::sub\tneg_amp \t";
      foreach $::region (@::regions){
	@::times = split(/:/,$::timing{"$::subject$::region"});
	foreach $::time (@::times){
	  $::key = "$::subject$::region$::time";
	  print "$::neg_amp{$::key}\t";
	}
      }
      print "\n";
    }

    if ($::neg_lat eq "OK") {
      print "$::sub\tneg_lat \t";
      foreach $::region (@::regions){
	@::times = split(/:/,$::timing{"$::subject$::region"});
	foreach $::time (@::times){
	  $::key = "$::subject$::region$::time";
	  print "$::neg_lat{$::key}\t";
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

Useage: region_peaks_collate.pl -files <filepattern> -path <path>
                                -attrib <attribute,attribute,...>
                                -cond <condition>
                                -addcond
                                -notime
                                -spss

    See also 'loop_region_peaks.pl' for an example of
    how to both find ERP component peaks and collate the peak
    measures into a single text file, using this utility.

    <filepattern> is a partial filename string that identifies
    files to be processed.  This string is used in a regular
    expression to find all files in <path> *ending* with both
    that string and the file extension '.peaks'.  This file
    extension is created by the 'region_peaks.pl' routine, among
    others. If <path> is not provided, it is assumed to be the
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

    pos_amp => positive peak amplitude values
    pos_lat => positive peak latency values
    pos_el => positive peak electrode values
    
    neg_amp => negative peak amplitude values
    neg_lat => negative peak latency values
    neg_el => negative peak electrode values

    start => epoch start times
    stop => epoch stop times

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
    c01oac_scd14hz_n80      start           55.0    55.0    55.0    55.0    
    c01oac_scd14hz_n80      stop            125.0   125.0   125.0   125.0   
    c01oac_scd14hz_n80      pos_elec        NA      NA      NA      NA      
    c01oac_scd14hz_n80      pos_amp         NA      NA      NA      NA      
    c01oac_scd14hz_n80      pos_lat         NA      NA      NA      NA      
    c01oac_scd14hz_n80      neg_elec        61      22      72      28      
    c01oac_scd14hz_n80      neg_amp         -2.70   -1.47   -2.37   -0.64   
    c01oac_scd14hz_n80      neg_lat         90.00   92.50   87.50   107.50  
    c01ouc_scd14hz_n80      start           55.0    55.0    55.0    55.0    
    c01ouc_scd14hz_n80      stop            125.0   125.0   125.0   125.0   
    c01ouc_scd14hz_n80      pos_elec        NA      NA      NA      NA      
    c01ouc_scd14hz_n80      pos_amp         NA      NA      NA      NA      
    c01ouc_scd14hz_n80      pos_lat         NA      NA      NA      NA      
    c01ouc_scd14hz_n80      neg_elec        61      22      72      28      
    c01ouc_scd14hz_n80      neg_amp         -2.71   0.75    -3.17   -0.45   
    c01ouc_scd14hz_n80      neg_lat         87.50   87.50   87.50   100.00  
    
HELP
exit;
}
