#!/usr/local/bin/perl

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
$mon = $mon + 1;
$mon = sprintf("%02d", $mon) if $mon <= 9;
$mday = sprintf("%02d", $mday) if $mday <= 9;

$date=$year . $mon . $mday;

$filename="logfile" . $date . "\.txt";

rename ("../../logs/logfile.txt", "../../logs/" . $filename) || &ErrorMessage;

print "Content-type: text/html\n\n";
print "The new name of the file is $filename";

sub ErrorMessage {
	print "Content-type: text/html\n\n";
	print "The server can't access the file. Aborting script. \n";
	exit;
}


