#! /usr/bin/perl

while(<@ARGV>){
  if(/-h/){ &HELP; shift; }
  if(/-s/){ shift; $search = shift; }
  if(/-r/){ shift; $replace = shift; }
  if(/-t/){ shift; $test = "y"; }
}
use File::Find;  find(\&files, '.');  # find all files in current working dir
use File::Copy;

sub files {
  if(/$search/) {

    ($nf = $_) =~ s/$search/$replace/;
    
    if($test){
      print "copy \t $_ \t to \t $nf\n";
    } else {
      print "copying \t $_ \t to \t $nf\n";
      copy($_,$nf);
    }
  }
}

sub HELP {
  print
    "\nrename_dos.pl -s <string> -r <string> [-t] [-h]\n\n",

    "-s <string>  a search string to be replaced in the filenames.\n",
    "-r <string>  a string to replace the 'search string', to give a newname\n",
    "-t           test only, do not copy and files.\n\n",

    "All files in the current directory '.' are available for renaming.\n",
    "Only those files containing the search string will be copied to a\n",
    "new file, with the search string replaced by the 'replace string'.\n\n",

    "eg,  perl rename_dos.pl -s txt -r dat -t\n\n";
  exit;
}
