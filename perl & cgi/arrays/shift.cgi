#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

@classes = ("Latin 305", "Advanced Greek Grammar", "Applied Linguistics", "Virgil and the Iliad");

$removed = shift(@classes);

print "Content-type: text/html\n\n";

print "<H2>You removed $removed. Your complete list is now:</H2><UL>";

foreach $item (@classes) {
	print "<LI>$item";
}

print "</UL>";
