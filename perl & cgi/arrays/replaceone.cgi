#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

@classes = ("Latin 305", "Advanced Greek Grammar", "Applied Linguistics", "Virgil and the Iliad");
$newclass = $formdata{'newclass'};
$ID = $formdata{'ID'};

print "Content-type: text/html\n\n";
print "<H2>You replaced $classes[$ID] with $newclass. ";

$classes[$ID] = $newclass;

print "Your complete list is now:</H2><UL>";

foreach $item (@classes) {
	print "<LI>$item";
}

print "</UL>";
