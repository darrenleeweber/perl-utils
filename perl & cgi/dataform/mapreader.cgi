#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;
print "Content-type: text/html\n\n";

if ($formdata{'infotype'} eq 'time') {

	%citycoords = ('370,78','Hartford','198,161','Dallas','135,98','Denver','17,87','Eureka');
	@coords = @formdata{'coord.x','coord.y'};
	
	foreach $coordset (keys %citycoords) {
		@set= split(/,/, $coordset);
		if (($coords[0]>=$set[0]-15 & $coords[0]<=$set[0]+15) & ($coords[1]>=$set[1]-15 & $coords[1]<=$set[1]+15)) {
			$city=$citycoords{$coordset};
			last;
		}
	}

	if ($city) {
		%zones=('Hartford', 5, 'Dallas', 6, 'Denver', 7, 'Eureka', 8);
		%zonenames = ('Hartford', 'Eastern Zone', 'Dallas', 'Central Zone', 'Denver', 'Mountain Zone', 'Eureka', 'Pacific Zone');
	
		($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=gmtime(time);

		$hour = $hour-$zones{$city};

		if ($hour <= 0) {
			$hour = $hour +24;
		}
	
		$min=sprintf("%02d", $min);
		$sec=sprintf("%02d", $sec);

		print "<P>The local time in $city (and indeed, the entire $zonenames{$city}) is $hour:$min:$sec"; 
	} else {
		print "That area of the map is undefined. Click on a red dot." if (!$city);
	}
	
} elsif (!$formdata{'infotype'}) {
print "<P>You have to choose what kind of information you're interested in before clicking on the map";
} else {
print "<P>Sorry, I haven't written that part of the program yet.";
}
