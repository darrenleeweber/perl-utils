#!/usr/bin/perl -w

 # Batch rename utility
 #  Added by nader type ./ren.pl 's/.MRGE/_MRGE/g' *.*

 $op = shift or die "Usage: ren.pl 'expr' [files]\nFor Amir study example ./ren.pl 's/.MRGE/_MGRE/g' *.* \n";
 chomp(@ARGV = <STDIN>) unless @ARGV;

 for (@ARGV) {
    if (-e) {
       $was = $_;
       eval $op;
       die $@ if $@;
       print "$was => $_\n";
       $name{$was} = $_;
    }
 }
 unless (defined(%name)) { print "No matches found... \n"; exit; }
 print "Rename these? [y/N]?\n";
 chomp($answer=<STDIN>);
 if (lc($answer) eq 'y') {
    foreach $old (keys (%name)) {
       unless (-e $name{$old}) {
            # rename unless no change
          rename($old,$name{$old}) unless $old eq $name{$old};
       }
       else {
            # if the proposed new name exists, do not overwrite
          print "$name{$old} exists, skipping...\n";
       }
    }
 }
 else  { print "Nothing renamed...\n"; }
