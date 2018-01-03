#! /usr/local/bin/perl

while (<@ARGV>){
  if(/-e/){ shift; $exp = shift; } # Define experimental condition
  if(/-c/){ shift; $con = shift; } # Define control condition
  if(/-o/){ shift; $out = shift; } # Define output file (txt)
}

# Convert EMSE avg files into table utility files

$exp_tmp = "$exp.tbl.$$";
$con_tmp = "$con.tbl.$$";
system "cat $exp | EMSE_conv | tbcat > $exp_tmp";
system "cat $con | EMSE_conv | tbcat > $con_tmp";

# Now calculate the difference file

unless($out){ $out = "EMSE_dif.txt"; }
system "tbcat -bin $exp_tmp $con_tmp | tbshuffle | tbdiff | tbtext -f f %12.4f > $out";

# Cleanup

system "rm $exp_tmp $con_tmp";
