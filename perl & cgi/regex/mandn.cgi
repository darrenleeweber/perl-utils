#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;
print "Content-type: text/html\n\n";

$phone = $formdata{'phone'};

if ($phone =~ /^((\(\d{3}\))? *\d{3}-\d{4},? *)+$/) {
	print "You entered the phone number(S) <B>$phone</B>";
} else {
	print "Please enter the phone number(s) in the form <P>(123) 456-7899<P>(The area code is optional.)";
}
