#! /usr/bin/perl

while(<@ARGV>){
  if(/-epoch/) { shift; $epoch_s = shift; $epoch_e = shift; }
  if(/-sample/){ shift; $sample = shift; }
  if(/-win/)   { shift; $win_s = shift;  $win_e = shift; }
  if(/-h/)     { shift; &HELP; }
}

unless ($win_s && $sample && $epoch_s){
  system "play /usr/demo/SOUND/sounds/flush.au &";
  die "\n\nMIN.MAX\n\n",
      "Please specify the following parameters:\n\n",
      "   epoch start and finish in msec (-epoch x x)\n\n",
      "   sample rate in msec (-sample x)\n\n",
      "   window for mean, start and finish in msec (-win x x)\n\n";
}

while (<>){
  @points = split; $n = 0; $n_val = 0; $values = 0;
  foreach $p (@points){
    $n++; $lat = ( $epoch_s + ( ($n - 1) * $sample ) );
    if( ( $lat >= $win_s ) && ( $lat <= $win_e ) ){
      $n_val++; $values += $p;
    }
  }
  $e++; $mean = ( $values / $n_val ); write;
}

format =
@##  @#####.######
$e   $mean
.

sub HELP {
  die "\a\n","MEAN.WIN\n\n",
  "Useage:  mean.win [-epoch x x][-sample x][-win x x][-h]\n\n",
  "-epoch x x   Specifies the epoch interval, in msec (e.g., -100 900).\n",
  "-sample x    Specifies the sample rate, in msec.\n",
  "-win x x     Specifies the window (in msec) in which to search for\n",
  "             a mean amplitude value.\n",
  "-h           Provides this helpful information.\n\n",
  "MEAN.WIN will provide a mean value for each electrode in a dataset,\n",
  "within the time window of a total epoch window specified.  The input\n",
  "to MEAN.WIN is a text file with rows of electrodes and columns of data\n",
  "points.  The input should not contain any electrode numbers or labels.\n",
  "The output of MEAN.WIN is rows of electrodes followed by a mean value.\n\n";
}
