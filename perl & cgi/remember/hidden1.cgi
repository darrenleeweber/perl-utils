#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

print "Content-type:text/html\n\n";
print "<HTML><HEAD><TITLE>Using Hidden Fields</TITLE></HEAD><BODY>\n";
print "Thanks, $formdata{'name'}, for entering your personal data. Now you can choose which items you'd like to purchase.\n";

print "<FORM METHOD=POST ACTION=\"hidden2.cgi\">\n";
print "Item <INPUT TYPE=text NAME=item>\n";

foreach $key (keys %formdata) {
	print "<INPUT TYPE=hidden NAME=$key VALUE=$formdata{$key}>\n";
	}
	
print "<INPUT TYPE=submit VALUE=\"Send order\">\n";	
print "</FORM></BODY></HTML>\n";
