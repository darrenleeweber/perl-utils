#! perl

$closelink = "</a><br>";
$link = "<a href=\"";

while(<@ARGV>){
  if(/-l/){ shift; $link .= shift; }
  if(/-h/){ &HELP; }
}

&HEADER;

while(<>){
  chop;
  print "$link${_}\">${_}$closelink\n";
}

&FOOTER;


####################################################################################

sub HELP {
  print "Adds html link tags to a listing of files.\n\n",

        "html_linkwrap_filelist.pl -l <link_prefix>\n\n",

        "eg, ls | html_linkwrap_filelist.pl -l ftp://www.ftp.com/pub/\n",
        "ie,      html_linkwrap_filelist.pl -l ftp://www.ftp.com/pub/ < `ls`\n\n",

        "will output an html file to STDOUT, with each file tags as an ftp\n",
        "link, ready for download.\n\n";
  exit;
}


sub HEADER {
  print "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">\n\n";
  print "<HTML><HEAD><TITLE>";
  print "File Listing";
  print "</TITLE></HEAD><BODY>\n\n";
}
	
sub FOOTER {
  print "\n</BODY></HTML>";
}
