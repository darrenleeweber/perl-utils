#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

$class = $formdata{'class'};
@classes = split(/,/, $class);
$amount = $#classes + 1;

print "Content-type: text/html\n\n";

print "<H2>You chose $amount classes. They are:</H2><UL>";

foreach $item (@classes) {
	print "<LI>$item";
}

print "</UL>";
