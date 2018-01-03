#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

print "Content-type: text/html\n\n";

@keys = keys(%formdata);

print "<H2>Keys:</H2><UL>";

foreach $key (@keys) {
	print "<LI>$key";
	}
	
	print "</UL>";
