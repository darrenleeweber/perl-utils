#! /usr/bin/perl

srand;
$tmp = "temp.$$";

while (<@ARGV>){
  if(/-f/){ shift; $runfile=shift; }
}

unless($runfile){
  print "\n\nUSEAGE: make.runs -f <file>\n\n";
  exit;
}

open(RUNS, "$runfile") || die "\n\nMAKE.RUNS can't open $runfile\n\n";
while(<RUNS>){

  $r++;

  if(! -d "runs"){ mkdir "runs", 0777; }
  if(-s "runs/run$r.seq") { system "rm runs/run$r.seq"; }
  open(RUN, ">> runs/run$r.seq") || die "Can't open runs/run$r.seq\n\n";

  print RUN "Numevents 178\n";
  print RUN "event mode duration window SOA/ISI xpos ypos resp type filename\n";
  print RUN "----- ---- -------- ------ ------- ---- ---- ---- ---- --------\n";

  $event = 0;
  @seq = split;
  $t = 0;

  foreach $seq (@seq){

    if ($seq ne "fx" ){		# Non-fixation Conditions

      $t++;

      if($seq =~ /^f/){
	print "Run $r, $seq.seq     ";
      } else {
	print "Run $r, $seq.seq\n";
      }

      ($td = $seq) =~ s/..$//;	# Set Task Directory (ff, fv, vf, vv);

      system "cat $td/$seq.seq | get_words.pl -r $r -t $t > $tmp";

      open(SEQ, "$tmp") || die "Can't open $tmp which is a copy of $td/$seq.seq\n\n";
      while(<SEQ>){
	$event++; @v = split; $v[0] = $event;
	printf RUN "%5s %4s %8s %6s %7s %4s %4s %4s %4s %-8s\n", $v[0], $v[1], $v[2], $v[3], $v[4], $v[5], $v[6], $v[7], $v[8], $v[9];

	if($seq =~ /^f/ && $v[7] > 0 && !$got_targ) { # output target word
	  print "Target for $seq = $v[9]\n"; $got_targ = "y";
	}
      }
      close(SEQ); system "rm $tmp"; $got_targ = "";

    } else {			# Fixation Condition

      print "Run $r, $seq.seq\n";

      open(FX, "fx/fx.seq") || die "Can't open fx/fx.seq\n\n";
      while(<FX>){
	$event++; @v = split; $v[0] = $event;
	printf RUN "%5s %4s %8s %6s %7s %4s %4s %4s %4s %-8s\n", $v[0], $v[1], $v[2], $v[3], $v[4], $v[5], $v[6], $v[7], $v[8], $v[9];
      }
      close(FX);
    }

  }
  close(RUN);
  system "unix2dos runs/run$r.seq runs/tmp";
  system "mv runs/tmp runs/run$r.seq";
}
close(RUNS);
