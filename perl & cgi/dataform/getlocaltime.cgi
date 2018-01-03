#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=gmtime(time);

%zones = ("EST", 5, "CT", 6, "MT", 7, "PT", 8);
$place= $formdata{'place'};
$zone = $formdata{'zone'};
$hour = $hour-$zones{$zone};

if ($hour <= 0) {
	$hour = $hour +24;
	}
	
$min=sprintf("%02d", $min);
$sec=sprintf("%02d", $sec);


print "Content-type: text/html\n\n";
print "According to my server, right now the time in $place is: $hour:$min:$sec";
