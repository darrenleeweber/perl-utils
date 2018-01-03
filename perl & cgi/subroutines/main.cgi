#!/usr/local/bin/perl

require 'subroutines.pl';

&mime;
&header("This is the page title");

print "<P>This is more of that page wholly created by CGI and Perl!";
$capped_which = &cap(&which);

print "<P>You\'re browsing this page with $capped_which";

&footer;
