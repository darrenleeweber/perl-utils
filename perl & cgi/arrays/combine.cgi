#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

@classes = ("Latin 305", "Advanced Greek Grammar");
$newclasses = $formdata{'newclasses'};
@newclasses = split(/,/, $newclasses);

@classes = (@classes, @newclasses);


print "Content-type: text/html\n\n";

print "<H2>You added:</H2><UL>";
foreach $item (@newclasses) {
	print "<LI>$item";
}
print "</UL>";

print "<H2>Your complete list is now:</H2><UL>";

foreach $item (@classes) {
	print "<LI>$item";
}

print "</UL>";
