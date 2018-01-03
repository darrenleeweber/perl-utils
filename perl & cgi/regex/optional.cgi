#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;
print "Content-type: text/html\n\n";

$phone = $formdata{'phone'};

if ($phone =~ /^(\(\d\d\d\))? ?\d\d\d-\d\d\d\d$/) {
	print "You entered the phone number <B>$phone</B>";
} else {
	print "Please enter the phone number in the form <P>(123) 456-7899<P>(The area code is optional.)";
}
