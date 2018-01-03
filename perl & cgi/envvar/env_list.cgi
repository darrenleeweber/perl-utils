#!/usr/local/bin/perl

print "Content-type: text/html\n\n";
print "<HTML><HEAD><TITLE>Environment Variables</TITLE></HEAD><BODY>";

foreach $env_var (keys %ENV) {
	print "<BR><FONT COLOR=red>$env_var</FONT> is set to <FONT COLOR=blue>$ENV{$env_var}</FONT>";
}

print "</BODY></HTML>";
