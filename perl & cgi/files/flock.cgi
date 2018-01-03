#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;


$comments = $formdata{'comments'};

open (LOG, ">>../../logs/logfile.txt") || &ErrorMessage;
flock (LOG, 2);
print LOG "$comments\n";
flock (LOG, 8);
close (LOG);

print "Content-type: text/html\n\n";
print "<P>You commented thusly: <BLOCKQUOTE><P><I>$comments</I></BLOCKQUOTE>\n";
print "<HR>Would you like to see all the messages? <A HREF=\"http://www.cookwood.com/cgi-bin/lcastro/readfromlog.cgi\">Yes</A>";

sub ErrorMessage {
	print "Content-type: text/html\n\n";
	print "The server can't open the file. It either doesn't exist or the permissions are wrong. \n";
	exit;
}


