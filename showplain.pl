#!/umr/bin/perl
 
 ######################################################################
 # c2html.pl - C to HTML parser                                       #
 ######################################################################
 # Written by Matt Schuette and Dave Batton                           #
 #                                                                    #
 # To use, call c2html.pl with these arguments:                       #
 #   filename                           <mandatory>                   #
 #   preprocess color (#include's)      <optional>                    #
 #   keyword color    (int, if, etc...) <optional>                    #
 #   comment color    (//Comment)       <optional>                    #
 #   background color (FF0000=red)      <optional>                    #
 #   foregorund color (0000FF=blue)     <optional>                    #
 #                                                                    #
 # All arguments should be separated by commas.                       #
 # Any optional argument may be omitted as in:                        #
 #    ...c2html?name.cpp,,,,000000,FFFFFF                             #
 # This would set only the background and text colors.  The filename  #
 # should be fully-qualified unless it resides in the same directory  #
 # as the script.                                                     #
 #                                                                    #
 # You may freely copy and distribute this file as long as all        #
 # acknowledgements remain intact.                                    #
 ######################################################################
 
 
 #Get the arguments
 @ARGS = split(/,/,$ARGV[0]);
 if($ARGS[0]) {
   open(CFILE, $ARGS[0]) || DieGracefully($ARGS[0],$!); }
 else {
   #print "Content-type: text/html\n\n";
   #print "<html><body>Error - No file specified!\n</body></html>";
   ShowMeTheFormat();
   exit;
 }
 
 #Get the filename from the path for a title.
 @splitFILENAME=split(m#/#,$ARGS[0]);
 $fname=$splitFILENAME[$#splitFILENAME];
 
 #Read in the lines
 @LINES=<CFILE>;
 close(CFILE);
 
 #The following if/else constructs set the colors to 
 #those specified or the defaults
 if($ARGS[1]) {
   $directivecolor= $ARGS[1];
 } else {
   $directivecolor="\"0000AA\"";
 }
 if($ARGS[2]) {
   $keywordcolor=$ARGS[2];
 } else {
   $keywordcolor="\"AA0000\"";
 }
 if($ARGS[3]) {
   $commentcolor=$ARGS[3];
 } else {
   $commentcolor="\"00AA00\"";
 }
 if($ARGS[4]) {
   $bgcolor=$ARGS[4];
 } else {
   $bgcolor="\"FFFFFF\"";
 }
 if($ARGS[5]) {
   $textcolor=$ARGS[5];
 } else {
   $textcolor="\"000000\"";
 }
 
 #These are what we will be inserting for color
 $end="</font>";
 $dcolor="<font color=$directivecolor>";
 $kcolor="<font color=$keywordcolor>";
 $ccolor="<font color=$commentcolor>";
 
 #This is a list of all the C++ keywords.  You may add anything
 #to this list in order to catch and color that word in the same
 #color as the rest of the keywords.
 @keywords = qw(asm auto bool break case catch char class const const_cast 
                default delete do double dynamic_cast else enum explicit 
                extern false float for friend goto if inline int long 
                mutable namespace new operator private protected public 
                register reinterpret_cast return short signed sizeof 
                static static_cast struct switch template this throw true 
                try typedef typeid typename union unsigned using virtual 
                void volatile wchar_t while);
 
 
 $CommentBlockFlag = 0;
 $TEN=pack("C",10);
 $THIRTEEN=pack("C",13);
 
 #This foreach loop goes through the input file line-by-line and formats it
 #to HTML.
 foreach $LINE (@LINES) {
   if( !($LINE =~ /$THIRTEEN$TEN/)) {
     $LINE =~ s/$TEN/$THIRTEEN.$TEN/eg;
   }
   $LINE =~ s/</&lt;/g;  #Substitute < and > with HTML equivalents
   $LINE =~ s/>/&gt;/g;  #
   if($LINE =~ m#(.*)(/\*)(.*)# && $CommentBlockFlag == 0) {
     $CommentBlockFlag = 1;
     $LINE = $1.$ccolor.$2.$3;
   }
   if($LINE =~ m#(.*)(\*/)(.*)# && $CommentBlockFlag == 1) {
     $CommentBlockFlag=0;
     $LINE = $1.$2.$end.$3;
   }
   $LINE_was_split=0;
   if($LINE =~ m#(.*?)//(.*)# && $CommentBlockFlag == 0) {
     $splitLINE[0]=$1;
     $splitLINE[1]=$2;
     $LINE_was_split=1;
   }
   else {
     $splitLINE[0]=$LINE;
   }
   if($CommentBlockFlag == 0) {
     $splitLINE[0] =~ s/(\s*)(#\w*)([\s<"]?)/$1.$dcolor.$2.$end.$3/eg;
     foreach $keyword (@keywords) {
         $splitLINE[0] =~ s/(^\s*|[()<>\W])($keyword)([\s()&*<>\W])/$1.$kcolor.$2.$end.$3/eg;
     }
   }
   if($LINE_was_split) {
     $LINE=$splitLINE[0].$ccolor."//".$splitLINE[1].$end;
   }
   else {
     $LINE=$splitLINE[0];
   }
 }
 
 #For lack of a better solution, this foreach loop will
 #go through and remove formatting in comment blocks.
 foreach $LINE (@LINES) {
   if($LINE =~ m#(.*)(/\*.*\*/)(.*)#) {
     $LINE=$1.remhtml($2).$3;
   }
   elsif($LINE =~ m#(.*)(/\*.*)#) {
     $splitLINE[0]=$1;
     $splitLINE[1]=$2;
     $splitLINE[0] = cleanup($splitLINE[0]);
     $LINE=$splitLINE[0].$splitLINE[1];
   }
   elsif($LINE =~ m#(.*\*/)(.*)#) {
     $splitLINE[0]=$1;
     $splitLINE[1]=$2;
     $splitLINE[0] = remhtml($splitLINE[0]);
     $LINE = $splitLINE[0].$splitLINE[1];
   }
 }
 print_html();
 #############  End of script  ###########
 
 
 ############# Functions below ###########
 
 #Remove all HTML Tags (written by Matt Wright)
 sub remhtml {
   $LINE=$_[0];
   $LINE =~ s/<([^>]|\n)*>//g;
   return $LINE;
 }
 
 #Put font tags in where they are needed
 sub cleanup {
   $LINE=$_[0];
   $LINE =~ s/(\s*)(#\w*)([\s<"])/$1.$dcolor.$2.$end.$3/eg;
   foreach $keyword (@keywords) {
     $LINE =~ s/(^\s*|[()<>\W])($keyword)([\s()&*<>\W])/$1.$kcolor.$2.$end.$3/eg;
   }
   return $LINE;
 }
 
 #Print the HTML formatted file
 sub print_html {
 print "Content-type: text/html\n\n";
 print <<header;
 <HTML>
 <HEAD>
 <TITLE>$fname - Parsed by c2html</TITLE>
 </HEAD>
 <BODY bgcolor=$bgcolor text=$textcolor>
 <PRE>
 <font color=$commentcolor>//Parsed using c2html Perl script
 //Written by Matt Schuette and Dave Batton</font><br>
 header
 foreach $LINE (@LINES) {
   print $LINE;
 }
 print <<footer;
 </PRE>
 <!-- This HTML file generated using the Perl script, c2html, by Matt Schuette and Dave Batton -->
 </BODY>
 </HTML>
 footer
 }
 
 #If no arguments are given, show the user how to use c2html
 sub ShowMeTheFormat {
   print "Content-type: text/html\n\n";
   print <<ShowFormat;
 <html>
 <head>
 <title>How to use c2html</title>
 </head>
 <body>
 <center>
 <font size=+3>How to use c2html</font><br><br>
 The correct usage of c2html is as follows:<br><br>
 </center>
 <pre>
 &lt;path_to_script&gt;/c2html.pl?&lt;filename&gt;,[directive color],[keyword color],[comment color],[bgcolor],[text color]<br>
 </pre>
 <tt>&lt;path_to_script&gt;</tt> is the path to the script.  For UMR students, this is <tt>http://wwwcgi.umr.edu/cgi-bin/cgiwrap/&lt;username&gt;</tt>
 assuming that the script was copied to your account.<br>
 (remaining arguments are optional)<br><br>
 <tt>[directive color]</tt> is the color of <tt>#include</tt>s and other preprocessor directives.<br>
 <tt>[keyword color]</tt> is the color of the various keywords such as <tt>if, int, new</tt>,etc.<br>
 <tt>[comment color]</tt> is the color of all comment blocks.<br>
 <tt>[bgcolor]</tt> is the background color of the page to be generated.<br>
 <tt>[text color]</tt> is the color of the text to be generated.<br>
 <br>
 Here is an example:<br>
 <tt>http://wwwcgi.umr.edu/cgi-bin/cgiwrap/schuette/c2html.pl?queue.cpp,,,,000000,FFFFFF</tt><br>
 This will display the file <tt>queue.cpp</tt> with a black background and white text.  The remaining colors use the defaults.<br><br><br>
 c2html created by Matt Schuette and Dave Batton.
 </body>
 </html>
 ShowFormat
 }
 
 #If a bad file is given, don't show a 500 error
 sub DieGracefully {
   print "Content-type: text/html\n\n";
   print "Error opening $_[0] - $_[1]\n";
   exit;
 }
