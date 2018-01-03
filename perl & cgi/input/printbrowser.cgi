#!/usr/local/bin/perl

$browser=$ENV{'HTTP_USER_AGENT'};
$from = $ENV{'HTTP_REFERER'};

print "Content-type: text/html\n\n";
print "<P>You're browsing this page with $browser";
print "<P>And before this page, you were looking at $from";
