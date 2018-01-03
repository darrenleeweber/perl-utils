#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

$class = $formdata{'class'};
@classes = split(/,/, $class);

print "Content-type: text/html\n\n";

print "<UL>You chose:";

foreach $item (@classes) {
	print "<LI>$item";
}

print "</UL>";
