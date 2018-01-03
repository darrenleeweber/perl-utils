#!/usr/local/bin/perl

print "Content-type: text/html\n\n";

$browser = $ENV{'HTTP_USER_AGENT'};

if ($browser =~ /MSIE/) {
	print "You're using IE";
} elsif ($browser =~ /Mozilla/) {
	print "You're using Netscape";
} else {
	print "You're using something else";
}
