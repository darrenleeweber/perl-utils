#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;
print "Content-type: text/html\n\n";

foreach $key (keys %formdata) {
	print "<P>The visitor entered <B>$formdata{$key}</B> in the <B>$key</B> field."
}
