#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

$building = $formdata{'building'};
@buildings = split(/,/, $building);

print "Content-type: text/html\n\n";

print "<UL>You chose:";

foreach $item (@buildings) {
	print "<LI>$item";
}

print "</UL>";
