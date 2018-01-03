#! /usr/bin/perl

# Set output directory to current directory and go there
$wd = `pwd`; chop($wd); $wd .= "/"; chdir "$wd";
$od = "region.results";

# Get input parameters
while(<@ARGV>){
  if(/-epoch/) { shift; $epoch_s = shift; $epoch_e = shift; }
  if(/-sample/){ shift; $sample = shift; }
  if(/-area/)  { shift; $area = shift; }
  if(/-win/)   { $win = "y"; shift; $win_s = shift; $win_e = shift; }
  if(/-exp/)   { shift; $exp = shift; }
  if(/-con/)   { shift; $con = shift; }
  if(/-od/)    { shift; $od = shift; }
  if(/-h/)     { shift; &HELP; }
}

# Get area parameters
unless($area){ $area = "/users/psdlw/bin/region.def"; }
open(AREA, "$area") || die "\nCan't open AREA file\n";
while(<AREA>){ chop; @a = split(/\s?:\s?/); $area{$a[0]} = "$a[1]"; }

# Check input parameters
unless ($sample && $epoch_s && $exp && $con){
  die "\nPlease specify all essential parameters.\n\n",
      "Use region -h for help.\n\n";
}

# Set first ($f) and last ($l) columns of dataset
if($win){ $f = ($win_s - $epoch_s) / $sample;
	  $l = ($win_e - $epoch_s) / $sample;
} else {  $f = 0;
	  $l = ($epoch_e - $epoch_s) / $sample;
}

# Put input into table format for later electrode selection
print "\nCreating temporary table files of experimental and control data.\n";
system "tbcat $exp > $exp.tbl.tmp" || die "Can't create exp tbl file\n\n";
system "tbcat $con > $con.tbl.tmp" || die "Can't create con tbl file\n\n";

# Put input into array @v and search for peaks
print "\nSearching for peaks from column $f to $l of experimental data.\n";
open(EFILE, "$exp") || die "\nCan't open $exp\n\n";
while (<EFILE>){
  $e++;
  if($e > 124){
    print "\nWarning: more than 124 rows in input file.\n\n",
    "Check that *.dat files are in unix format (use dos2unix).\n\n";
  }
  if(/"/){
    @dat = split(/"/);
    @v = split(/\s+/,pop(@dat));
  } elsif(/'/){
    @dat = split(/'/);
    @v = split(/\s+/,pop(@dat));
  } else {
    @v = split;
  }
  &PEAKS;
} 
close(EFILE);

print "\nSearching for max/min peaks in regions and creating output files.\n";
unless (-d "$od"){ mkdir ("$od",0777); }
unless (-d "$od/pos"){ mkdir ("$od/pos",0777); }
unless (-d "$od/neg"){ mkdir ("$od/neg",0777); }

&SORT_PEAKS;

# Subroutines

sub PEAKS {
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
	$i = "${e}_$lat"; $neg{$i} = $v; # print "$e, $v\n";
      }
    } elsif($v < $v[$n]){
      $v = $v[$n]; $n++;
      $lat += $sample;
      if($v < $v[$n]){
	next;
      } else {
	$i = "${e}_$lat"; $pos{$i} = $v; # print "$e, $v\n";
      }
    } elsif($v == $v[$n]){
      $v = $v[$n]; $n++;
      $lat += $sample;
      $i = "${e}_$lat"; $eq{$i} = $v; # print "$e, $v\n";
    }
  }
}

