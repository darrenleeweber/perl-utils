#!/usr/local/bin/perl

&mime;
&header("This is the page title");

print "This is more of that page wholly created by CGI and Perl!";

&footer;

sub header {
	print "<HTML><HEAD><TITLE>";
	print "$_[0]";
	print "</TITLE></HEAD><BODY>"
}

sub footer {
	print "</BODY></HTML>";
}

sub mime {
	print "Content-type: text/html\n\n";
}

