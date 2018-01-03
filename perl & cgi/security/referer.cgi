#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

$origin = $ENV{'HTTP_REFERER'};
print "Content-type:text/html\n\n";

if ($origin =~ m#http://www.cookwood.com/#) {
	print "The page that launched the script is on my server";
	print "<P>The name you entered was $formdata{'name'}";
	} else {
	print "You can't run this script from that location. Sorry.";
	}
