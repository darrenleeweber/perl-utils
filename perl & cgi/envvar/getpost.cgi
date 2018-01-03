#!/usr/local/bin/perl

print "Content-type: text/html\n\n";
print "<P>The Request Method was: $ENV{'REQUEST_METHOD'}";
print "<P>The data from GET was: $ENV{'QUERY_STRING'}";
print "<P>The data from POST had $ENV{'CONTENT_LENGTH'} bytes. You can find it in standard input.";
