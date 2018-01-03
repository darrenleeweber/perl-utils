#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

@classes = ("Latin 305", "Advanced Greek Grammar");
$newclass = $formdata{'newclass'};

unshift(@classes, $newclass);


print "Content-type: text/html\n\n";

print "<H2>You added $newclass. Your complete list is now:</H2><UL>";

foreach $item (@classes) {
	print "<LI>$item";
}

print "</UL>";
