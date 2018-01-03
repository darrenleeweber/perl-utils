#! /usr/bin/perl

# Set output directory to current directory and go there
$wd = `pwd`; chop($wd); $wd .= "/"; chdir "$wd";
$od = "div_region";
$ed = "div_exact";

# Get input parameters
while(<@ARGV>){
  if(/-epoch/) { shift; $epoch_s = shift; $epoch_e = shift; }
  if(/-sample/){ shift; $sample = shift; }
  if(/-period/){ shift; $period = shift; }
  if(/-number/){ shift; $number = shift; }
  if(/-area/)  { shift; $area = shift; }
  if(/-file/)  { shift; $file = shift; }
  if(/-out/)   { shift; $out = shift; }
  if(/-h/)     { shift; &HELP; }
}

# Check input parameters
unless ($epoch_s && $sample && $period && $number && $area && $file){
  die "\a\nPlease specify all essential parameters.\n\n",
  "Use region_peaks_avg -h for help.\n\n",
  "Note that zero area file values must be specified as 0.0\n\n";
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

# Put input into array @v and search for maximum peaks
$f = 0;  $l = ($epoch_e - $epoch_s) / $sample;

if($out){ open(STDOUT, ">$out") || die "Can't redirect STDOUT to $out\n"; }

print "\nSearching for maximum peaks in electrodes:\n";

open(FILE, "$file") || die "\nCan't open $file\n\n";
while (<FILE>){
  $e++; printf  "%5d",$e;
  if($e > 124){
    print "\nWarning: more than 124 rows in input file.\n\n",
    "Check that *.dat files are in unix format (use dos2unix).\n\n";
  }
  if     (/"/){
                @dat = split(/"/); @v = split(/\s+/,pop(@dat)); shift(@v); $matrix{$e} = "@v";
  } elsif(/'/){
                @dat = split(/'/); @v = split(/\s+/,pop(@dat)); shift(@v); $matrix{$e} = "@v";
  } else {     
                                   @v = split;  $matrix{$e} = $_;
  }
  &GETPEAKS;
}
close(FILE);

print  "\n\nSearching for maximum peaks in regions and creating output.\n";
&MAXPEAKAVG;

exit;


# Subroutines

sub GETPEAKS {
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
	# printf "%-10s %10.4f\n",$i,$neg{$i};  # for debug tracing
      }
    } elsif($v < $v[$n]){
      $v = $v[$n]; $n++;
      $lat += $sample;
      if($v < $v[$n]){
	next;
      } else {
	$i = "${e}_$lat"; $pos{$i} = $v;
	# printf "%-10s %10.4f\n",$i,$pos{$i};  # for debug tracing
      }
    } elsif($v == $v[$n]){
      $v = $v[$n]; $n++;
      $lat += $sample;
    }
  }
}

