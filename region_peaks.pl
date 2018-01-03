#! perl

# Set output directory to current directory and go there
$wd = `pwd`; chop($wd); $wd .= "/"; chdir "$wd";
$od = "div_region";
$ed = "div_exact";

# Get input parameters
while(<@ARGV>){
  if(/-epoch/)    { shift; $epoch_s = shift; $epoch_e = shift; }
  if(/-sample/)   { shift; $sample = shift; }
  if(/-area/)     { shift; $area = shift; }
  if(/-expin/)    { shift; $expin = shift; }
  if(/-expout/)   { shift; $expout = shift; }
  if(/-conin/)    { shift; $conin = shift; }
  if(/-conout/)   { shift; $conout = shift; }
  if(/-lat_range/){ shift; $lat_range = shift; }
  if(/-h/)        { shift; &HELP; }
}

&CHECK_INPUTS;  #print "All checked O.K.\n"; exit;  # Debug

# Put input into array @v and search for maximum peaks
$f = 0;  $l = ($epoch_e - $epoch_s) / $sample;

print STDERR "\n;;; Searching for maximum peaks in electrodes:\n";

$input = $expin;
$cond = "exp";
&PARSE_INPUT;

if($conin){
  $input = $conin;
  $cond = "con";
  &PARSE_INPUT;
}

print STDERR "\n\n;;; Searching for maximum peaks in regions and creating output.\n";

&MAXPEAKS;

exit;

#######################################################################
# Subroutines

