#!/usr/local/bin/perl

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);

@days = qw(Sunday Monday Tuesday Wednesday Thursday Friday Saturday);
@months =
qw(January February March April May June July August September October November December);

@catdays= qw(diumenge dilluns dimarts dimecres dijous divendres dissabte);
@catmonths =
qw(Gener Febrer Mar&#231\; Abril Maig Juny Juliol Agost Setembre Octubre Novembre Desembre);


print "Content-type: text/html\n\n";
print "Today is $days[$wday], $months[$mon] $mday.";
print "<P>In Catalonia, they'd say: Avui &eacute\;s $catdays[$wday],
$mday de $catmonths[$mon].";
