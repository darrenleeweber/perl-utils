#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

print "Content-type: text/html\n\n";

@values = values(%formdata);

print "<H2>Values:</H2><UL>";

foreach $value (@values) {
	print "<LI>$value";
	}
	
	print "</UL>";
