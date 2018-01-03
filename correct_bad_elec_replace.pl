#! /usr/local/bin/perl -w

while(<@ARGV>){
  if ( /-h/ ) { &HELP; }
}

unless(-d "corrected_data"){ mkdir ("corrected_data", 0777); }

@cond = ("o", "oac", "oat", "ouc", "out", "t", "tac", "tad", "tat", "tuc", "tud", "tut");
#@cond = ( "tat" );

open(BE,"bad.elec") || die "\nCan't open bad.elec\n\n";
SEARCHBE: while(<BE>){

  chop;  @bedat = split(/:\s+/);

  if(! $bedat[0]) { next; } # skip blank lines in bad.elec file

  foreach $c (@cond){

    $s = $bedat[0];  @be = split(/\s+/, $bedat[1]);

    print STDERR "\nProcessing original-scan/$s$c.dat - creating corrected_data/$s$c.dat\n";

    open(DATA,"original-scan/$s$c.dat") || die "\nCan't open original-scan/$s$c.dat\n\n";

    GETDATA: while(<DATA>){
      chop;
      if(/^Standard/){
	last GETDATA; 
      } else {
	s///g;
	@data = split(/[\'\"]\s+/); #" this comment to balance indenting in emacs
	if($data[1] =~ /\d+/){
	  ($elec = $data[1]) =~ s/[\'\"]//g; #" this comment to balance indenting in emacs
	  $val  = $data[2];
	}
	$data{$elec} = $val;
      }
    }
    close(DATA);

    if(-e "corrected_data/$s$c.dat"){ system "rm corrected_data/$s$c.dat"; }
    open(CORRECTED,">>corrected_data/$s$c.dat") || die "\nCan't open corrected_data/$s$c.dat\n\n";

    foreach $e (1..124){

      printf CORRECTED "\"%10d\"  ",$e;

      # check if current electrode is a bad electrode

      if( ! grep {$e == $_} @be ){

	# Not bad electrode, so output original values, with format %10.4f
	map printf(CORRECTED " %10.4f", $_), split(/\s+/, $data{$e});
	print CORRECTED "\n";

      } else {

	# Get nearest neighbour electrodes and distances, assigned to %nn_d
	&GET_NN;

	printf STDERR "\tCorrecting electrode %3d, with electrodes: ", $e;
	map printf(STDERR "%3d ", $_), (sort {$a <=> $b} keys %nn_d);
	print STDERR "\n";

	# Work on individual time points
	@old_values = split(/\s+/,$data{$e});
	@newvalues = ();

	$t = 0;
	for (@old_values){
	  
	  $numerator = 0; $divisor = 0;
	  
	  # Foreach nearest neighbour electrode
	  foreach $nn (sort {$a <=> $b} keys %nn_d){
	    
	    @nn_val = split(/\s+/,$data{$nn}); # Get voltage values for nearest neighbour
	    
	    # divide NN volt at time $t by its distance from bad electrode
	    $numerator += ($nn_val[$t] / $nn_d{$nn});
	    $divisor += (1/$nn_d{$nn});
	  }
	  $newvalue = ($numerator / $divisor);  # See notes below about calculation of new values
	  push(@newvalues,$newvalue);
	  
	  $t++;
	}
	
	$data{$e} = join(" ",@newvalues);	  # Replace newvalues into %data
	@be = grep {$_ != $e} @be;	          # Redefine bad electrodes (remove $e)
	
	# Output corrected values in standard format
	map printf(CORRECTED " %10.4f", $_), @newvalues;
	print CORRECTED "\n";
      }
    }
    close(CORRECTED);
  }
}



sub GET_NN {
  open(NN,"nn_electrodes") || die "\nCan't open nn_electrodes\n\n";
  SEARCHNN: while(<NN>){

    # search for subject $s and electrode $e in nn_electrode file
    if(/\s+$s\s+$e/){

      # capture nn electrode number and distance into @nn
      @nn = split(/:\s+/);
      @nn = split(/,\s+/,$nn[1]);

      # capture 6 good nn electrodes into %nn_d
      $good = 0; %nn_d = ();
      foreach $nne (@nn){
	unless($good == 6){
	  @nne = split(/\s+/,$nne); # split elec no. & distance
	  if ( ! grep {$nne[0] == $_} @be ) { $good++; $nn_d{$nne[0]} = $nne[1]; }
	}
      }
      last SEARCHNN;
    }
  }
  close(NN);
}

sub HELP {
  print "\a\nTHIS IS A PERL SCRIPT, not a command line perl program.\n\n";
  system "pod2text `which correct_bad_elec.pl`";
  exit;
}

=pod

=head1 B<Calculation of New Values>

 This routine uses nearest neighbour information generated from the
 3DSPACE export file for each subject.  The routine which generated
 that data was "nn_elec".  It can also be generated in matlab using
 the elec_distance_nn routine.  The file generated has a particular
 format.  Each line should start with a subject code and an
 electrode number (separated by spaces only) followed by a
 colon (:).  Thereafter, it should contain any number of nearest
 neighbour electrode numbers and distances, each separated from
 the next by a comma.  For example:

 c01    1:   4    1.9585,    2    2.6171,    7    2.6511,   6    2.7699

 This routine uses bad electrode information in a file called
 "bad.elec".  This file has a particular format.  Each line must
 begin with a subject code followed by a colon (:).  Thereafter,
 the line must contain a series of bad electrode numbers separated
 by spaces only.

 Given a bad electrode and its surrounding 6 good electrodes (not bad
 electrodes also), the new values for the bad electrode are calculated
 using the following equasion:

 newvalue = NN1/NND1 + NN2/NND2 + ... + NN4/NND4
            ------------------------------------
              1/NND1 +   1/NND2 + ... +   1/NND4

 where: NN  is "nearest neighbour" electrode and
        NND is "distance from bad electrode to NN"

 Note that NND was calculated as SQRT( (X2-X1)^2 + (Y2-Y1)^2 + (Z2-Z1)^2 )
 which is an extension of Pythagorus' theorem to 3 dimensional Euclidean
 geometry.

 Once an electrode is corrected, it is removed from the bad elec list and
 can thereafter be used in the correction of further electrodes.

=cut
