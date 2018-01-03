#!/usr/local/bin/perl
print "Content-type: text/html\n\n";

if (-e "../tmp/archives") {
	chdir ("../tmp/archives") || &ErrorMessage("chdir");
	opendir (ARCHIVES, ".") || &ErrorMessage("opendir");
	@archives = readdir (ARCHIVES);
	closedir (ARCHIVES);
	shift (@archives);
	shift (@archives);
	
	if (@archives) {
		foreach $file (@archives) {
			print "<P>looking at file $file";
			unlink ($file) || &ErrorMessage("unlink");
			print "<P>$file was deleted";
			}
		
	} else {
		print "<P>the archives directory was empty";
		}	
	rmdir ("/home/user4/lcastro/WWW/tmp/archives") || &ErrorMessage("rmdir");
		print "<P>The directory has been removed";
	} else {
		print "<P>The directory could not be found";
		}

sub ErrorMessage {
	%errors = ("chdir","change the directory", "opendir", "open the directory","rmdir", "remove the directory", "unlink", "delete the file"); 
	print "<P>The server could not $errors{$_[0]}. Aborting script. \n";
	exit;
}
