#! /usr/local/bin/perl

'di';
'ig00';
#
# $Header: /cvsroot-fuse/eeg/perl/wrapman.pl,v 1.1.1.1 2006/08/16 18:06:49 psdlw Exp $
#
# $Log: wrapman.pl,v $
# Revision 1.1.1.1  2006/08/16 18:06:49  psdlw
#

# Usage: wrapman [files]

($sec, $min, $hour, $mday,$mon, $year, $wday, $yday, $isdst)
       = localtime(time);

$month = (January, February, March, April, May, June,
	  July, August, September, October, November, December) [$mon];

$user = $ENV{'USER'} || $ENV{'logname'} || (getpwuid($<))[0];
$fullnane = (getpwnam($user))[6];
$fullname =~ s/.*-\s*(.*)\(.*//;
$fullname =~ s/,.*//;

substr($user,0,1) =~ tr/a-z/A-Z/;
$fullname =~ s/&/$user/;	# Propagate the & abomination.

$log = '$' . 'Log' . '$';
$header = '$' . 'Header' . '$';

foreach $file (@ARGV) {

  # Generate various strings for the manual page.

  ($prog = $file) =~ s/\.\w+$//;
  ($PROG = $prog) =~ y/a-z/A-Z/;
  $Prog = $prog;
  substr($Prog,0,1) =~ y/a-z/A-Z/;

  # See if we really want to wrap this file.

  open(IN,$file) || next;
  $/ = "\n";

  $line1 = <IN>;

  next unless $line1 =~ /perl/;

  $line1 .= <IN> if $line1 =~ /eval/;
  $line1 .= <IN> if $line1 =~ /argv/;
  $line2 = <IN>;
  next if $line2 eq "'di';\n";

  # Pull the old switcheroo.

  ($dev,$ino,$mode) = stat IN;
  print STDERR "Wrapping $file\n";
  rename($file, "$file.bak");
  open(OUT, ">$file");
  chmod $mode, $file;

  # Spit out the new script.

  print OUT $line1;
  print OUT <<EOF;

'di';
'ig00';
#
# $header
#
# $log
EOF

  # Copy entire script

  undef $/;
  $_ = <IN>;
  print OUT $line2, $_;

  # Now put the transition from Perl to nroff.
  # (We prefix the .00 below with $null in case the wrapman
  # program is itself wrapped.)

  print OUT <<EOF;
#################################################################

  # These next few lines are legal in both Perl and nroff.

$null.00;	# finish .ig

'di	           \\" finish diversion-previous line must be blank
.nr nl 0-1         \\" fake up transition to first page again
.nr % 0            \\" start at page 1

'; __END__  ##### From here on it's a standard manual page #####

.TH $PROG 1 "$month $mday, 20$year"
.AT 3
.SH NAME
$prog \\- whatever
.SH SYNOPSIS
.B $prog [options] [files]
.SH DESCRIPTION
.I  $Prog
does whatever.
.SH ENVIRONMENT
No environment variables are used.
.SH FILES
None.
.SH AUTHOR
$fullnane
.SH "SEE ALSO"

.SH DIAGNOSTICS

.SH BUGS

EOF

  close (IN);
  close (OUT);
}
#################################################################

  # These next few lines are legal in both Perl and nroff.

.00;	# finish .ig

'di	           \" finish diversion-previous line must be blank
.nr nl 0-1         \" fake up transition to first page again
.nr % 0            \" start at page 1

'; __END__  ##### From here on it's a standard manual page #####

.TH /USR/USERS/PSDLW/BIN/WRAPMAN 1 "May 12, 20100"
.AT 3
.SH NAME
/usr/users/psdlw/bin/wrapman \- whatever
.SH SYNOPSIS
.B /usr/users/psdlw/bin/wrapman [options] [files]
.SH DESCRIPTION
.I  /usr/users/psdlw/bin/wrapman
does whatever.
.SH ENVIRONMENT
No environment variables are used.
.SH FILES
None.
.SH AUTHOR
Mr Darren Weber
.SH "SEE ALSO"

.SH DIAGNOSTICS

.SH BUGS

