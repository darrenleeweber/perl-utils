#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

print "Content-type: text/html\n\n";

$comments = $formdata{'comments'};

if ($comments =~ /<IMG[^>]*>/) {
	print "<P>Sorry, images are not permitted. Please limit your comments to text.";
	$comments =~ s/<IMG[^>]*>//g;
}
print "<P>Your text comments were <P><B>$comments" if $comments;
