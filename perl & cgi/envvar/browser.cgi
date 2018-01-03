#!/usr/local/bin/perl

print "Content-type: text/html\n\n";
print "<P>The browser you're using to view this page is: $ENV{'HTTP_USER_AGENT'}";
