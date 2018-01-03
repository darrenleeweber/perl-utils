#! /usr/bin/perl

foreach $f (`ls dif/*/*.avg`) {
	
	chop($f);
	
	if($f =~ /_1-3/){
		if($f =~ /large/){
			
			$f =~ s/\//\\/g;
			($nf = $f) =~ s/large/large\\target-common/;
			
			system "move $f $nf";
			
		} else {
			
			$f =~ s/\//\\/g;
			($nf = $f) =~ s/small/small\\target-common/;
			
			system "move $f $nf";	
		}
	} else {
		if($f =~ /large/){
			
			$f =~ s/\//\\/g;
			($nf = $f) =~ s/large/large\\distract-common/;
			
			system "move $f $nf";
			
		} else {
			
			$f =~ s/\//\\/g;
			($nf = $f) =~ s/small/small\\distract-common/;
			
			system "move $f $nf";	
		}		
	}
}

