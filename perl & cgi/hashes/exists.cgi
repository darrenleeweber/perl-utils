#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

print "Content-type: text/html\n\n";


if (exists $formdata{'sales'}) {
	print "You came to this script from the Sales page";
} elsif (exists $formdata{'first'}) {
	print "You came to this script from the general info page";
} else {
	print "I don't know how you accessed this script";
}
