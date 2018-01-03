#!/usr/local/bin/perl

&mime;
&header("This is the page title");

print "<P>This is more of that page wholly created by CGI and Perl!";
$capped_which = &cap(&which);

print "<P>You\'re browsing this page with $capped_which";

&footer;

sub cap {
	$captext = $_[0];
	$captext =~ tr/a-z/A-Z/;

}

sub which {
	$browser = $ENV{'HTTP_USER_AGENT'};
	if ($browser =~ /MSIE/) {
		$browser = "Explorer";
	} elsif ($browser =~/Mozilla/) {
		$browser = "Netscape";
	} else {
		$browser = "something besides Netscape and Explorer";
	}
}

sub header {
	print "<HTML><HEAD><TITLE>";
	print "$_[0]";
	print "</TITLE></HEAD><BODY>"
}

sub footer {
	print "</BODY></HTML>";
}

sub mime {
	print "Content-type: text/html\n\n";
}

