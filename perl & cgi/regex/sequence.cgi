#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;
print "Content-type: text/html\n\n";

$phrase = $formdata{'phrase'};

$phrase =~ s/damn/hoot/;

print "<P>Your more proper sentence is <P><B>$phrase";
