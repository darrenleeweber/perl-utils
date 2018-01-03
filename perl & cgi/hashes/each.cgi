#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

print "Content-type: text/html\n\n";

while (($key, $value) = each(%formdata)) {
	print "<P>The key is $key and the value is $value";
	}
