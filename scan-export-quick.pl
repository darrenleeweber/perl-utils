#!/usr/bin/perl

$e1 = 1;
$e2 = 128;

while (<@ARGV>){
  if (/-e/)    { shift; $e1 = shift; $e2 = shift; @label = ();}
  if (/-1020/) { @label = (FP1,FP2,F3,F4,C3,C4,P3,P4,O1,O2,F7,F8,T3,T4,T5,T6,CZ,FZ,PZ); }
  if (/-label/){
    @label = (); shift; $tmp = shift;
    while ( ($tmp) && !($tmp =~ /^-/) ) {
      push(@label,$tmp); $tmp = shift;
    }
    unshift(@ARGV,$tmp);
  }
  if (/-tb/)   { $tb = "yes"; shift; $tbfile = shift; }
  if (/-se/)   { $se = "yes"; shift; $sefile = shift; }
  if (/-h/)    { &HELP; }
}

# check command options
if ($se && (! $sefile)){ $sefile = "sevalues" ; }
if (!($e1 && $e2)){ die "\a\n","SCAN-EXPORT: Please specify -e x1 x2\n\n"; }

$dir = `pwd`;
system "pushd $dir";

$input = "input.$$";
system "tr -d '\r' > $input";

if ($label[0]){
  open (INPUT, "$input") || die "\n","Sorry, couldn't open INPUT\n\n";
  MATCHLABEL: while (<INPUT>) {
    if (/^Standard deviation values/){ last MATCHLABEL; }
    @val = split(\',$_);

    print "$val[0] $val[1]\n";
    exit 1;


    ($l = $val[1]) =~ s/\'//g;
    $data{$l} = $val[2];
  }
  close(INPUT);  system "rm $input";

  foreach $k (sort keys %data){
      printf "%1s%10s%1s ", "\"", $k, "\"";
      print "$data{$k}";
  }

} else {

  if ($se){ 
    $tmp_se1 = "tmp_se1.$$"; 
    open(TMPSE1,">>$tmp_se1") || die "\n","Sorry, couldn't open TMPSE1\n\n";
  }
  if ($tb){ 
    $tmp_tb = "tmp_tb.$$";
    open(TMPTB,">>$tmp_tb") || die "\n","Sorry, couldn't open TMPTB\n\n";
  }

  foreach $e ("$e1".."$e2"){
    open (INPUT, "$input") || die "\n","Sorry, couldn't open INPUT\n\n";
    MATCH: while (<INPUT>) {
      s/\'//g;
      if ($se && (/^(\s+)$e(\s+)/)){ print TMPSE1; }
      if ($tb && (/^(\s+)$e(\s+)/)){
	@val = split;
	$n = 0;
	foreach $v (@val){
	  if ($n == 0) {
	    print "\"$v\"   "; 
	  } elsif ($v =~ /(\d+)/) {
	    print TMPTB "$v ";
	  }
	  $n++;
	}
	print TMPTB "\n";
	last MATCH;
      } elsif (/^(\s+)$e(\s+)/) {
	@val = split;
	$n = 0;
	foreach $v (@val){
	  if ($n == 0) {
	    printf "%1s%10d%1s  ", "\"", $v, "\""; 
	  } elsif ($v =~ /(\d+)/) {
	    printf " %10.4f", $v;
	  }
	  $n++;
	}
	print "\n";
	last MATCH;
      }
    }
    close(INPUT);
  }

  system "rm $input"; if ($se){ close(TMPSE1); } if ($tb){ close(TMPTB); }

  # Put output into table format, if requested.
  if    ($tb && $tbfile){ system "tbcat $tmp_tb > $tbfile.tbl"; }
  elsif ($tb) {           system "tbcat $tmp_tb"; system "rm $tmp_tb"; }

  if ($se){

    if (-s "$sefile.se"){ system "rm $sefile.se"; }

    # create binary electrode co-ordinate table > _elec.tbl
    system "tbcat /users/psdlw/bin/elec.dat | tbcolrm -f 1 | tbscanelec -radius 1000 | tbrot | tbmul -k 0.007 > _elec.tbl ";

    $tmp_se2 = "tmp_se2.$$";
    system "tbcat $tmp_se1 | tbrot | tbtext -f r > $tmp_se2";
    system "rm $tmp_se1";

    open(TMPSE2, "$tmp_se2") || die "\n","Sorry, couldn't open TMPSE2\n\n";

    while (<TMPSE2>) {
      $n++; if ($n == 1){ @electrodes = split(/\s+/); } $nth = $n;
      if ((chop $nth) =~ /[13579]/) {
	open(TBSE, "| tbcat | tbmul -k -1 | tbcat -bin _elec.tbl - | tbmapint -surface -m 3 -omega2 0.5 -radius -1 -quiet | tbtext >> $sefile.se" ) || die "\n","Sorry, couldn't open TBSE\n\n";
	print TBSE; close(TBSE);
      }
    }
    close(TMPSE2); system "rm $tmp_se2"; system "rm _elec.tbl";
  }
}

system "popd";

sub HELP {
  die "\n\a", "SCAN-EXPORT\n\n",
  "Usage: scan-export [-e x1 x2] [-1020] [-label <LABEL> ... <LABEL>]\n",
  "                   [-tb <filename>] [-se <filename>] [-h]\n\n",
  "-e x1 x2       specifies a range of electrodes (default is 1..128).\n",
  "               Note: It will not use any named electrodes, such\n",
  "                     as LEFTEAR, VEOGR, GFP, etc.  It will only\n",
  "                     print values for electrodes x1 .. x2, unless\n",
  "                     the -label option is specified.\n",
  "-1020          selects a set of standard 10-20 electrode labels.\n",
  "-label <LABEL> selects the LABELED waveform(s) (e.g., LEFT for LEFT EAR,\n",
  "               GFP, etc.). Multiple <LABEL>s can be specified to\n",
  "               select specific waveforms.  Specify individual\n",
  "               waveforms to obtain output for various\n",
  "               electrodes (10, 20, 70, etc.).\n",
  "               Default is standard 10-20 electrodes, as follows:\n",
  "               FP1,FP2,F3,F4,C3,C4,P3,P4,O1,O2,F7,F8,T3,T4,T5,T6,CZ,FZ,PZ\n",
  "-tb <filename> prints the output in table format to <filename>.tbl.\n",
  "               If no <filename> is specified, it prints the output\n",
  "               in table format to the standard output.\n",
  "-se <filename> prints surface energy values into <filename>.se\n",
  "               (default is *sevalues.se*) for every second time\n",
  "               slice of the input data file.\n",
  "-h             specifies this help information.\n\n",
  "SCAN-EXPORT accepts a text file (*.dat) created by the ASCII-EXPORT\n",
  "command (in which you must specify ROWS=elect) of the STATS module\n",
  "of SCAN. It prepares the *.dat file for use with the table utilities.\n",
  "If the -label option is specified, then only the specified subset of\n",
  "the input text file will be selected for output as text only.  The\n",
  "default text output of electrodes and their corresponding voltage\n",
  "values can be input into tbcat, which will create a binary table that\n",
  "can be used with any table utility.  Alternatively, you can use the\n",
  "-tb <filename> option to print the output of SCAN-EXPORT in table\n",
  "format into <filename>.tbl, which can be later input into the table\n",
  "utilities.  If the -tb option is specified with no <filename>, the\n",
  "standard output of SCAN-EXPORT will be in table format, which can be\n",
  "piped directly into a table utility. For information about the table\n",
  "utilities, use 'man tb'.\n\n",
  "If the -se <filename> option is selected, SCAN-EXPORT will also print\n",
  "surface energy values for every second time slice (column) of the\n",
  "input data file to <filename>.se. Note that the calculation of surface\n",
  "energy values is a very slow process. Also, note that the sample rate\n",
  "of the resulting surface energy waveform will be twice the input data\n",
  "sample rate.  The resulting surface energy waveform can be viewed by\n",
  "using the following:\n\n",
  "tbcat <filename>.se | tbrot | tbxpl -sample x -offset x\n\n";
}
