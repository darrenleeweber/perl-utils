#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

print "Content-type: text/html\n\n";
foreach $key (sort keys(%formdata)) {
	print "<P>The field with the NAME attribute equal to <B>$key</B> had a VALUE equal to <B>$formdata{$key}</B>";
}
