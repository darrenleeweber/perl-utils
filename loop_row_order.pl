#! perl

# Define location of processing scripts and datafiles
$scriptpath = "D:\\My\ Documents\\programming\ \&\ html\\perl\\";
$datapath = "D:\\My\ Documents\\emse_data\\ptsd-pet\\link14hz\\";

$cond = "oac_link14hz.txt";		# define filename matching expression
$orig = ".txt";			# original input filename extension
$repl = "_elec_order.txt";	# replacement output filename extension

use File::Find;
find(\&files, $datapath);		# Find and process all files in $datapath
exit;

sub files {
  if(/$cond/){				# Only process files matching $cond filename
    
    $input = $_;
    ($output = $input) =~ s/$orig/$repl/;	# create output filename, based on input filename

    printf STDERR ";;;\t$input\t$output\n";

    # Process file

    system("perl \"${scriptpath}row_order.pl\" -file \"${datapath}$input\" > \"${datapath}$output\"");

    # Check size of output data matrix
    system("perl \"${scriptpath}rowXcol.pl\" -f \"${datapath}$output\"");

    exit;

  }
}












    #} elsif( $input =~ /ouc/ ){
    #   print STDERR "\n;;;\t$input\t$output  unattended common\n";
    #  system("perl \"${scriptpath}region_peaks.pl\" -epoch -200 1500 -sample 2.5 -area \"${area}\" -file \"${datapath}$input\" -out \"${datapath}$output\"");
    #}

