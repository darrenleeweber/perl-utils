#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

@days = (Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday);

$choice = $formdata{'choice'};
@choice = split(/,/, $choice);

print "Content-type: text/html\n\n";

print "You chose @days[@choice]";
