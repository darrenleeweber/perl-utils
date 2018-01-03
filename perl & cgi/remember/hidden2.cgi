#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

print "Content-type:text/html\n\n";
print "<HTML><HEAD><TITLE>Using Hidden Fields</TITLE></HEAD><BODY>";

print "The item ordered by $formdata{'name'} from $formdata{'state'} is";
print "<P>$formdata{'item'}";
print "<P>Thanks. It's on its way.";
print "</BODY></HTML>";
