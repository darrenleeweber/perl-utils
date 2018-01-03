#!/usr/local/bin/perl

print "Content-type: text/html\n\n";
print "<P>Before coming to this page, you were looking at $ENV{'HTTP_REFERER'}";
