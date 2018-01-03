#!/usr/bin/perl

print "\n","Converts a DOS text file into a UNIX text file.\n\n";
print "Enter the name of the file you wish to convert: ";
chop($f=<>);
$dir = `pwd`;
system "pushd $dir";
system "tr -d '\r' < $f > tmp";
system "mv tmp $f";
system "popd";
print "\n","O.K., have a nice day.\n\n";

