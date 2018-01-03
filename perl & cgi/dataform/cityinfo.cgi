#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;
print "Content-type: text/html\n\n";

if ($formdata{'infotype'} eq 'time') {

	%zones=('Hartford', 5, 'Dallas', 6, 'Denver', 7, 'Eureka', 8);
	$city=$formdata{'city'};

	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=gmtime(time);

	$hour = $hour-$zones{$city};

	if ($hour <= 0) {
		$hour = $hour +24;
	}
	
	$min=sprintf("%02d", $min);
	$sec=sprintf("%02d", $sec);

	print "<P>The local time in $city is $hour:$min:$sec";

} 	else {
	print "<P>I haven't written that part of the program yet. Sorry.";
	}
