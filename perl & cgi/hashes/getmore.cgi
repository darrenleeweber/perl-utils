#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

@name = @formdata{'first', 'last'};

print "Content-type: text/html\n\n";
print "You entered a full name of <B>@formdata{'first', 'last'}</B>";
