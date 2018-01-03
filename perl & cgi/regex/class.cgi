#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;
print "Content-type: text/html\n\n";

$number = $formdata{'number'};
%catalan = (1, "un", 2, "dos", 3, "tres", 4, "quatre", 5, "cinc");
%spanish = (1, "uno", 2, "dos", 3, "tres", 4, "cuatro", 5, "cinco");
%french = (1, "un", 2, "deux", 3, "trois", 4, "quatre", 5, "cinc");

if ($number =~/^[1-5]$/) {
	print "<P>You chose the number $number. That number translated into Catalan is <B>$catalan{$number}</B>. In French, it's <B>$french{$number}</B>. In Spanish, it's <B>$spanish{$number}<B>.";
} else {
	print "<P>Sorry, you didn't choose a number between 1 and 5. Try again.";
}
