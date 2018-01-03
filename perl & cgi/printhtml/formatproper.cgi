#!/usr/local/bin/perl

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);

@days = (Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday);
@months =
(January,February,March,April,May,June,July,August,September,October,November,December);

print "Content-type: text/html\n\n";
print "<HTML>\n<HEAD>\n<TITLE>Get the date</TITLE>\n</HEAD>\n<BODY>\n";
print "<P>Today is <B>$days[$wday], $months[$mon] $mday</B>.\n";
print "</BODY>\n</HTML>";
