#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

@classes = ("Latin 305", "Advanced Greek Grammar", "Applied Linguistics", "Virgil and the Iliad");
@newclasses = split(/,/, $formdata{'newclass'});
@IDs = split(/,/, $formdata{'ID'});

print "Content-type: text/html\n\n";
print "<P><B>You replaced: </B>";

foreach $number (@IDs) {
	$number--;
	print "<LI>$classes[$number]";
}

print "<P><B>with:</B> ";
foreach $course (@newclasses) {
	if ($course ne " ") {
	print "<LI>$course";
	@newarray = (@newarray, $course);
}
}

@classes[@IDs] = @newarray;

print "<H2>Your complete list is now:</H2><UL>";

foreach $item (@classes) {
	print "<LI>$item";
}
print "</UL>";

