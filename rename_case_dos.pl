#! /usr/local/bin/perl

$path = "D:\\My\ Documents\\emse_data\\ptsd-pet\\linked_14hz\\";

$ext = ".txt";	# text to replace
$sub = ".asc";	# text to substitute
$cond_copy = "asc";  # specify conditional copying of these files

&CASE;
use File::Find;
find(\&files, $path);

sub files {
	($nf = $_) =~ s/([A-Z])/$lower{$1}/g;

	if($sub){
		$nf =~ s/$ext/$sub/;	# add extra element to filename
	}

	if($nf =~ /$cond_copy/i) {
		print "$nf\n";
		system "copy $_ \"$path$nf\"";
	}
}

sub CASE {
	# Define a hash with Upper case keys and Lower case values
	@lower = (a..z); @upper = (A..Z); $n = 0;
	foreach $u (@upper){  $lower{$u} = $lower[$n]; $n++; }
}
