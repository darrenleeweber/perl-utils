#!/usr/local/bin/perl

if ($ENV{'REQUEST_METHOD'} eq 'GET') {
	@pairs = split(/&/, $ENV{'QUERY_STRING'});
} elsif ($ENV{'REQUEST_METHOD'} eq 'POST') {
	read (STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
	@pairs = split(/&/, $buffer);
} else {
	print "Content-type: text/html\n\n";
	print "<P>Use Post or Get";
}

foreach $pair (@pairs) {
	($key, $value) = split (/=/, $pair);
	$key =~ tr/+/ /;
	$key =~ s/%([a-fA-F0-9] [a-fA-F0-9])/pack("C", hex($1))/eg;
	$value =~ tr/+/ /;
	$value =~ s/%([a-fA-F0-9] [a-fA-F0-9])/pack("C", hex($1))/eg;
	
	$value =~s/<!--(.|\n)*-->//g;
	
	if ($formdata{$key}) {
		$formdata{$key} .= ", $value";
	} else {
		$formdata{$key} = $value;
	}
}

print "Content-type: text/html\n\n";
foreach $key (sort keys(%formdata)) {
	print "<P>The field named <B>$key</B> contained <B>$formdata{$key}</B>";
}

	
