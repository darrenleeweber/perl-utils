#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

print "Set-Cookie:language=$formdata{'language'}\n";

print "Content-type: text/html\n\n";
print "<HTML><HEAD><TITLE>Thanks for choosing!</TITLE></HEAD><BODY>";
print "You chose $formdata{'language'}. Next time you visit, I'll greet you accordingly.";


