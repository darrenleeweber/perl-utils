#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

print "Content-type: text/html\n\n";
print "<HTML><HEAD>\n<TITLE>";
print "Showing off with HTML";
print "</TITLE>\n</HEAD><BODY>\n";

print "<H2>Thanks for responding. Here's what you told us:</H2>";
print "<TABLE BORDER=3 WIDTH=60%>\n";
print "<TR><TH>Key<TH>Value\n";
foreach $key (keys %formdata){
	print "<TR><TD>$key<TD>$formdata{$key}\n";
	}
print "</TABLE>";
print "</BODY></HTML>";
	