sub SORT_PEAKS {

  printf "\n%28s%-10s\t %-9s", "", "All","Selected";
  printf "\n%8s%30s\t%10s%10s%10s%10s\n\n","Region","Electrodes","Electrode","Positive","Negative","Latency";

  # Check for and remove any plot files
  if(-s "$od/$exp.p.plt"){ system "rm $od/$exp.p.plt"; }
  if(-s "$od/$exp.n.plt"){ system "rm $od/$exp.n.plt"; }
  if(-s "$od/$con.p.plt"){ system "rm $od/$con.p.plt"; }
  if(-s "$od/$con.n.plt"){ system "rm $od/$con.n.plt"; }

  open(AREA, "$area") || die "\nCan't open AREA file to sort peaks.\n";
  while(<AREA>){
    chop; @a = split(/\s?:\s?/);
    printf "%8s%30s",$a[0],$a[1];

    if($win){ $lat = $win_s;   $end = $win_e;   }
    else    { $lat = $epoch_s; $end = $epoch_e; }

    $p_v = -10000; $p_l = ""; $p_e = "";
    $n_v =  10000; $n_l = ""; $n_e = "";

    while ($lat <= $end){
      foreach $elec (split(/\s+/, $a[1])){

	$i = "${elec}_$lat";

	if($pos{$i} ne ""){
#	  printf "%4s %7.1f %8.4f\n",$elec,$lat,$pos{$i};
	  if($p_v < $pos{$i}){
	    $p_v = $pos{$i}; $p_l = $lat; $p_e = $elec;
	  }
	}

	if($neg{$i} ne ""){
#	  printf "%4s %7.1f %8.4f\n",$elec,$lat,$neg{$i};
	  if($n_v > $neg{$i}){
	    $n_v = $neg{$i}; $n_l = $lat; $n_e = $elec;
	  }
	}
      }
      $lat += $sample;
    }

    if($p_v != -10000){
      printf "%12s%10.2f%20.2f\n",$p_e,$p_v,$p_l;
      system "cat $exp.tbl.tmp | tbselect $p_e | tbtext -f f %10.4f > $od/pos/$exp.$a[0].p";
      system "cat $con.tbl.tmp | tbselect $p_e | tbtext -f f %10.4f > $od/pos/$con.$a[0].p";

      open(PP,">> $od/$exp.p.plt"); printf PP "\"%5s\"",$a[0]; close(PP);
      system "cat $od/pos/$exp.$a[0].p >> $od/$exp.p.plt";
      open(PP,">> $od/$exp.p.plt"); printf PP "\"%5s\"",$a[0]; close(PP);
      system "cat $od/pos/$con.$a[0].p >> $od/$exp.p.plt";
    }

    if($n_v !=  10000){
      printf "%50s%20.2f%10.2f\n",$n_e,$n_v,$n_l;
      system "cat $exp.tbl.tmp | tbselect $n_e | tbtext -f f %10.4f > $od/neg/$exp.$a[0].n";
      system "cat $con.tbl.tmp | tbselect $n_e | tbtext -f f %10.4f > $od/neg/$con.$a[0].n";

      open(NP,">> $od/$exp.n.plt"); printf NP "\"%5s\"",$a[0]; close(NP);
      system "cat $od/neg/$exp.$a[0].n >> $od/$exp.n.plt";
      open(NP,">> $od/$exp.n.plt"); printf NP "\"%5s\"",$a[0]; close(NP);
      system "cat $od/neg/$con.$a[0].n >> $od/$exp.n.plt";
    }
  }
  close(AREA);
  system "rm $exp.tbl.tmp";  system "rm $con.tbl.tmp";
  print "\nCreating text files for excel plots.\n\n";
  system "tbcat $od/$exp.p.plt | tbrot | tbtext -f f %10.4f > $od/$exp.p.txt";
  system "tbcat $od/$exp.n.plt | tbrot | tbtext -f f %10.4f > $od/$exp.n.txt";
  system "rm $od/$exp.*.plt";
}


sub HELP {
  print "\a\n","REGION\n\n",

  "REGION will identify electrodes with a maximum positive or negative\n",
  "peak amplitude in regions of electrodes, within a window specified\n",
  "or over a whole epoch, for an experimental dataset.\n\n",

  "INPUT:  The input to REGION should be two text files with rows of\n",
  "electrodes and columns of data points.  The input should not contain any\n",
  "electrode numbers or labels.  It is advised that the input should be\n",
  "filtered (eg, tbtri -n 21) and that the accuracy of the data should be\n",
  "at least 2 decimal places.\n\n",

  "OUTPUT:  The output of REGION is two text files for each region\n",
  "specified, which contain a row of all values in an epoch for the\n",
  "electrodes with maximum positive and negative values.  These output\n",
  "files are created for both the experimental datafile and a control\n",
  "datafile.\n\n",

  "USEAGE:  region -epoch x x  -sample x  -exp <file>  -con <file>\n",
  "                [-area <file>] [-od] [-win x x] [-h]\n\n",

  "-epoch x x     Specifies total epoch, in msec (e.g., -100 900).\n",
  "-sample x      Specifies sample rate, in msec.\n",
  "-exp <file>    Specifies experimental data file.\n",
  "-con <file>    Specifies control data file.\n\n",

  "The specifications above are essential.  The following are optional.\n\n",

  "-area <file>   Specifies a file that contains at least one area name,\n",
  "               followed by a colon (:) and then a number of electrode\n",
  "               numbers that fall within that area.  The default file is\n",
  "               /users/psdlw/bin/region.def\n",
  "-od            Output directory path.  The default is region.results\n",
  "-win x x       Specifies a window (in msec) of the epoch in which\n",
  "               to search for peak values. Please note that the win\n",
  "               values should be multiples of the sample rate.\n",
  "-h             Provides this helpful information.\n\n";
  exit;
}
