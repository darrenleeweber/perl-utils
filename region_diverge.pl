#! /usr/bin/perl

# Set output directory to current directory and go there
$wd = `pwd`; chop($wd); $wd .= "/"; chdir "$wd";
$od = "div_region";
$ed = "div_exact";

# Get input parameters
while(<@ARGV>){
  if(/-epoch/) { shift; $epoch_s = shift; $epoch_e = shift; }
  if(/-sample/){ shift; $sample = shift; }
  if(/-area/)  { shift; $area = shift; }
  if(/-exp/)   { shift; $exp = shift; ($exp_o = $exp) =~ s/\.\w+$//;  }
  if(/-con/)   { shift; $con = shift; ($con_o = $con) =~ s/\.\w+$//;  }
  if(/-reg_od/){ shift; $od = shift; }
  if(/-ex_od/) { shift; $ed = shift; }
  if(/-full/)  { shift; $full = "y"; }
  if(/-h/)     { shift; &HELP; }
}

# Check input parameters
unless ($epoch_s && $sample && $area && $exp && $con){
  die "\a\nPlease specify all essential parameters.\n\n",
  "Use region_diverge -h for help.\n\n",
  "Note that zero values must be specified as 0.0\n\n";
}

# Check that epoch values are multiples of the sample rate
$totalpoints = ($epoch_e - $epoch_s) / $sample;
$point = $epoch_s - ( $sample * 8 );  $end = $epoch_e + ( $sample * 8 );
while ( $point <= $end ){ $point += $sample; push(@points, $point);  }
foreach $p (@points){  if($epoch_e == $p){ $sample_ok = "true"; }  }
unless($sample_ok){
  print "\a\nPlease ensure that the epoch start and end points\n",
  "are multiples of the sample rate.\n",
  "Given the epoch start time of $epoch_s, values could be:\n\n";
  foreach $p (@points){ printf "%10.2f", $p; }
  print "\n\n";
  exit;
}

# Get and check area parameters
open(AREA, "$area") || die "\a\nCan't open AREA file $area\n";
while(<AREA>){
  s/[\r\n\f]//g;		# remove returns, new lines, and form feeds
  @a = split(/\s*:\s*/);
  $area{$a[0]} = "$a[1]";
  $win{$a[0]} = "$a[2]";

#  print "$a[0]: $area{$a[0]}: "; # Debug

  # check that win values are multiples of the sample rate.  This is
  # critical for later sorting of peak values according to an index
  # of both electrode number and TEMPORAL LATENCY.

  @times = split(/,\s*/, $win{$a[0]});
  foreach $t (@times){
    @t = split(/\s+/, $t); $ws = $t[0]; $we = $t[1]; $polar = $t[2];

#    print " $ws $we $polar,";	# Debug

    foreach $w ("$ws", "$we"){
      $sample_ok = "";
      $srange =  $w - ($sample * 8);  $erange =  $w + ($sample * 8);
      foreach $p (@points){
	if ( $p > $srange && $p < $erange ){
	  if($w == $p){ $sample_ok = "true"; }
	} elsif            ( $p > $erange ){ last; }
      }
      unless($sample_ok){
	print "\a\nPlease ensure that the time of $w msec for $a[0] is a\n",
	"multiple of the sample rate.  Given the epoch start\n",
	"time of $epoch_s, values could be:\n\n";
	foreach $p (@points){
	  if ( $p > $srange && $p < $erange ){ printf "%10.2f", $p;
	  } elsif            ( $p > $erange ){ last; }
	}
	print "\n\n";
	exit;
      }
    }
  }
#  print "\n";			# Debug
}

# print "All checked O.K.\n"; exit;  # Debug

# Put input into table format for later electrode selection and creation of
# exact test data
print "\nCreating temporary table files of experimental and control data.\n";
$tmp = "tmp$$";
system "tbcat $exp > $exp.tbl.$tmp" || die "Can't create exp tbl file\n\n";
system "tbcat $con > $con.tbl.$tmp" || die "Can't create con tbl file\n\n";
system "tbcat -bin $exp.tbl.$tmp $con.tbl.$tmp | tbshuffle | tbdiff | tbtext -f f %12.6f > dif.$tmp" || die "Can't create dif file\n\n";

# Put input into array @v and search for maximum peak of diff wave
$f = 0;  $l = ($epoch_e - $epoch_s) / $sample;
print "\nSearching for maximum differences in electrodes:\n";

open(DIFFILE, "dif.$tmp") || die "\nCan't open dif.$tmp\n\n";
while (<DIFFILE>){
  $e++; printf "%5d",$e;
  if($e > 124){
    print "\nWarning: more than 124 rows in input file.\n\n",
    "Check that *.dat files are in unix format (use dos2unix).\n\n";
  }
  if     (/"/){
                @dat = split(/"/); @v = split(/\s+/,pop(@dat));
  } elsif(/'/){
                @dat = split(/'/); @v = split(/\s+/,pop(@dat));
  } else {     
                                   @v = split;
  }
  &GETDIFPEAKS;
}
close(DIFFILE);

print "\n\nSearching for maximum difference in regions and creating output.\n";
unless (-d "$ed")    { mkdir ("$ed"    ,0777); }
if($full){
  unless (-d "$od")    { mkdir ("$od"    ,0777); }
  unless (-d "$od/pos"){ mkdir ("$od/pos",0777); }
  unless (-d "$od/neg"){ mkdir ("$od/neg",0777); }
}

&MAXDIFPEAKS;


# Subroutines

sub GETDIFPEAKS {
  $v = $v[$f];			# First value
  $n = $f + 1;			# Next Value index
  $lat = ($f * $sample) + $epoch_s; # Latency of First Value
  while($n <= $l){		# While next value index <= last value index
    if($v > $v[$n]){
      $v = $v[$n]; $n++;
      $lat += $sample;
      if($v > $v[$n]){
	next;
      } else {
	$i = "${e}_$lat"; $neg{$i} = $v;
#	printf "%-10s %10.4f\n",$i,$neg{$i};  # for debug tracing
      }
    } elsif($v < $v[$n]){
      $v = $v[$n]; $n++;
      $lat += $sample;
      if($v < $v[$n]){
	next;
      } else {
	$i = "${e}_$lat"; $pos{$i} = $v;
#	printf "%-10s %10.4f\n",$i,$pos{$i};  # for debug tracing
      }
    } elsif($v == $v[$n]){
      $v = $v[$n]; $n++;
      $lat += $sample;
    }
  }
}

sub MAXDIFPEAKS {

  printf "\n%-8s%-40s%17s%10s","","All","","Selected";
  printf "\n%-8s%-40s%17s%10s%10s%10s%10s\n\n","Region","Electrodes","Time Window","Electrode","Positive","Negative","Latency";

  open(AREA, "$area") || die "\nCan't open AREA file to sort dif peaks.\n";
  while(<AREA>){
    s/[\r\n\f]//g;		# remove returns, new lines, and form feeds
    @a = split(/\s?:\s?/);
    unless(-d "$ed/$a[0]"){ mkdir ("$ed/$a[0]", 0777); }
    @times = split(/,\s*/, $win{$a[0]});
    $first = "first";
    foreach $t (@times){
      @t = split(/\s+/, $t); $ws = $t[0]; $we = $t[1]; $polar = $t[2];

      if($first){
        printf "%-8s%-40s%7.1f - %7.1f",$a[0],$a[1],$ws,$we;
        $first = "";
      } else {
        printf "%-8s%-40s%7.1f - %7.1f","","",$ws,$we;
      }
    
      $p_v = -10000; $p_l = ""; $p_e = "";
      $n_v =  10000; $n_l = ""; $n_e = "";

      $lat = $ws; $end = $we;
      while ($lat <= $end){
	foreach $elec (split(/\s+/, $a[1])){

	  $i = "${elec}_$lat";

#	   printf "%-10s %8.4f %8.4f %8.4f\n",$i,$pos{$i},$neg{$i};    # debug

	  if($pos{$i} ne ""){
	    if($p_v < $pos{$i}){
	      $p_v = $pos{$i}; $p_l = $lat; $p_e = $elec;
	    }
	  }
	  if($neg{$i} ne ""){
	    if($n_v > $neg{$i}){
	      $n_v = $neg{$i}; $n_l = $lat; $n_e = $elec;
	    }
	  }
	}
	$lat += $sample;
      }

      if($polar =~ /p/i){
	if($p_v != -10000){
	  printf "%10s%10.2f%10s%10.2f\n",$p_e,$p_v,"",$p_l;
	  if($full){
	    $tbt = "tbselect $p_e | tbtext -f f %10.4f";
	    system "cat $exp.tbl.$tmp | $tbt > $od/pos/$exp_o.dif.${ws}to${we}.$a[0].p";
	    system "cat $con.tbl.$tmp | $tbt > $od/pos/$con_o.dif.${ws}to${we}.$a[0].p";
	  }

	  $f = ($ws - $epoch_s) / $sample; $l = $totalpoints - ( ($we - $epoch_s) / $sample );

	  if($f > 0 && $l > 0){
	    $tbt = "tbselect $p_e | tbcolrm -f $f | tbcolrm -c $l | tbtext -f f %10.4f";
	    system "cat $exp.tbl.$tmp | $tbt > $ed/$a[0]/$exp_o.dif.${ws}to${we}.$a[0].p";
	    system "cat $con.tbl.$tmp | $tbt > $ed/$a[0]/$con_o.dif.${ws}to${we}.$a[0].p";
	  } elsif ($f > 0 && $l == 0){
	    $tbt = "tbselect $p_e | tbcolrm -f $f | tbtext -f f %10.4f";
	    system "cat $exp.tbl.$tmp | $tbt > $ed/$a[0]/$exp_o.dif.${ws}to${we}.$a[0].p";
	    system "cat $con.tbl.$tmp | $tbt > $ed/$a[0]/$con_o.dif.${ws}to${we}.$a[0].p";
	  } elsif ($f == 0 && $l > 0){
	    $tbt = "tbselect $p_e | tbcolrm -c $l | tbtext -f f %10.4f";
	    system "cat $exp.tbl.$tmp | $tbt > $ed/$a[0]/$exp_o.dif.${ws}to${we}.$a[0].p";
	    system "cat $con.tbl.$tmp | $tbt > $ed/$a[0]/$con_o.dif.${ws}to${we}.$a[0].p";
	  }
	} else {
	  printf "%10s%10s%10s%10s\n","","No POS","","";
	}
      } else {
	  printf "%10s%10s%10s%10s\n","","NA","","";
      }

        if($polar =~ /n/i){
        	if($n_v !=  10000){
        	  printf "%-8s%-40s%17s%10s%10s%10.2f%10.2f\n","","","",$n_e,"",$n_v,$n_l;
        	  if($full){
        	    $tbt = "tbselect $n_e | tbtext -f f %10.4f";
        	    system "cat $exp.tbl.$tmp | $tbt > $od/neg/$exp_o.dif.${ws}to${we}.$a[0].n";
        	    system "cat $con.tbl.$tmp | $tbt > $od/neg/$con_o.dif.${ws}to${we}.$a[0].n";
        	  }
        
        	  $f = ($ws - $epoch_s) / $sample; $l = $totalpoints - ( ($we - $epoch_s) / $sample );
        	  if($f > 0 && $l > 0){
        	    $tbt = "tbselect $n_e | tbcolrm -f $f | tbcolrm -c $l | tbtext -f f %10.4f";
        	    system "cat $exp.tbl.$tmp | $tbt > $ed/$a[0]/$exp_o.dif.${ws}to${we}.$a[0].n";
        	    system "cat $con.tbl.$tmp | $tbt > $ed/$a[0]/$con_o.dif.${ws}to${we}.$a[0].n";
        	  } elsif ($f > 0 && $l == 0){
        	    $tbt = "tbselect $n_e | tbcolrm -f $f | tbtext -f f %10.4f";
        	    system "cat $exp.tbl.$tmp | $tbt > $ed/$a[0]/$exp_o.dif.${ws}to${we}.$a[0].n";
        	    system "cat $con.tbl.$tmp | $tbt > $ed/$a[0]/$con_o.dif.${ws}to${we}.$a[0].n";
        	  } elsif ($f == 0 && $l > 0){
        	    $tbt = "tbselect $n_e | tbcolrm -c $l | tbtext -f f %10.4f";
        	    system "cat $exp.tbl.$tmp | $tbt > $ed/$a[0]/$exp_o.dif.${ws}to${we}.$a[0].n";
        	    system "cat $con.tbl.$tmp | $tbt > $ed/$a[0]/$con_o.dif.${ws}to${we}.$a[0].n";
        	  }
        	} else {
        	  printf "%-8s%-40s%17s%10s%10s%10s%10s\n","","","","","","No Neg","";
        	}
        } else {
            printf "%-8s%-40s%17s%10s%10s%10s%10s\n","","","","","","NA","";
        }
    }
  }
  close(AREA);  system "rm *.$tmp";
}


sub HELP {
  print "\a\n","REGION_DIVERGE\n\n",

  "REGION_DIVERGE will identify electrodes with a maximum positive\n",
  "or negative divergence between an experimental and control dataset,\n",
  "for regions of electrodes, within a window specified.\n\n",

  "INPUT:  The input should be two text files with rows of electrodes\n",
  "and columns of data points.  The input should not contain any electrode\n",
  "numbers or labels.\n\n",

  "OUTPUT:  The output is two text files for each region specified,\n",
  "which contain a row of all values in an epoch for the electrodes\n",
  "with maximum positive and negative difference values.  These output\n",
  "files are created for both the experimental and control datafile.\n\n",

  "USEAGE:  region_diverge -epoch x x  -sample x  -area <file>\n",
  "                        -exp <file>  -con <file>\n",
  "                        [-ex_od <path>] [-reg_od <path>] [-full] [-h]\n\n",

  "-epoch x x     Specifies total epoch, in msec (e.g., -100 900).\n",
  "-sample x      Specifies sample rate, in msec.\n",
  "-exp <file>    Specifies experimental data file.\n",
  "-con <file>    Specifies control data file.\n\n",

  "-area <file>   Specifies a file that contains at least one area name,\n",
  "               followed by a colon (:), then some electrodes for that\n",
  "               area, another colon (:), and at least one time window\n",
  "               (in msec) to search for divergence.  For example, one\n",
  "               line might look like this:\n\n",

  "               REGION_A: 1 2 4 8 10: -200 -50 (P), 0.0 100 (N), 400 600 (P)\n\n",

  "               Note that more than one time window is specified.\n",
  "               Each time window specification contains an initial time,\n",
  "               followed by a space, and a finish time.  It also contains\n",
  "               an indication of the polarity of difference between the exp\n",
  "               and con conditions.  For multiple time windows, separate\n",
  "               each by a comma (,).\n\n",

  "               For example, see /users/psdlw/bin/region_diverge.def, which\n",
  "               was specified for a dataset with an epoch of -200 to 1500 msec\n",
  "               and a sample rate of 2.5 msec.  Note that zero is 0.0\n\n",

  "               EVERY LINE in the AREA FILE must have ONLY ONE\n",
  "               AREA SPECIFICATION.\n\n",

  "               All EPOCH and TIME WINDOW values must be\n",
  "               MULTIPLES of the SAMPLE RATE.\n\n",

  "-ex_od <path>  Output directory path for segmented waveforms selected for\n",
  "               each region and time.  This output is text data that needs to\n",
  "               be renamed and converted into tb format for the exact test\n",
  "               routine, tbmakexact.  The default is div_exact.\n\n",

  "-full          Output complete waveforms selected for each region.\n",
  "-reg_od <path> Output directory path for complete waveforms selected for\n",
  "               each region.  The default is div_region.\n\n",

  "-h             Provides this helpful information.\n\n";
  exit;
}
