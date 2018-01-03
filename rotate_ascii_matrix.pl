#! perl

$scriptpath = "D:\\My\ Documents\\programming\ \&\ html\\perl\\";
$path = "D:\\My\ Documents\\emse_data\\ptsd-pet\\grand_mean\\";
$cond = "txt";

foreach $f (`ls "$path"`){

    unless($f =~ /$cond/ and $f =~ /link/){ next; }
	chop($f);
	
	($asc = $f) =~ s/txt/asc/;
	
    print STDERR "\n$f  $asc\n";
	system("perl \"${scriptpath}row2col.pl\" -c 124 -f \"${path}$f\" > \"${path}$asc\"");
	system("perl \"${scriptpath}rowXcol.pl\" -f \"${path}$asc\"");

	exit;

}