sub MAXPEAKAVG {

  printf  "\n%-8s %-25s %17s %-10s","","All","","Selected";
  printf  "\n%-8s %-25s %17s %-10s%10s%10s%10s%16s\n\n","Region","Electrodes","Time Window","Electrode","Positive","Negative","Latency","Averages-->";

  open(AREA, "$area") || die "\nCan't open AREA file to sort peaks.\n";
  while(<AREA>){
    s/[\r\n\f]//g;		# remove returns, new lines, and form feeds
    @a = split(/\s?:\s?/);
    @times = split(/,\s*/, $win{$a[0]});
    $first = "first";
    foreach $t (@times){
      @t = split(/\s+/, $t); $ws = $t[0]; $we = $t[1]; $polar = $t[2];

      if($first){
	printf  "%-8s %-25s %7.1f - %7.1f",$a[0],$a[1],$ws,$we;
	$first = "";
      } else {
	printf  "%-8s %-25s %7.1f - %7.1f","","",$ws,$we;
      }

      $p_v = -10000; $p_l = ""; $p_e = "";
      $n_v =  10000; $n_l = ""; $n_e = "";

      $lat = $ws; $end = $we;
      while ($lat <= $end){
	foreach $elec (split(/\s+/, $a[1])){

	  $i = "${elec}_$lat";

	  # printf "%-10s %8.4f %8.4f %8.4f\n",$i,$pos{$i},$neg{$i};    # debug

	  # Determine maximum positive peak
	  if($pos{$i} ne ""){
	    if($p_v < $pos{$i}){
	      $p_v = $pos{$i}; $p_l = $lat; $p_e = $elec;
	    }
	  }

	  # Determine maximum negative peak
	  if($neg{$i} ne ""){
	    if($n_v > $neg{$i}){
	      $n_v = $neg{$i}; $n_l = $lat; $n_e = $elec;
	    }
	  }
	}
	$lat += $sample;
      }
      
      # Ouput average of period beyond maximum positive peak, if any
      if($polar =~ /p/i){    	
      	if($p_v != -10000){
      		
		printf  "%10s%10.2f%20.2f",$p_e,$p_v,$p_l;
		
		# Get voltage points from matrix for electrode $p_e
		@points = split(/\s+/, $matrix{$p_e});

		# Define the starting array element for the average 
		# at one sample point beyond the latency of peak at $p_l
		$arr_element = ( ($p_l + $sample) - $epoch_s ) / $sample;

		# Define the number of array elements to average for $period
		$elements = $period / $sample;
		
		# Add all voltage values for $period, $number times
		for ($i = 0; $i < $number; $i++){

			# debug output
			#printf( stderr "%4d  %12.6f  ", $arr_element, $points[$arr_element]);

			for ($e = 0; $e < $elements; $e++){
				
				# For each element, add another value and update element index
				$sum += $points[$arr_element++];
			}
			$avg = $sum / $elements; $sum = 0;
			
			# output average
			$lastpoint = ( ($arr_element - 1) + ($epoch_s / $sample) ) * $sample;
			printf "%10.2f (%4d)", $avg, $lastpoint;
			
			# debug output
			# printf( stderr "%4d  %12.6f\n", ($arr_element - 1), $points[($arr_element - 1)]);
		}
				
	} else {
		printf  "%20s\n","No POS";
      	}
      } else {
	printf  "%20s\n","NA";
      }

      # Ouput average of period beyond maximum positive peak, if any
      if($polar =~ /n/i){      	
      	if($n_v !=  10000){
      		
		printf  "%62s%20.2f%10.2f\n",$n_e,$n_v,$n_l;

		# Get voltage points from matrix for electrode $n_e
		@points = split(/\s+/, $matrix{$n_e});

		# Define the starting array element for the average 
		# at one sample point beyond the latency of peak at $n_l
		$arr_element = ( ($n_l + $sample) - $epoch_s ) / $sample;

		# Define the number of array elements to average for $period
		$elements = $period / $sample;
		
		# Add all voltage values for $period, $number times
		for ($i = 0; $i < $number; $i++){

			# debug output
			#printf( stderr "%4d  %12.6f  ", $arr_element, $points[$arr_element]);

			for ($e = 0; $e < $elements; $e++){
				
				# For each element, add another value and update element index
				$sum += $points[$arr_element++];
			}
			$avg = $sum / $elements; $sum = 0;
			
			# output average
			$lastpoint = ( ($arr_element - 1) + ($epoch_s / $sample) ) * $sample;
			printf "%10.2f (%4d)", $avg, $lastpoint;
			
			# debug output
			# printf( stderr "%4d  %12.6f\n", ($arr_element - 1), $points[($arr_element - 1)]);
		}
		
	} else {
		printf  "%82s\n","No NEG";
	}
      } else {
		printf  "%82s\n","NA";
      }
    }
  }
  close(AREA);
}


sub HELP {
  print "\a\n","REGION_PEAKS_AVERAGE\n\n",

  "REGION_PEAKS_AVERAGE will identify electrodes with a maximum positive\n",
  "or negative peak among regions of electrodes, within a window specified.\n",
  "It will output the average of a period x for number x periods after the peak.\n\n",
  
  "INPUT:  The input should be a text file with rows of electrodes\n",
  "and columns of data points.  The input should not contain any electrode\n",
  "numbers or labels.\n\n",

  "OUTPUT:  The output is a text report of the average over period x after\n",
  "each peak detected for each region specified, for each window specified.\n\n",

  "USEAGE:  region_peaks_avg   -epoch x x  -sample x  -period x -number x -area <file>\n",
  "                            -file <file> [-h]\n\n",

  "-epoch x x     Specifies total epoch, in msec (e.g., -100 900).\n",
  "-sample x      Specifies sample rate, in msec.\n",
  "-period x	  Window to average, in msec.\n",
  "-number x	  Number of consecutive periods to average.\n",
  "-file <file>   Specifies data file.\n\n",

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

  "-h             Provides this helpful information.\n\n";
  exit;
}












