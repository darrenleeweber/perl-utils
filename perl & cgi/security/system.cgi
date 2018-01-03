#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;
print "Content-type: text/html\n\n";

$language = $formdata{'language'};

if ($language=~/English/) {
	$filename = "gatetseng.html";
} elsif ($language =~ /Catalan/) {
	$filename = "gatetscat.html";
} else {
	print "Sorry, you can only choose between English and Catalan.";
}

open (FILE, "/home/user4/lcastro/WWW/personal/$filename") || &ErrorMessage;
@page = <FILE>;
close FILE;

foreach $line (@page) {
	print $line;
	}







sub ErrorMessage {
	print "The server can't open that file. Sorry";
	}
