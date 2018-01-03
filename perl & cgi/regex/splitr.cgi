#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

$spouse = $formdata{'spouse'};
@qualifications = split(/,/, $spouse);

print "Content-type: text/html\n\n";

print "<FONT SIZE=+1><UL><B>You chose:</B>";

foreach $item (@qualifications) {
	print "<LI>$item";
}

print "</UL></FONT>";
