#!/usr/local/bin/perl

require "header_footer.lib";

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);

@days = (Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday);
@months =
(January,February,March,April,May,June,July,August,September,October,November,December);

&Header("Get the Date");
print "<P>Today is <B>$days[$wday], $months[$mon] $mday</B>.\n";
&Footer;
