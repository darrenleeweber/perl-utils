#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

$food = $formdata{'food'};

print "Content-type: text/html\n\n";

unless ($food eq "spinach") {
	print "No spinach, no dessert!";
}
