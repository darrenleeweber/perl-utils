#!/usr/local/bin/perl

require "subparseform.lib";
&Parse_Form;
$year = $formdata{'year'};

print "Content-type: text/html\n\n";
print "<HTML><HEAD><TITLE>Delete Results</TITLE></HEAD><BODY>";

opendir (LOGFILES, "../../logs");
@logfiles = readdir(LOGFILES);
closedir (LOGFILES);
chdir ("../../logs") || &ErrorMessage;

foreach $file (@logfiles) {		
	if ($file =~ /^logfile$year.*/) {
		unlink ($file) || &ErrorMessage ;
		print "<BR>$file was deleted";	
	} else {
		print "<BR>$file will not be deleted";
		}
}






sub ErrorMessage {
	print "<P>The server has a problem. Aborting script. \n";
	exit;
}
