#!/usr/bin/perl

unless(@ARGV){ &HELP; }

while(<@ARGV>){
    if(/-file1/){ shift; $file1 = shift; }
    if(/-file2/){ shift; $file2 = shift; }
    if(/-h/){ &HELP; }
}

unless($file1 && $file2){
    print STDERR "\a\n;;;\tSorry, must specify two input files\n";
    &HELP;
}

open(FILE1, "$file1") || die "\n;;;\tCan't open $file1\n";
open(FILE2, "$file2") || die "\n;;;\tCan't open $file2\n";

while(<FILE1>){ $file1lines++; $file1{$file1lines} = $_; }
while(<FILE2>){ $file2lines++; $file2{$file2lines} = $_; }

if($file1lines = $file2lines){
    for ($i = 0; $i <= $file1lines; $i++){
        print $file1{$i}, $file2{$i};
    }
}elsif($file1lines > $file2lines){
    print STDERR "\a\n;;;\tWarning: File1 longer than File2.\n\n";
    for ($i = 0; $i <= $file1lines; $i++){
        print $file1{$i}, $file2{$i};
    }
}else{
    print STDERR "\a\n;;;\tWarning: File1 shorter than File2.\n\n";
    for ($i = 0; $i <= $file2lines; $i++){
        print $file1{$i}, $file2{$i};
    }
}

exit;







########################################################
sub HELP {
    print <<HELP;

Useage: interleave.pl -file1 <file1> -file2 <file2>

    the output is the rows of file1 and file2 interleaved (file1 first).
    
    If you want the columns interleaved, first transpose the files
    somehow.  The utility matrix_ascii_transpose.pl might be useful
    here, if the files have equal numbers of white-space delimited
    columns.
    
HELP
    exit;
}