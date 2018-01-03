#!/usr/local/bin/perl

print "Content-type: text/html\n\n";
print "<HTML><HEAD><TITLE>Showing off in either browser</TITLE></HEAD><BODY>";

$browser = $ENV{'HTTP_USER_AGENT'};

if ($browser =~ /Mozilla/) {
	print "You're using Netscape";
	print "You can show off in Netscape with the <BLINK>Blink</BLINK> tag";
	
#} else {
	#print "You're not using Netscape, which means you're probably using Explorer";
	#print "In Internet Explorer, a cool tag is the <MARQUEE BEHAVIOR="scroll">Marquee tag</MARQUEE>";
#}
