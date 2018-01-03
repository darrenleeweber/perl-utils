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

# Put input into array @v and search for peaks
print "\nSearching for peaks from column $f to $l of experimental data.\n";
open(EFILE, "$exp") || die "\nCan't open $exp\n\n";
while (<EFILE>){
  $e++;
  if($e > 124){
    print "\nWarning: more than 124 rows in input file.\n\n",
    "Hint: check that *.dat files are in unix format (use dos2unix).\n\n";
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
} 
close(EFILE);

print "\nSearching for min/max points in regions and creating output files.\n";
unless (-d "$od"){ mkdir ("$od",0777); }
unless (-d "$od/pos"){ mkdir ("$od/pos",0777); }
unless (-d "$od/neg"){ mkdir ("$od/neg",0777); }



# Subroutines




sub HELP {
  print "\a\n","REGION_SAMPLE\n\n",

  "REGION_SAMPLE will identify time points with a maximum positive\n",
  "or negative amplitude in regions of electrodes, within a time window\n",
  "specified or over a whole epoch, for an experimental dataset.\n\n",

  "INPUT:  The input to REGION should be two text files with rows of\n",
  "electrodes and columns of data points.  The input should not contain any\n",
  "electrode numbers or labels.\n\n",

  "OUTPUT:  The output of REGION is two text files for each region\n",
  "specified, which contain a row of all min/max values in an epoch for\n",
  "each region.  These output files are created for both the experimental\n",
  "datafile and a control datafile.\n\n",

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
  "               to search for min/max values. Please note that the win\n",
  "               values should be multiples of the sample rate and that\n",
  "               zero must be specified as 0.0 (or strange things will\n",
  "               happen!).\n",
  "-h             Provides this helpful information.\n\n";
  exit;
}
