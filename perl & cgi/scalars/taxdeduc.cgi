#!/usr/local/bin/perl

require "subparseform.lib";

&Parse_Form;

$total = $formdata{'donation'};
$times = $formdata{'times'};
$premium = $formdata{'premium'};

$average = $total/$times;
$tax_deduction = $total - $premium;

print "Content-type: text/html\n\n";
print "<P>You donated $total dollars last year. Thank you.";
print "<P>Since you donated $times times, that works out to an average of $average dollars per donation.";
print "<P>Since your premium was worth $premium dollars, you can only take a tax deduction of $tax_deduction dollars.";

print "<P>Please call our office if you have any questions.";

