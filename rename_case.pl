#! /usr/local/bin/perl

@lower = (a..z);
@upper = (A..Z);

$n = 0;
foreach $l (@upper){  $alpha{$l} = $lower[$n];  $n++;  }

while(<>){

  s/([A-Z])/$alpha{$1}/g;

  print;
}
