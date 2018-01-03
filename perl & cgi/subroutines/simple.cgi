#!/usr/local/bin/perl

&mime;
print "<HTML><HEAD><TITLE>A new page</TITLE></HEAD><BODY>\n";
print "This page wholly created with CGI and Perl!";
print "</BODY></HTML>";

sub mime {
	print "Content-type: text/html\n\n";
}

