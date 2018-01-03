#! /usr/bin/perl

# global declarations
$version = "1.1 (Darren Weber)";
$leftear = "_leftear.$$";
$montage = "_montage.$$";
$bl = 50;
$const = 0.5;
chop ($mypath = `pwd`);

# collect arguments
while(<@ARGV>){
   if(/-f$/) { shift; $filename = shift; }
   if(/-bl/) { shift; $bl = shift; }
   if(/-p/)  { shift; $mypath = shift; }
   if(/-c/)  { shift; $const = shift; }
   if(/-flt/){ shift; $filter = shift; }
   if(/-V/)  { die "Version ${version}\n"; }
   if(/-h/)  { &HELP; }
}

print "\nMATHEARS version $version\n\n";

# Exit if no filename
unless ( $filename ) {
  die "\nProcess Terminated\n\n","Use: mathears -f <filename_prefix>\n\n",
      "Learn more about mathears using: mathears -h\n\n";
}

#Create electrode table
print "Creating electrode table for $filename\n\n";
system "tbcat $mypath/$filename~.dat > $montage";

#Produce a leftear table and multiply each value by 0.5
print "Creating left ear table, equivalent in size\n",
      "to the electrode table: $filename~.dat\n\n";
$tmp_le = "tmp.le.$$";
open(DATA,"$filename~.dat");
while (<DATA>){
  system "cat $mypath/$filename.le.dat >> $tmp_le";
}
system "tbcat $tmp_le | tbrot | tbmul -k $const | tbrot > $leftear";

#Subtract left ear table from each row of the electrode table
print "Creating linked ears table for $filename\n\n";
if ($filter){
  system "tbmath $montage -s $leftear | tbbl -n $bl | tbtri -n $filter > $mypath/$filename.tbl";
} else {
  system "tbmath $montage -s $leftear | tbbl -n $bl > $mypath/$filename.tbl";
}

system "rm $tmp_le";
system "rm $leftear";
system "rm $montage";

print "Finished\n";



sub HELP {
  die "\n",
    "Program to multiply a timeseries of values (1 row by t cols) by some\n",
    "constant (default 0.5) and subtract it from each row of another text\n",
    "file (124 rows x [t+1] cols) from which the first column is to be \n",
    "discarded prior to subtraction.  The two text files must be named,\n",
    "respectively, as follows:\n",
    " {name}.le.dat\n",
    " {name}~.dat:\n",
    "   \n",
    "The primary application of the program is to correct a table of\n",
    "124ch AERPs referenced to the right ear(re) by subtracting a \n",
    "value equal to half of the left ear activity (le) which has been\n",
    "referenced to the right ear.  This equates to a mathematically \n",
    "balanced ear reference, according to the following formulation\n",
    "for any given scalp site S:\n",    
    "   \n",
    "(S-re)-0.5(le-re)\n",
    "=S-re-0.5le+0.5re\n",
    "=S-0.5(re+le)\n",
    "  \n",
    "Useage:  mathears -f {filename} -bl n -flt n -c n -V -h -p x\n",
    "-f defines the filename prefix\n",
    "-bl defines the number of points over which to baseline\n",
    "   (default = 50)\n",
    "-flt defines the width of a triangular filter.\n",
    "-c defines the constant referred to above (default 0.5)\n",
    "-p defines the path to the files to be operated on\n",
    "    (default is current directory)\n",
    "-V gives the Version number of the program\n",
    "-h gives this message\n",
    "   \n",
    "Output is a table file (124 rows x t cols) called {name}.tbl\n",
    "   \n";
}	
