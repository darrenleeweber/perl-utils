#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;
print "Content-type: text/html\n\n";

$address = $formdata{'address'};

if ($address =~ /(\d{5}(-\d{4})?)/) {
	print "I found a zip code of $1. Is that correct?";
	} else {	
	print "No zip code was found.";
	}
