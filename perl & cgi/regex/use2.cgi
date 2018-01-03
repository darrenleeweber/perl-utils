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

	print "<HR><FONT SIZE=+1>";
	print "<P>The environment variable was $browser";
	print "<P>\$& is $&\n";
	print "<P>\$` is $`\n";
	print "<P>\$' is $'\n";
	print "</FONT>";