sub PARSE_INPUT{
  open(INPUT, "$input") || die "\nCan't open $input\n\n";
  $e = 0;
  while (<INPUT>){
    $e++; printf STDERR " %5d",$e;
    if($e > 124){
      print STDERR "\n;;; Warning: more than 124 rows in input file.\n\n";
    }
    if     (/"/){	#"
	    @dat = split(/"/);	#"
	    @v = split(/\s+/,pop(@dat));
    } elsif(/'/){ #'
	    @dat = split(/'/);	#'
	    @v = split(/\s+/,pop(@dat));
    } else {     
	    @v = split;
    }
    &GETPEAKS;
  }
  close(INPUT);
}


###############################################################
sub GETPEAKS {
  $v = $v[$f];			# First value
  $n = $f + 1;			# Next Value index
  $lat = ($f * $sample) + $epoch_s; # Latency of First Value
  while($n <= $l){		# While next value index <= last value index
    if($v > $v[$n]){
      $v = $v[$n]; $n++;
      $lat += $sample;	# increase latency by 1 x sample rate
      if($v > $v[$n]){	# check next value
	next;
      } else {
    	$i = "${cond}_${e}_$lat"; $neg{$i} = $v;
        #printf STDERR ";;;\t%-10s %10.4f\n",$i,$neg{$i};  # for debug tracing
      }
    } elsif($v < $v[$n]){
      $v = $v[$n]; $n++;
      $lat += $sample;	# increase latency by 1 x sample rate
      if($v < $v[$n]){	# check next value
	next;
      } else {
        $i = "${cond}_${e}_$lat"; $pos{$i} = $v;
        #printf STDERR ";;;\t%-10s %10.4f\n",$i,$pos{$i};  # for debug tracing
      }
    } elsif($v == $v[$n]){
      $v = $v[$n]; $n++;
      $lat += $sample;	# increase latency by 1 x sample rate
    }
  }
}

###############################################################
sub MAXPEAKS {

  if($expout){ open(STDOUT, ">$expout") || die "Can't redirect STDOUT to $expout\n"; }
  printf "\n%-8s %-40s%17s%10s","","All",""," Selected";
  printf "\n%-8s:%-40s:%17s:%10s:%10s:%10s:%10s\n\n","Region","Electrodes","Time Window","Electrode","Positive","Negative","Latency";

  if($conout){
    open(CON, ">$conout") || die "Can't open output file $conout\n";
    printf CON "\n%-8s %-40s%17s%10s","","All",""," Selected";
    printf CON "\n%-8s:%-40s:%17s:%10s:%10s:%10s:%10s\n\n","Region","Electrodes","Time Window","Electrode","Positive","Negative","Latency";
  }

  open(AREA, "$area") || die "\nCan't open AREA file to sort peaks.\n";
  while(<AREA>){
    s/[\r\n\f]//g;		# remove returns, new lines, and form feeds
    @area = split(/\s?:\s?/);
    @times = split(/,\s*/, $win{$area[0]});
    $first = "first";
    foreach $t (@times){

      @t = split(/\s+/, $t); $ws = $t[0]; $we = $t[1]; $polar = $t[2];

      if($first){
	printf "%-8s:%-40s:%7.1f - %7.1f:",$area[0],$area[1],$ws,$we;
	if($conout){ printf CON "%-8s:%-40s:%7.1f - %7.1f:",$area[0],$area[1],$ws,$we; }
	$first = "";
      } else {
	printf "%-8s:%-40s:%7.1f - %7.1f:","","",$ws,$we;
	if($conout){ printf CON "%-8s:%-40s:%7.1f - %7.1f:","","",$ws,$we; }
      }

      ####################################################################
      # Find peaks in exp condition

      $p_v = -10000; $p_l = ""; $p_e = "";	# initialise +ve volt, latency, electrode
      $n_v =  10000; $n_l = ""; $n_e = "";	# initialise -ve volt, latency, electrode

      $lat = $ws; $end = $we;			# initialise search window latencies
      while ($lat <= $end){
      
    	foreach $elec (split(/\s+/, $area[1])){
    
    	  $i = "exp_${elec}_$lat";		# index into peaks hash for exp condition
    
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

      ####################################################################
      # Use exp condition peak electrodes to determine con condition peaks
      if($conin){

	$cp_v = -10000; $cp_l = ""; $cp_e = "";		# initialise +ve volt, latency, electrode
	$cn_v =  10000; $cn_l = ""; $cn_e = "";		# initialise -ve volt, latency, electrode

	# Use $p_e from exp condition, or skip peak
	if($p_e){

	  # initialise search window latencies
	  if($lat_range){
	    $lat = $p_l - ($sample * $lat_range);
	    $end = $p_l + ($sample * $lat_range);
	  }else{
	    $lat = $ws; $end = $we;
	  }

	  while ($lat <= $end){
      
	    $i = "con_${p_e}_$lat";		# index into peaks hash for con condition
    
	    # Determine maximum positive peak
	    if($pos{$i} ne ""){
	      if($cp_v < $pos{$i}){
		$cp_v = $pos{$i}; $cp_l = $lat; $cp_e = $p_e;
	      }
	    }
	    $lat += $sample;
	  }
	}

	# Use $n_e from exp condition, or skip peak
	if($n_e){

	  # initialise search window latencies
	  if($lat_range){
	    $lat = $n_l - ($sample * $lat_range);
	    $end = $n_l + ($sample * $lat_range);
	  }else{
	    $lat = $ws; $end = $we;
	  }

	  while ($lat <= $end){

	    $i = "con_${n_e}_$lat";		# index into peaks hash for con condition
        
	    # Determine maximum negative peak
	    if($neg{$i} ne ""){
	      if($cn_v > $neg{$i}){
		$cn_v = $neg{$i}; $cn_l = $lat; $cn_e = $n_e;
	      }
	    }
	    $lat += $sample;
	  }
	}
      }
      ####################################################################


      ####################################################################
      # Ouput maximum positive peak, if any
      if($polar =~ /p/i){

      	if($p_v != -10000){
	  printf "%10s:%10.2f:%10s:%10.2f\n",$p_e,$p_v,"",$p_l;
	  if($conout){
	    if($cp_v != -10000){
	      printf CON "%10s:%10.2f:%10s:%10.2f\n",$cp_e,$cp_v,"",$cp_l;
	    } else {
	      printf CON "%10s:%10s:%10s:%10s\n","","NoPOS","","";
	    }
	  }
	} else {
	  printf "%10s:%10s:%10s:%10s\n","","NoPOS","","";
	  if($conout){ printf CON "%10s:%10s:%10s:%10s\n","","NoPOS","",""; }
	}
      } else {
    	printf "%10s:%10s:%10s:%10s\n","","NA","","";
	if($conout){ printf CON "%10s:%10s:%10s:%10s\n","","NA","",""; }
      }

      # Ouput maximum negative peak, if any
      if($polar =~ /n/i){      	
      	if($n_v !=  10000){
	  printf "%-8s:%-40s:%17s:%10s:%10s:%10.2f:%10.2f\n","","","",$n_e,"",$n_v,$n_l;
	  if($conout){
	    if($cn_v !=  10000){
	      printf CON "%-8s:%-40s:%17s:%10s:%10s:%10.2f:%10.2f\n","","","",$cn_e,"",$cn_v,$cn_l;
	    } else {
	      printf CON "%-8s:%-40s:%17s:%10s:%10s:%10s:%10s\n","","","","","","NoNeg","";
	    }
	  }
	} else {
    	  printf "%-8s:%-40s:%17s:%10s:%10s:%10s:%10s\n","","","","","","NoNeg","";
          if($conout){ printf CON "%-8s:%-40s:%17s:%10s:%10s:%10s:%10s\n","","","","","","NoNeg",""; }
    	}
      } else {
        printf "%-8s:%-40s:%17s:%10s:%10s:%10s:%10s\n","","","","","","NA","";
        if($conout){ printf CON "%-8s:%-40s:%17s:%10s:%10s:%10s:%10s\n","","","","","","NA",""; }
      }
    }
  }
  close(AREA);
  if($conout){ close(CON); }
}



###############################################################
sub CHECK_INPUTS {

	# Check input parameters
	unless ($epoch_s && $sample && $area && $expin){
	  die "\a\nPlease specify all essential parameters.\n\n",
	  "Use region_peaks.pl -h for help.\n\n",
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
	  if(/^#/){ next; }	# ignore comment lines
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
}

###############################################################
sub HELP {
  print "\a\n","REGION_PEAKS\n\n",

  "REGION_PEAKS will identify electrodes with a maximum positive\n",
  "or negative peak among regions of electrodes, within a window specified.\n\n",

  "INPUT:  The input should be a text file with rows of electrodes\n",
  "and columns of data points.  The input should not contain any electrode\n",
  "numbers or labels.\n\n",

  "OUTPUT:  The output is a text report of peaks detected for each region\n",
  "specified, for each window specified.\n\n",

  "USEAGE:  region_peaks.pl   -epoch x x  -sample x  -area <file>\n",
  "                           -expin <file> [-expout <file>]\n",
  "                          [-conin <file>  -conout <file>]\n",
  "			     [-lat_range <x>][-h]\n\n",

  "-epoch x x     Specifies total epoch, in msec (e.g., -100 900).\n",
  "-sample x      Specifies sample rate, in msec.\n\n",

  "-expin <file>  Specifies data file (experimental condition).\n",
  "-expout<file>  Specifies output file (experimental condition).\n",
  "               Optional, with default output to STDOUT.\n\n",

  "-conin <file>  Specifies data file (control condition).\n",
  "-conout<file>  Specifies output file (control condition).\n",
  "               Control condition is optional. When specified,\n",
  "               electrode for peak detection will be determined\n",
  "               by experimental condition.\n",
  "-lat_range <x> If specified, finds control condition peak within\n",
  "		  given latency range of experimental condition peak,\n",
  "		  where con_lat = exp_lat +/- (<x> * sample rate).\n",
  "		  If not specified, uses window of area file.\n\n",

  "-area <file>   Specifies a file that contains at least one area name,\n",
  "               followed by a colon (:), at least one electrode for that\n",
  "               area, another colon (:), and at least one time window\n",
  "               (in msec) to search for peak activity.  For example:\n\n",

  "               REGION_A: 1: 50 150 (P)\n\n",
  "               REGION_B: 1 2 4 8 10: -200 -50 (P), 0.0 100 (N), 400 600 (P)\n\n",

  "               Note that more than one time window can be specified.\n",
  "               Each time window specification contains an initial time,\n",
  "               followed by a space, and a finish time.  It also contains\n",
  "               an indication of the polarity of the peak. For multiple \n",
  "               time windows, separate each by a comma (,). Note that\n",
  "               zero is 0.0\n\n",

  "               EVERY LINE in the AREA FILE must have ONLY ONE\n",
  "               AREA SPECIFICATION. An area must have >= one electrode(s).\n\n",

  "               All EPOCH and TIME WINDOW values must be\n",
  "               MULTIPLES of the SAMPLE RATE.\n\n",

  "-h             Provides this helpful information.\n\n";
  exit;
}












