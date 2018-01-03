#! perl

# Set output directory to current directory and go there
$wd = `pwd`; chop($wd); $wd .= "/"; chdir "$wd";
$od = "div_region";
$ed = "div_exact";

# Get input parameters
while (<@ARGV>) {
  if (/-epoch/) {
    shift; $epoch_s = shift; $epoch_e = shift;
  }
  if (/-sample/) {
    shift; $sample = shift;
  }
  if (/-area/) {
    shift; $area = shift;
  }
  if (/-file/) {
    shift; $file = shift;
  }
  if (/-out/) {
    shift; $out = shift;
  }
  if (/-h/) {
    shift; &HELP;
  }
}

&CHECK_INPUTS;			#print "All checked O.K.\n"; exit;  # Debug

# Put input into array @v
$f = 0;  $l = ($epoch_e - $epoch_s) / $sample;

if ($out) {
  open(STDOUT, ">$out") || die "Can't redirect STDOUT to $out\n";
}

open(FILE, "$file") || die "\nCan't open $file\n\n";
while (<FILE>) {
  $e++; printf STDERR "%5d",$e;
  if ($e > 124) {
    print STDERR "\nWarning: more than 124 rows in input file.\n\n";
  }
  if (/"/){	#"
      @dat = split(/"/);	#"
		   @v = split(/\s+/,pop(@dat));
		 } elsif (/'/){
                @dat = split(/'/); @v = split(/\s+/,pop(@dat));
    } else {     
      @v = split;
    }
  &GETPOINTS;
}
close(FILE);

print STDERR "\n\nCreating output.\n";
&OUTPOINTS;

exit;


#######################################################################
# Subroutines

sub GETPOINTS {

  open(AREA, "$area") || die "\nCan't open AREA file.\n";
  while (<AREA>) {
    if (/^\#/){ next; } 	# ignore comment lines
    s/[\r\n\f]//g;		# remove returns, new lines, and form feeds
    @a = split(/\s?:\s?/);
    @times = split(/,\s*/, $a[2]);
    
    foreach $t (@times) {
      
      $c = ($t - $epoch_s) / $sample;
      $v = $v[$c];		# Potential value at column c
      $i = "${e}_$t"; $point{$i}= $v;
    }
  }
}

##################################################################
##################################################################

sub OUTPOINTS {

  printf "\n%-8s %-40s%17s%10s","","All","","Selected";
  printf "\n%-8s:%-40s:%17s%10s%10s%10s%10s\n\n","Region","Electrodes","Time Point","Electrode","Potential","Latency";

  open(AREA, "$area") || die "\nCan't open AREA file.\n";
  while (<AREA>) {
    if (/^\#/){ next; } 	# ignore comment lines
    s/[\r\n\f]//g;		# remove returns, new lines, and form feeds
    @a = split(/\s?:\s?/);
    @times = split(/,\s*/, $a[2]);
    
    $first = "first";    
    foreach $t (@times) {
      
      if ($first) {
	printf "%-8s:%-40s:%7.1f   %7.1f",$a[0],$a[1],$t,"";
	$first = "";
      } else {
	printf "%-8s:%-40s:%7.1f   %7.1f","","",$t,"";
      }
      
      $avg_p = 0; $div = 0;
      foreach $elec (split(/\s+/, $a[1])) {
	
	$i = "${elec}_$t";
	# printf "%-10s %8.4f\n",$i,$point{$i};    # debug
	
	# Average potential values
	$avg_p += $point{$i};
	$div++;
      }
      $avg_p = $avg_p / $div;
      
      # Ouput average potential value
      printf "%10s%10.2f%10s%10.2f\n","avg",$avg_p,"",$t;
    }
  }
  close(AREA);
}


##################################################################
##################################################################

sub CHECK_INPUTS {

  # Check input parameters
  unless ($epoch_s && $sample && $area && $file){
    die "\a\nPlease specify all essential parameters.\n\n",
        "Use region_points_avg.pl -h for help.\n\n",
	"Note that zero values must be specified as 0.0\n\n";
  }
  
  # Check that epoch values are multiples of the sample rate
  $totalpoints = ($epoch_e - $epoch_s) / $sample;
  $point = $epoch_s - ( $sample * 8 );  $end = $epoch_e + ( $sample * 8 );
  while ( $points <= $end ) {
    $points += $sample; push(@points, $points);
  }
  foreach $p (@points) {
    if ($epoch_e == $p) {
      $sample_ok = "true";
    }
  }
  unless($sample_ok){
    print "\a\nPlease ensure that the sample point is a\n",
      "multiple of the sample rate. Given the epoch start\n",
	"time of $epoch_s, values could be:\n\n";
    foreach $p (@points) {
      printf "%10.2f", $p;
    }
    print "\n\n";
    exit;
  }
	
  # Get and check area parameters
  open(AREA, "$area") || die "\a\nCan't open AREA file $area\n";
  while (<AREA>) {
    if (/^\#/){ next; } 	# ignore comment lines
    s/[\r\n\f]//g;		# remove returns, new lines, and form feeds
    @a = split(/\s*:\s*/);
    $area{$a[0]} = "$a[1]";
    $win{$a[0]} = "$a[2]";
	
    #  print "$a[0]: $area{$a[0]}: "; # Debug
	
    # check that point values are multiples of the sample rate.  This is
    # critical for determining peak values according to an index
    # of both electrode number and TEMPORAL LATENCY.
	
    @times = split(/,\s*/, $win{$a[0]});
    foreach $t (@times) {
	
      #    print " $t,";	# Debug
	
      $sample_ok = "";
      $srange =  $t - ($sample * 8);  $erange =  $t + ($sample * 8);
      foreach $p (@points) {
	if ( $p > $srange && $p < $erange ) {
	  if ($t == $p) {
	    $sample_ok = "true";
	  }
	} elsif ( $p > $erange ) {
	  last;
	}
      }
      unless($sample_ok){
	print "\a\nPlease ensure that the time of $w msec for $a[0] is a\n",
	  "multiple of the sample rate.  Given the epoch start\n",
	    "time of $epoch_s, values could be:\n\n";
	foreach $p (@points) {
	  if ( $p > $srange && $p < $erange ) {
	    printf "%10.2f", $p;
	  } elsif ( $p > $erange ) {
	    last;
	  }
	}
	print "\n\n";
	exit;
      }
    }
  }
  #  print "\n";			# Debug
}

##################################################################
##################################################################

sub HELP {
  print "\a\n","REGION_POINTS_AVG\n\n",

    "REGION_POINTS_AVG will select a specific time point from the\n",
    "timeseries of a region of electrodes and output the average value\n",
    "at that time point across all electrodes in the region.\n\n",

    "INPUT:  The input should be a text file with rows of electrodes\n",
    "and columns of data points.  The input should not contain any\n",
    "electrode numbers or labels.\n\n",

    "OUTPUT:  The output is a text report of average potentials\n",
    "for each region specified, for each time point specified.\n\n",

    "USEAGE:  region_points_avg   -epoch x x  -sample x  -area <file>\n",
    "                             -file <file> [-h]\n\n",

    "-epoch x x     Specifies total epoch, in msec (e.g., -100 900).\n",
    "-sample x      Specifies sample rate, in msec.\n",
    "-file <file>   Specifies data file.\n\n",

    "-area <file>   Specifies a file that contains at least one area name,\n",
    "               followed by a colon (:), at least one electrode for that\n",
    "               area, another colon (:), and at least one time point\n",
    "               (in msec) to determine potential value.  For example:\n\n",

    "               REGION_A: 1: 50\n\n",
    "               REGION_B: 1 2 4 8 10: -200, -50, 0.0, 100\n\n",

    "               Note that more than one time point can be specified.\n",
    "               Each time point can be followed by a comma for multiple\n",
    "               time point specifications.  Note that zero is 0.0\n\n",

    "               EVERY LINE in the AREA FILE must have ONLY ONE\n",
    "               AREA SPECIFICATION. An area must have >= one electrode(s).\n\n",

    "               All EPOCH and TIME POINT values must be\n",
    "               MULTIPLES of the SAMPLE RATE.\n\n",

    "-h             Provides this helpful information.\n\n";
  exit;
}












