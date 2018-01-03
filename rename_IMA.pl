#! /usr/local/bin/perl

foreach $f (`ls`){

  if($f =~ /.ima/){
    chop($f);
    @numbers = split(/-/, $f);
    $a = $numbers[0];
    $b = $numbers[1];
    ($c = $numbers[2]) =~ s/.ima//;

    if($a =~ /^0/ || $b =~ /^0/ || $c =~ /^0/){
       print "\nLooks like ima_rename has been done already!!\n\n";
       exit;
    }

    if     ($a >  0 && $a <=   9){
      $a = "000$a";
    } elsif($a >  9 && $a <=  99){
      $a =  "00$a";
    } elsif($a > 99 && $a <= 999){
      $a =   "0$a";
    }

    if     ($b >  0 && $b <=   9){
      $b = "000$b";
    } elsif($b >  9 && $b <=  99){
      $b =  "00$b";
    } elsif($b > 99 && $b <= 999){
      $b =   "0$b";
    }

    if     ($c >  0 && $c <=   9){
      $c = "000$c";
    } elsif($c >  9 && $c <=  99){
      $c =  "00$c";
    } elsif($c > 99 && $c <= 999){
      $c =   "0$c";
    }

    printf "Moving %20s into ${a}-${b}-${c}.ima\n", $f;

    system "mv $f ${a}-${b}-${c}.ima";
  }
}
