#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

$name = $formdata{'first'};

print "Content-type: text/html\n\n";
print "You entered a first name of <B>$name</B>";
