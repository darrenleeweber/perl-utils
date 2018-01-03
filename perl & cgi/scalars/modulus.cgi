#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

$dividend = $formdata{'dividend'};
$divisor = $formdata{'divisor'};

$result = $dividend % $divisor;

print "Content-type: text/html\n\n";
print "<P>You entered $dividend for the dividend and $divisor for the divisor";
print "<P>The remainder of $dividend divided by $divisor is $result";
