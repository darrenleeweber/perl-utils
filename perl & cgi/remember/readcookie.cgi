#!/usr/local/bin/perl

print "Content-type: text/html\n\n";

if ($ENV{'HTTP_COOKIE'}) {
	@cookies = split (/;/, $ENV{'HTTP_COOKIE'});
	foreach $cookie (@cookies) {
		($name, $value) = split (/=/, $cookie);
		$crumbs{$name} = $value;
		}
	
		
$language = $crumbs{'language'};		
%greeting = (Catalan, "Bon dia. <P>Benvingut a la nostra p&agrave;gina Web.", Spanish, "Buenos d&iacute;as. <P>Bienvenidos a nuestra p&aacute;gina Web.", French, "Bon jour. Bienvenue!", English, "Hello. <P>Welcome to our Web page.");

print "<HTML><HEAD><TITLE>Greeting</TITLE></HEAD><BODY>";
print "<CENTER><H1>$greeting{$language}</H1></CENTER>";
print "</BODY></HTML>";

} else {
		print "Couldn't find any cookies. Perhaps you've got your browser set to refuse all cookies? ";
		}
