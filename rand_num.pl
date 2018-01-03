#! /usr/bin/perl

while (<@ARGV>){
  if(/-a/){ shift; $a = shift; }
  if(/-b/){ shift; $b = shift; }
  if(/-n/){ shift; $n = shift; }
  if(/-h/){ &HELP; }
}

srand;

$x = 1;
while ($x <= $n){
  $x++;
  $rand = (rand(0) * ($b - $a)) + $a;
  print "$rand\n";
}

sub HELP {

  print "\a\nRAND_NUM : A random number generator.\n\n",

        "USEAGE: rand_num -a x -b x -n x\n\n",

        "-a x   Specify the lowest number.\n",
        "-b x   Specify the highest number.\n",
        "-n x   Specify how many numbers to generate.\n\n",

        "The routine will generate n random numbers between a and b.\n\n",
}
