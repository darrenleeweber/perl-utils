#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;
print "Content-type: text/html\n\n";

$phrase = $formdata{'phrase'};

if ($phrase =~ /e/) {
	print "<P>Sorry, that sentence did in fact have an e. I told you: it's harder than it seems.";
} else {
	print "<P>Congratulations, that sentence had no e. Quite a feat!";
}
