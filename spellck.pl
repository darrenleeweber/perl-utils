Article: 1975 of comp.lang.perl
Xref: feenix.metronet.com comp.lang.perl:1975
Newsgroups: comp.lang.perl
Path: feenix.metronet.com!news.utdallas.edu!wupost!zaphod.mps.ohio-state.edu!saimiri.primate.wisc.edu!usenet.coe.montana.edu!news.u.washington.edu!uw-beaver!fluke!inc
From: inc@tc.fluke.COM (Gary Benson)
#Subject: Re: Perl spell checker
Message-ID: <1993Apr4.145304.4126@tc.fluke.COM>
Organization: John Fluke Mfg. Co., Inc., Everett, WA
References: <riskit-020493095036@47.201.0.36>
Date: Sun, 4 Apr 1993 14:53:04 GMT
Lines: 109

In article <riskit-020493095036@47.201.0.36> riskit@bnr.ca (Reg Foulkes) writes:
>Has anyone written a spell checker in perl for UNIX? 
>
>riskit@bnr.ca
>phone (613) 763-4131
>Ottawa, Ontario Canada.


No, but it should be trivial, given the thousands of lines of code that must
have been written already based on "Computing the Difference of Two Arrays"
(Camel, First Printing, p. 202).

I have something that might serve as a starting point. I wrote this script
because our publishing application makes lists of words that it does not
know how to hyphenate. My job is to gather those lists, hyphenate the words,
then feed them into a hyphenation dictionary.

Occasionally I cat these files, sort -u them and run the following against
the most recent list our editor is hyphenating. It should be pretty easy to
convert this to a spell checker by hardwiring in /usr/dict/words as the file
to compare against, and an input file as the file full of words to check.


#!/usr/local/perl -s
++$debug if $d;

#
#	Compare two lists of words, output new words
#

system "/bin/ls -F";

print "Starting list name:  ";
chop ($existingdb = <>);
print "New list:  ";
chop ($newlist = <>);

print "Reading new list into memory\n\n" if $debug;

open(ED,"<$existingdb") || die ("Failed opening existing database\n");
select(ED);
$/ = '';			# Set slurp mode

$_ = <ED>;			# Suck hard!  Get it all
close(ED);

@db = split;			# Break up into individual words

open(NW,"<$newlist") || die ("Failed opening newword database\n");

select(NW);
$/ = '';			# Set slurp mode

$_ = <NW>;			# Get it all
close(NW);

@nw = split;			# Break up into individual words

				# Set up associative array with the database
foreach $word (@db) {
    $dbarray{$word} = '';	# Just define by key; no value needed
}

# Now test the candidate words against the db

@truly_new = grep(!(defined $dbarray{$_}),@nw);
select (STDOUT);
				# Print out the qualified list of new words:
                                # put onto display and into new file

print "Final Phase. Checking new words against data base.\n\n" if $debug;
    local ($_);
    open (TN, ">trulynew");
    while ($_ = shift(@truly_new)) {
        print "$_\n";
	print TN "$_\n";
  }
close (TN);


-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_

Seems like all you'd need to do is feed the list instead of typing in a
filename, then make /usr/dict/words the file to compare against. In fact,
now that I think of it, you could prepare the way by making /usr/dict/words
already exist as a dbm file.

Ooops! It just occurred to me that when you asked about a "spell-checker",
you probably meant that you want to check a whole file, not just a list of
words. That probably means that you'll do some sort of pre-elimination of
numbers, the words "a", "and", "of", "from", and probably others.

Hmmmmm..... well, I'll leave that as an exercise for the reader.

Shouldn't be too hard, given that perl is optimized for scanning arbitary
text files, extracting information from those text files, and printing
reports based on that information.

                              O     \
			        __   )
				     )
		              O     /


-- 
Gary Benson   -_-_-_-_-_-_-_-_-_-inc@sisu.fluke.com_-_-_-_-_-_-_-_-_-_-_-_-_-_-

Panic moved through the catacombs like a compulsive housekeeper, emptying
the ashtrays of reason and mopping up the tracks of experience. -Tom Robbins


