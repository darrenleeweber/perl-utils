#!/usr/local/bin/perl

require 'subparseform.lib';
&Parse_Form;
print "Content-type:text/html\n\n";

$price = $formdata{'price'};
$tax = $formdata{'tax'}/100;

$salestax = $price * $tax;

$formattax = sprintf("\$%.2f", $salestax);

print "You'll have to pay $formattax in sales tax, unformatted it would look like $salestax";
