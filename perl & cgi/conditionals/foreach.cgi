#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

print "Content-type: text/html\n\n";

$name = $formdata{'name'};
@prey = split (/,/, $formdata{'prey'});

foreach $creature (@prey) {
	print "<P>$name likes to eat $creature.";
}
