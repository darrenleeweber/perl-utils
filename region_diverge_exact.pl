#! /usr/bin/perl

$od = "exact_div_order";

while(<@ARGV>){
  if(/-exp/){ shift; $exp = shift; }
  if(/-con/){ shift; $con = shift; }
  if(/-sub/){ shift; $sub = shift; }
  if(/-od/) { shift; $od  = shift; }
  if(/-sd/) { shift; $sd  = shift; }
}

$cwd = `pwd`;  chop($cwd);

unless(-d "${cwd}/$od"){ mkdir ("${cwd}/$od", 0777); }

chdir("${cwd}/$sd");

foreach $a (`ls`){
  chop($a);
  
  foreach $f (`ls $a/$exp*`){
    chop($f);   @f = split(/\./, $f);   $time = $f[@f - 3];   $pol = $f[@f - 1];

    $exp_f = `ls $a/$exp.*.$time.$a.$pol`;   chop($exp_f);
    $con_f = `ls $a/$con.*.$time.$a.$pol`;   chop($con_f);

#    $exp_exact = `basename $a/$exp.*.$time.$a.$pol`;    chop($exp_exact);
#    $con_exact = `basename $a/$con.*.$time.$a.$pol`;    chop($con_exact);
#    $exp_exact =~ s/$pol/$pol.${sub}a.tbl/;
#    $con_exact =~ s/$pol/$pol.${sub}b.tbl/;

    unless(-d "$od/${a}_$time"){ mkdir ("$od/${a}_$time", 0777); }

    system "tbcat $exp_f > $od/${a}_$time/${a}_$time.$pol.${sub}a.tbl";
    system "tbcat $con_f > $od/${a}_$time/${a}_$time.$pol.${sub}b.tbl";
  }
}
