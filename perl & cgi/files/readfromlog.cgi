#!/usr/local/bin/perl

open (LOG, "<../../logs/logfile.txt") || &ErrorMessage;
@logmessages = <LOG>;
close (LOG);

print "Content-type: text/html\n\n";
$n=1;
print "<UL><H2>Messages</H2></UL>";
foreach $message (@logmessages) {
	print "<LI>Message # $n was <I>$message</I>\n"; 
	$n++;
	}









sub ErrorMessage {
	print "Content-type: text/html\n\n";
	print "The server can't the file. It either doesn't exist or the permissions are wrong. \n";
	exit;
}


