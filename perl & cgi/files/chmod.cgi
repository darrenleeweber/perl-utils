#!/usr/local/bin/perl
print "Content-type: text/html\n\n";

if (-e "../tmp/archives") {
	chmod (0777, "../tmp/archives") || &ErrorMessage;
	print "<P>The permissions have been changed";
	}

sub ErrorMessage {
	print "<P>The server has a problem. Aborting script. \n";
	exit;
}
