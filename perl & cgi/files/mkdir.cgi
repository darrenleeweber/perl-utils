#!/usr/local/bin/perl
print "Content-type: text/html\n\n";
	
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
$mon = $mon + 1;
$mon = sprintf("%02d", $mon) if $mon <= 9;
$mday = sprintf("%02d", $mday) if $mday <= 9;

$date=$year . $mon . $mday;

$filename="logfile" . $date . "\.txt";

if (-e "../tmp/archives") {
	print "<P>The archives directory does exist.";
} else {
	print "<P>The archives directory does not exist.";
	mkdir ("../tmp/archives", 0777) || &ErrorMessage;
	print "<P>The archives directory has been created.";
	}

rename ("../../logs/logfile.txt", "../tmp/archives/" . $filename) || &ErrorMessage;

print "The new name of the file is $filename";

sub ErrorMessage {
	print "<P>The server has a problem. Aborting script. \n";
	exit;
}


