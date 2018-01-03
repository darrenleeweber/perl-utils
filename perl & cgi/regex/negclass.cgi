#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;
print "Content-type: text/html\n\n";

$zip = $formdata{'zip'};

if ($zip =~/[^0-9\-]/) {
		print "Your zipcode should only contain the numbers or the dash. Try again.";
} else {
print "You entered $zip for your zipcode";
}
