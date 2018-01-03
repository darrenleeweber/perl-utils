#! /usr/bin/perl

srand;

@UC = (ADULT, ATLAS, BENCH, CHAIN, DRESS, ENGINE, GRAIN, HEATER, INSECT, JUICE, LEADER, MODEL, NERVE, NURSE, OPERA, PIANO, REGION, SKIRT, TRAIN, WINTER, ANGEL, BASKET, CAKE, DOLLAR, ELBOW, FENCE, GARAGE, HANDLE, INFANT, JACKET, LAGOON, MAYOR, MUSCLE, NOVEL, OCEAN, PEPPER, RANCH, WAGON);

@LC = (adult, atlas, bench, chain, dress, engine, grain, heater, insect, juice, leader, model, nerve, nurse, opera, piano, region, skirt, train, winter, angel, basket, cake, dollar, elbow, fence, garage, handle, infant, jacket, lagoon, mayor, muscle, novel, ocean, pepper, ranch, wagon);


# Randomly Select Upper Case Words
@A = @UC;

until($A){ $A = $A[int(rand(@A))]; }

$Bwds = join(" ", @A);
$Bwds =~ s/\b$A\b//;
@B = split(/\s+/, $Bwds);
until($B){ $B = $B[int(rand(@B))]; }

$Cwds = join(" ", @B);
$Cwds =~ s/\b$B\b//;
@C = split(/\s+/, $Cwds);
until($C){ $C = $C[int(rand(@C))]; }

$Dwds = join(" ", @C);
$Dwds =~ s/\b$C\b//;
@D = split(/\s+/, $Dwds);
until($D){ $D = $D[int(rand(@D))]; }

# Randomly Select LC Words, after exclusion of UC words selected
$mwds = join("  ", @LC);
$mwds =~ s/\b$A\b//i;
$mwds =~ s/\b$B\b//i;
$mwds =~ s/\b$C\b//i;
$mwds =~ s/\b$D\b//i;
@m = split(/\s+/, $mwds);
until($m){ $m = $m[int(rand(@m))]; }

$nwds = join(" ", @m);
$nwds =~ s/\b$m\b//;
@n = split(/\s+/, $nwds);
until($n){ $n = $n[int(rand(@n))]; }

$owds = join(" ", @n);
$owds =~ s/\b$n\b//;
@o = split(/\s+/, $owds);
until($o){ $o = $o[int(rand(@o))]; }

$pwds = join(" ", @o);
$pwds =~ s/\b$o\b//;
@p = split(/\s+/, $pwds);
until($p){ $p = $p[int(rand(@p))]; }

while(<>){
  if   (/\bA\b/){ s/\bA\b/u$A/ && print; }
  elsif(/\bB\b/){ s/\bB\b/u$B/ && print; }
  elsif(/\bC\b/){ s/\bC\b/u$C/ && print; }
  elsif(/\bD\b/){ s/\bD\b/u$D/ && print; }
  elsif(/\bm\b/){ s/\bm\b/l$m/ && print; }
  elsif(/\bn\b/){ s/\bn\b/l$n/ && print; }
  elsif(/\bo\b/){ s/\bo\b/l$o/ && print; }
  elsif(/\bp\b/){ s/\bp\b/l$p/ && print; }
  else       {              print; }
}
