#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

$start = $formdata{'start'};

print "Content-type: text/html\n\n";
print "<P>Starting countdown...";

while ($start > 0) {
	if ($start - int $start) {
		$start = int $start;
	}
	print "$start... ";
	--$start;
}

print "KABOOM!";
