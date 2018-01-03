#! /usr/bin/perl

# get runs and studies of interest.
while(<>){
  chop;
  if(/run/){ $run = $_; $runs .= "$run "; next; }
  $studies{$run} .= "$_ ";
}

unless(-d "select_studies"){ mkdir "select_studies", 0777; }

@runs = split(/\s+/, $runs);
foreach $r (@runs){
  print "$r\n";
  print "$studies{$r}\n";
  @studies = split(/\s+/, $studies{$r});
  foreach $s (@studies){
    if      ($s <   10){
      system "cp $r/????-000${s}-*.ima select_studies";
    } elsif ($s <  100){
      system "cp $r/????-00${s}-*.ima  select_studies";
    } elsif ($s < 1000){
      system "cp $r/????-0${s}-*.ima   select_studies";
    } else {
      system "cp $r/????-${s}-*.ima    select_studies";
    }
  }
}