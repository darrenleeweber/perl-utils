#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;
print "Content-type: text/html\n\n";

$year = $formdata{'year'};
$month = sprintf("%02d", $formdata{'month'});
$day = sprintf("%02d", $formdata{'day'});

$desired_file = "logfile" . $year . $month . $day . ".txt";

chdir ("../../logs");

if (-e $desired_file) {
	open (LOG, $desired_file) || &ErrorMessage;
	@messages = <LOG>;
	close (LOG);
	$n=1;
	foreach $message (@messages) {
		print "<LI>Message # $n is <I>$message</I>";
		$n++;
		}
} else {
	print "Log doesn't exist.";
	opendir (LOGDIR, ".") || &ErrorMessage;
	@logfiles = readdir (LOGDIR);
	closedir (LOGDIR);
	if (@logfiles) {
		print "<P>You can choose from the following logs:";
		foreach $filename (@logfiles) {
			print "<LI>$filename" unless ($filename =~ /^\.+$/);
			}
	}
}
	
sub ErrorMessage {
	print "Content-type: text/html\n\n";
	print "The server can't access the file. Aborting script. \n";
	exit;
}

