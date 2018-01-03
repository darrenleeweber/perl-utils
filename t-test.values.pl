#! /usr/bin/perl

chdir `pwd`;

chop($od = `pwd`); $od .= "/";
$f = "t_values";
%sig = (
	  "-0.000010", "-12", # -ve p values used for a < b tail
	  "-0.000100", "-10",
	  "-0.001000",  "-8",
	  "-0.010000",  "-6",
	  "-0.050000",  "-4",
	  "-0.100000",  "-2",

	   "0.000000",   "0", # preset value of $t_sig below is 0

	   "0.100000",   "2",
	   "0.050000",   "4",
	   "0.010000",   "6",
	   "0.001000",   "8",
	   "0.000100",  "10",
	   "0.000010",  "12"  # +ve p values used for a > b tail
	);

while (<@ARGV>){
  if (/-od/)    { shift; $od = shift; }
  if (/-f/)     { shift; $f = shift; }
  if (/-sample/){ shift; $sample = shift; }
  if (/-offset/){ shift; $start = shift; }
  if (/-plot/)  { shift; $pl = "yes"; }
  if (/-h/)     { shift; &HELP; }
}

FINDEXPR: while (<>){
  if (/;Cu/)     { ($sig = $_) =~ s/\D+//; chop($sig); }
  if (/TMAX_t1/) { @tm_t1 = split;
		   $tm_t1{$sig} = $tm_t1[2];
		   $tm_o        = $tm_t1[3];
		   $tm_p1       = $tm_t1[4];
		 }
  if (/TMAX_t2/) { @tm_t2 = split;
		   $tm_t2{$sig} = $tm_t2[2];
		   $tm_p2       = $tm_t2[4];
		 }
  if (/TSUM_t1/) { @ts_t1 = split;
		   $ts_t1{$sig} = $ts_t1[2];
		   $ts_o        = $ts_t1[3];
		   $ts_p1       = $ts_t1[4];
		 }
  if (/TSUM_t2/) { @ts_t2 = split;
		   $ts_t2{$sig} = $ts_t2[2];
		   $ts_p2       = $ts_t2[4];
		 }
  if (/ABSUM_t1/){ @as_t1 = split;
		   $as_t1{$sig} = $as_t1[1];
		   $as_o        = $as_t1[2];
		   $as_p1       = $as_t1[3];
		 }
  if (/ABSUM_t2/){ @as_t2 = split;
		   $as_t2{$sig} = $as_t2[1];
		   $as_p2       = $as_t2[3];
		 }
  if (/"EXPR    "/)   { @tvalues = split; }
}

if(-s "$od$f"){ system "rm $od$f"; }
open(T_VAL,">>$od$f") || die "Sorry, can't open T_VAL\n\n";

if($pl){ 
  if(-s "$od$f.t1.plot"){ system "rm $od$f.t1.plot"; }
  open(T_VAL_P1,">>$od$f.t1.plot") || die "Sorry, can't open T_VAL_P1\n\n";
  if(-s "$od$f.t2.plot"){ system "rm $od$f.t2.plot"; }
  open(T_VAL_P2,">>$od$f.t2.plot") || die "Sorry, can't open T_VAL_P2\n\n";
}
# Output Tsum Values
print T_VAL "\nTSUM observed value is $ts_o, p = $ts_p1, 1-tailed.\n\n";
print T_VAL "TSUM critical values are:\n\n";
print T_VAL "Probability      One Tailed        Two Tailed\n\n";
foreach $s ( sort keys %ts_t1){
  printf T_VAL " %8.6f      %12.6f      %12.6f\n", $s, $ts_t1{$s}, $ts_t2{$s};
}
# Output ABsum Values
print T_VAL "\nABSUM observed value is $as_o, p = $as_p1, 1-tailed.\n\n";
print T_VAL "ABSUM critical values are:\n\n";
print T_VAL "Probability      One Tailed        Two Tailed\n\n";
foreach $s ( sort keys %as_t1){
  printf T_VAL " %8.6f      %12.6f      %12.6f\n", $s, $as_t1{$s}, $as_t2{$s};
}
# Output Tmax Values
print T_VAL "\n\nTMAX observed value is $tm_o, p = $tm_p1, 1-tailed.\n\n";
print T_VAL "Tmax critical values are:\n\n";
print T_VAL "Probability      One Tailed        Two Tailed\n\n";
foreach $s ( sort keys %tm_t1){
  printf T_VAL " %8.6f      %12.6f      %12.6f\n", $s, $tm_t1{$s}, $tm_t2{$s};
}

print T_VAL "\nIndividual t values are:\n\n";

$max = -1000000; $min = 1000000;
unless($sample){ $sample = 1; }
unless($start) { $start = 0; }

foreach $t (@tvalues){
  unless ($t =~ /[""E]/){
    printf T_VAL "%8.1f  %10.6f ", $start, $t;    $start += $sample;

    if($pl){ $t_sig = 0; }
    SIG1: foreach $s ( sort keys %tm_t1 ){

      if     ( $tm_t1{$s} && ($t >= $tm_t1{$s}) ){

	print T_VAL "(p < $s, 1-tailed, a>b) ";
	if($pl){ $t_sig = $s; printf T_VAL_P1 "%4.2f ", $sig{$t_sig}; }
	last SIG1;

      } elsif( $tm_t1{$s} && ($t <= (-1 * $tm_t1{$s}) ) ){

	print T_VAL "(p < $s, 1-tailed, a<b) ";
	if($pl){ $t_sig = (-1 * $s); printf T_VAL_P1 "%4.2f ", $sig{$t_sig}; }
	last SIG1;

      } 
      if($t_sig != 0){ last SIG1; }
    }
    if($pl && ($t_sig == 0)){ printf T_VAL_P1 "%4.2f ", $sig{$t_sig}; }

    if($pl){ $t_sig = 0; }
    SIG2: foreach $s ( sort keys %tm_t2 ){

      if     ( ($tm_t2{$s}) && ($t >= $tm_t2{$s}) ){

	print T_VAL "(p < $s, 2-tailed, a>b) ";
	if($pl){ $t_sig = $s; printf T_VAL_P2 "%4.2f ", $sig{$t_sig}; }
	last SIG2;

      } elsif( ($tm_t2{$s}) && ($t <= (-1 * $tm_t2{$s}) ) ){

	print T_VAL "(p < $s, 2-tailed, a<b) ";
	if($pl){ $t_sig = (-1 * $s); printf T_VAL_P2 "%4.2f ", $sig{$t_sig}; }
	last SIG2;

      }
      if($t_sig != 0){ last SIG2; }
    }
    if($pl && ($t_sig == 0)){ printf T_VAL_P2 "%4.2f ", $sig{$t_sig}; }

    print T_VAL "\n"; if($max < $t){ $max = $t; } if($min > $t){ $min = $t; }
  }
}
print T_VAL "\nMinimum value is $min   Maximum value is $max\n\n";
close(T_VAL); if($pl){ close(T_VAL_P1); close(T_VAL_P2); }

sub HELP {
  print "\a\n","EXACT.VALUES\n\n",

  "A utility to print an ordered series of electrodes/time points\n",
  "and t scores or create a file for mapping of the significant\n",
  "t-scores.  It also identifies the electrodes/time points where\n",
  "the t-values are equal to or exceed critical values.\n\n",
  
  "USEAGE:  exact.values -f <filename> [-od <path>] [-plot]\n\n",
  "                            [-sample x] [-offset x] [-h]\n\n",

  "The input to EXACT.VALUES is provided as standard input <STDIN>\n",
  "and should contain the output file from TBMAKEXACT (?.results).\n\n",
  
  "The output of EXACT.VALUES is placed in <t_values>, unless\n",
  "the -f <filename> is specified, and -od specifies an output\n",
  "directory.\n\n",

  "For topographic data, EXACT.VALUES lists a series of Tmax values\n",
  "for each electrode.  If the -plot option is specified, EXACT.VALUES\n",
  "also creates a file <t_values.plot> that can be used to create\n",
  "topographic maps (see tbtopo).\n\n",

  "For time series data, EXACT.VALUES can be used with the -sample and\n",
  "-offset options to specify the sample rate and first sample point.\n",
  "Note that an offset of zero must be specified as 0.0.  It will then\n",
  "output an ordered series of Tmax values for each sample point in the\n",
  "time series data.\n\n",

  "For example, basic useage consists of:\n\n",

  "cat <fileprefix>.results | exact.values -f <fileprefix>\n\n";

  exit;
}
