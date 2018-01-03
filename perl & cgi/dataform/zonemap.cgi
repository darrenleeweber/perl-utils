#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;
print "Content-type: text/html\n\n";

foreach $key (keys %formdata) {
	print "<P>The key is $key, the value is $formdata{$key}";
	}
