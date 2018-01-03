#! /usr/bin/perl

while(<@ARGV>){

  if(/-epoch/) { shift; $epoch_s = shift; $epoch_e = shift; }
  if(/-sample/){ shift; $sample = shift; }
  if(/-win/)   { shift; $win_s = shift;  $win_e = shift; }
  if(/-h/)     { shift; &HELP; }
}

unless ($win_s && $sample && $epoch_s){
  die "\a\n\nmatrix_ascii_maxmin_win.pl\n\n",
      "Please specify the following parameters:\n\n",
      "   epoch start and finish in msec (-epoch x x)\n\n",
      "   sample rate in msec (-sample x)\n\n",
      "   window for search, start and finish in msec (-win x x)\n\n";
}

while (<>){
  @points = split; $min = 1000000; $max = -1000000; $n = 0;
  foreach $p (@points){
    $n++; $lat = ( $epoch_s + ( ($n - 1) * $sample ) );
    if(($lat >= $win_s)&&($lat <= $win_e)){
      if($p < $min){ $min = $p; $min_lat = $lat; }
      if($p > $max){ $max = $p; $max_lat = $lat; }
    }
  }
  $e++; write;
}

format =
@##  @#####.######  @####       @#####.######  @####
$e   $min           $min_lat    $max           $max_lat
.


#################################################################################
sub HELP {
  print "@ARGV[0]\n";

  die "\a\n","matrix_ascii_maxmin_win.pl\n\n",

  "Provides minimum and maximum values for each row of input ascii data,\n",
  "within an 'epoch window' specified.\n\n",

  "Input is ascii text with 'rows=electrodes' & 'columns=EEGsamples';\n",
  "there should be no electrode numbers or labels, just integer or\n",
  "floating point values separated by whitespace.\n\n",

  "The output is rows of min/latency & max/latency pairs,\n",
  "where latency is determined by the -epoch and -sample parameters.\n\n",

  "Useage: matrix_ascii_maxmin_win.pl [-epoch x x][-sample x][-win x x][-h]\n\n",

  "-epoch x x   Specifies the epoch interval, in msec (e.g., -100 900).\n",
  "-sample x    Specifies the sample rate, in msec.\n",
  "-win x x     Specifies the window (in msec) in which to search for\n",
  "             minimum and maximum values.\n",
  "-h           Provides this helpful information ;-)\n\n";
}
