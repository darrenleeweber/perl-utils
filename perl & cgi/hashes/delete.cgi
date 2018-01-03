#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

print "Content-type: text/html\n\n";
print "<TABLE><TR><TH>Keys:<TH>Values:";

delete $formdata{'last'};

foreach $key (keys %formdata) {
	print "<TR><TD>$key<TD>$formdata{$key}";
	}
	
	print "</TABLE>";
	

