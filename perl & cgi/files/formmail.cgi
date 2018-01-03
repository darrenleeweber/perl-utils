#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;
print "Content-type:text/html\n\n";

$to = $formdata{'to'};
$from = $formdata{'from'};

$subject = $formdata{'subject'};
$contents = $formdata{'contents'};

open (MAIL, "|/usr/sbin/sendmail -t") || &ErrorMessage;

print MAIL "To: $to \nFrom: $from\n";
print MAIL "Subject: $subject\n";
print MAIL "$contents\n";

close (MAIL);

print "Thanks for your comments.";

sub ErrorMessage {
	print "<P>The server has a problem. Aborting script. \n";
	exit;
}
