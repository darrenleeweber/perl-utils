#! /usr/bin/perl

while(<@ARGV>){
  if(/-elec/){ shift; $elec = shift; }
  if(/-h/){ &HELP; }
}

while(<>){
  @data = split;
  foreach $d (@data){
    $n++;
    printf "%12.4f ", $d;
    if($n == $elec){ print "\n"; $n = 0; }
  }
}

sub HELP {
  print "\a\nsort-epochs -elec x\n\n",
  "specify how many electrodes per epoch and the utility\n",
  "will split a row of data from matlab into separate epochs\n",
  "of x electrodes.\n\n";
}
