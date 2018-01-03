#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;

$base = $formdata{'base'};
$school = $formdata{'school'};

$twice = $base x 2;
$cheer = $base x 2 . $school;

$number = $formdata{'number'};
$repeat = $formdata{'repeat'};

$repeat_number = $number x $repeat;

print "Content-type: text/html\n\n";
print "<FONT SIZE=+2>The cheer is <B>$cheer</B>.";
print "<P>And the number, $number, repeated $repeat times is <B>$repeat_number<B></FONT>";
