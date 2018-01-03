#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

$class = $formdata{'class'};
@classes = split(/,/, $class);

print "Content-type: text/html\n\n";

print "<H2>You chose:</H2><UL>";

@classes = sort (@classes);

foreach $item (@classes) {
	print "<LI>$item";
}

print "</UL>";
