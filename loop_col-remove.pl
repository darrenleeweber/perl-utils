#! perl

$scriptpath = "D:\\My\ Documents\\programming\ \&\ html\\perl\\";
$path = "D:\\My\ Documents\\emse_data\\ptsd-pet\\lap14hz\\";
$cond = ".asc";
$rep = ".asc";		# replace filename text (input file)
$sub = ".txt";		# substitute filename text (output file)

use File::Find;
find(\&files, $path);
exit;

sub files {
  if(/$cond/){
    
    $input = $_;
    ($output = $input) =~ s/$rep/$sub/;
    printf STDERR ";;; $input    $output\n";
    system("perl \"${scriptpath}col-remove.pl\" -f \"$path$input\" -c 125 > \"$path$output\"");
    system("perl \"${scriptpath}rowXcol.pl\" -f \"$path$output\"");
  }
}

