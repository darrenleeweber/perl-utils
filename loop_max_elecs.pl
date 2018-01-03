#! perl

$scriptpath = "D:\\My\ Documents\\programming\ \&\ html\\perl\\";
$path = "D:\\My\ Documents\\emse_data\\ptsd-pet\\grand_mean\\";
$cond = ".txt";
$rep = ".txt";		# replace filename text (input file)
$sub = "_elecmax.txt";	# substitute filename text (output file)

use File::Find;
find(\&files, $path);
exit;

sub files {
	if(/$cond/){

		$input = $_;
		($output = $input) =~ s/$rep/$sub/;
		printf STDERR "$input    $output\n";
		system("cat \"$path$input\" | perl \"${scriptpath}max_elecs\@points.pl\" > \"$path$output\"");
	}
}

