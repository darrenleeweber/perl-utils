#! /usr/bin/perl
#### 
##
##  IMPORTANT!: The path of perl listed above MUST be the path 
##              used on your system!
###########################################################################
#
#  html2text
#
#  A perl script designed to read HTML files and convert them into
#  some form of text representation.  The output format is controlled
#  by "tag" files that are included automatically based on the name of
#  the executable (for example, naming this file "html2latex" would
#  load the "html2latex.tag" file automatically).  Users can provide
#  their own tag files to customize the translation even further.
#
#  Usage:
#
#     html2text [options] [infile] [outfile]
#
#  where "options" is one of
#
#     -f formatfile	specifies an additional .tag file to load
#
#     (see also the .tag files for more options defined there)
#
#  and "infile" is the name of the .html file to parse (or "-" for
#  standard input), and "outfile" is the name of the file to write (or
#  "-" for standard out).  If "infile" is missing it defaults to "-".
#  If "outfile" is missing, it defaults to the input file name with
#  its extension replaced by ".txt" (or possibly some other string
#  specified in the .tag file), or to "-" if "infile" is "-".
#
#  The .tag files are perl scripts that define variables and
#  subroutines that extend the functions of html2text.  These are what
#  make it possible to output special dialects like TeX, LaTeX, etc.
#  They usually contain definitions of $htmlChar, $htmlTag and
#  $htmlEntity variables, plus some associated subroutines.
#  See the .tag files for more information on how they work.
#
#  Environment Variables:
#
#    HTML2FORMAT	directory path where .tag files are stored
#    HTML2TEXT		pointer to user-specified customization file
#                         for html2text command
#    XXX		if this perl script is renamed to be some other
#			  name (like "html2latex") then the environment
#			  variable with that name (e.g. "HTML2LATEX")
#			  will point to the user-specified custom .tag file
#			  for that format.
#
###########################################################################
#
#  Update History:
#
#  who     when		what
#  ------ --------     ------------------------------------------
#  schaefer 7/97        Fixed bugs involving $htmlFormatPath and &htmlTag
#
#  dpvc     1/96	Added script path to $htmlFormatPath automatically
#
#  dpvc    11/95	Fixed a bug with removal of leading spaces.
#			Convert TABs to SPACEs before the line is processed.
#
#  dpvc	   10/95	Wrote it.
#


#
#  This is the path where .tag files can be found.  You may need to
#  customize this for your installation.  This should be the only item
#  that is installation-dependent.  The directory where this script
#  runs from is added automatically to the path.
#

$htmlFormatPath = ".";
if ($0 =~ m!/[^/]*$!) {$htmlFormatPath .= ":$`" if ($` ne "" && $` ne ".")}

#
#  The maximum width of a line of text for the output file
#
$htmlWidth = 78;

#
#  The default extension for the output file (may be changed within
#  .tag files)
#
$htmlExtension = ".txt";


#
#  The initial and terminal strings for the output file.
#  These are usually set by the .tag file.  For example, in the
#  html2latex.tag file, these include the \documentstyle command and
#  the \begin{document} command required by LaTeX.
#
$htmlInitialString = "";
$htmlFinalString = "";

#
#  $htmlPrintInitFinStr controls whether the initial and terminal strings
#  are printed.  By default, it is set to 1 and the strings are printed.
#  A command line flag allows this to be set to 0 and supress these strings
#  when processing a TeX file for inclusion in another TeX file.

$htmlPrintInitFinStr = 1;


#
#  $htmlBreakChars is a string of characters where line breaks can be
#  made if there are no spaces in a line to be broken.  For example,
#  $htmlBreakChars = "\\\{" will allow breaks before the back slash
#  and before the open brace.  When such a break is made, the
#  $htmlBreakNL character is inserted at the end of the line.  For
#  example, if $htmlBreakNL = "%" then lines that are broken at
#  non-spaces will end with a percent sign.  This is appropriate for
#  TeX output.
#

$htmlBreakChars = "";
$htmlBreakNL = "";

#
#  These are the special characters in HTML.  You can add other ones
#  by defining more entries in this associative array.  For example,
#  you can use $htmlChar{"{"} = '\{' to make "{" translate to "\{" in
#  the output file (this is appropriate for TeX output).
#
#  If the right-hand side begins with an ampersand (&) then the string
#  is executed via and "eval" statement when that character appears in
#  the input file; otherwise, the right-hand side is inserted as is
#  into the output file in place of the input character.
#
#  The two examples below call perl subroutines when their associated
#  characters are found in the input file; the example above replaces
#  the input character with a literal string.

$htmlChar{"<"} = '&htmlTag';
$htmlChar{"&"} = '&htmlEntity';

#
#  The characters to output for an open angle bracket and an
#  ampersand (for use within &htmlTag and &htmlEntity).
#

$htmlLtString = "<";
$htmlAmpString = "&";


#
#  The following associative array defines the translations for the
#  different HTML entity names.  As with $htmlChar above, if the
#  string begins with an ampersand (&), then the string is executed
#  when the entity appears in the input file, otherwise the string
#  is sent to the output file as is.
#
#  If an entity appears that is not named here, then its name is sent
#  to the output file instead.
#

$htmlEntity{"amp"} = '&htmlPrint($htmlAmpString)';
$htmlEntity{"lt"} = '<';
$htmlEntity{"gt"} = '>';
$htmlEntity{"nbsp"} = ' ';

$htmlEntity{"iexcl"} = '';
$htmlEntity{"cent"} = '';
$htmlEntity{"pound"} = '#';
$htmlEntity{"curren"} = '';
$htmlEntity{"yen"} = '';
$htmlEntity{"brvbar"} = '|';
$htmlEntity{"brkbar"} = '|';
$htmlEntity{"sect"} = '';
$htmlEntity{"uml"} = '';
$htmlEntity{"copy"} = '(c)';
$htmlEntity{"ordf"} = '';
$htmlEntity{"laquo"} = '<<';
$htmlEntity{"not"} = '-';
$htmlEntity{"shy"} = '';
$htmlEntity{"reg"} = '(r)';
$htmlEntity{"hibar"} = '-';
$htmlEntity{"deg"} = '';
$htmlEntity{"plusmn"} = '+-';
$htmlEntity{"sup2"} = '^2';
$htmlEntity{"sup3"} = '^3';
$htmlEntity{"acute"} = "'";
$htmlEntity{"micro"} = '';
$htmlEntity{"para"} = '';
$htmlEntity{"middot"} = '.';
$htmlEntity{"cedil"} = '';
$htmlEntity{"sup1"} = '^1';
$htmlEntity{"ordm"} = '';
$htmlEntity{"raquo"} = '>>';
$htmlEntity{"frac14"} = '1/4';
$htmlEntity{"frac12"} = '1/2';
$htmlEntity{"frac34"} = '3/4';
$htmlEntity{"iquest"} = '';
$htmlEntity{"Agrave"} = 'A';
$htmlEntity{"Aacute"} = 'A';
$htmlEntity{"Acirc"} = 'A';
$htmlEntity{"Atilde"} = 'A';
$htmlEntity{"Auml"} = 'A';
$htmlEntity{"Aring"} = 'A';
$htmlEntity{"AElig"} = 'AE';
$htmlEntity{"Ccedil"} = 'C';
$htmlEntity{"Egrave"} = 'E';
$htmlEntity{"Eacute"} = 'E';
$htmlEntity{"Ecirc"} = 'E';
$htmlEntity{"Euml"} = 'E';
$htmlEntity{"Igrave"} = 'I';
$htmlEntity{"Iacute"} = 'I';
$htmlEntity{"Icurc"} = 'I';
$htmlEntity{"Iuml"} = 'I';
$htmlEntity{"ETH"} = '';
$htmlEntity{"Dstrok"} = '';
$htmlEntity{"Ntilde"} = 'N';
$htmlEntity{"Ograve"} = 'O';
$htmlEntity{"Oacute"} = 'O';
$htmlEntity{"Ocirc"} = 'O';
$htmlEntity{"Otilde"} = 'O';
$htmlEntity{"Ouml"} = 'O';
$htmlEntity{"times"} = 'x';
$htmlEntity{"Oslash"} = 'O';
$htmlEntity{"Ugrave"} = 'U';
$htmlEntity{"Uacute"} = 'U';
$htmlEntity{"Ucirc"} = 'U';
$htmlEntity{"Uuml"} = 'U';
$htmlEntity{"Yacute"} = 'Y';
$htmlEntity{"THORN"} = '';
$htmlEntity{"szlig"} = 'ss';
$htmlEntity{"agrave"} = 'a';
$htmlEntity{"aacute"} = "a";
$htmlEntity{"acirc"} = 'a';
$htmlEntity{"atilde"} = 'a';
$htmlEntity{"auml"} = 'a';
$htmlEntity{"aring"} = 'a';
$htmlEntity{"aelig"} = 'ae';
$htmlEntity{"ccedil"} = 'c';
$htmlEntity{"egrave"} = 'e';
$htmlEntity{"eacute"} = 'e';
$htmlEntity{"ecirc"} = 'e';
$htmlEntity{"euml"} = 'e';
$htmlEntity{"igrave"} = 'i';
$htmlEntity{"iacute"} = 'i';
$htmlEntity{"icirc"} = 'i';
$htmlEntity{"iuml"} = 'i';
$htmlEntity{"eth"} = '';
$htmlEntity{"ntilde"} = 'n';
$htmlEntity{"ograve"} = 'o';
$htmlEntity{"oacute"} = 'o';
$htmlEntity{"ocirc"} = 'o';
$htmlEntity{"otilde"} = 'o';
$htmlEntity{"ouml"} = 'o';
$htmlEntity{"divide"} = '/';
$htmlEntity{"oslash"} = 'o';
$htmlEntity{"ugrave"} = 'u';
$htmlEntity{"uacute"} = 'u';
$htmlEntity{"ucirc"} = 'u';
$htmlEntity{"uuml"} = 'u';
$htmlEntity{"yacute"} = 'y';
$htmlEntity{"thorn"} = '';
$htmlEntity{"yuml"} = 'y';

#
#  The special entity form "&#nnn;" is handled by inserting the ASCII
#  character with number nnn if nnn < 160, otherwise the correct
#  entity from the list above is selected.  The association of numbers
#  to names is done with the following array.
#

@htmlNumberEntity =
(
  "nbsp", "iexcl", "cent", "pound", "curren",        # 160 - 164
    "yen", "brvbar", "sect", "uml", "copy",          # 165 - 169
  "ordf", "laquo", "not", "shy", "reg",              # 170 - 174
    "hibar", "deg", "plusmn", "sup2", "sup3",        # 175 - 179
  "acute", "micro", "para", "middot", "cedil",       # 180 - 184
    "sup1", "ordm", "raquo", "frac14", "frac12",     # 185 - 189
  "frac34", "iquest", "Agrave", "Aacute", "Acirc",   # 190 - 194
    "Atilde", "Auml", "Aring", "AElig", "Ccedil",    # 195 - 199
  "Egrave", "Eacute", "Ecirc", "Euml", "Igrave",     # 200 - 204
    "Iacute", "Icurc", "Iuml", "ETH", "Ntilde",      # 205 - 209
  "Ograve", "Oacute", "Ocirc", "Otilde", "Ouml",     # 210 - 214
    "times", "Oslash", "Ugrave", "Uacute", "Ucirc",  # 215 - 219
  "Uuml", "Yacute", "THORN", "szlig", "agrave",      # 220 - 224
    "aacute", "acirc", "atilde", "auml", "aring",    # 225 - 229
  "aelig", "ccedil", "egrave", "eacute", "ecirc",    # 230 - 234
    "euml", "igrave", "iacute", "icirc", "iuml",     # 235 - 239
  "eth", "ntilde", "ograve", "oacute", "ocirc",      # 240 - 244
    "otilde", "ouml", "divide", "oslash", "ugrave",  # 245 - 249
  "uacute", "ucirc", "uuml", "yacute", "thorn",      # 250 - 255
    "yuml"                                           # 256
 );


#
#  The following definitions determine way that the different HTML
#  tags will be handled.  Tag names must appear below in all upper
#  case (though they can be in mixed case in the input file).  Tags
#  that are not defined will be ignored (and will not appear in the
#  output file.
#
#  As with $htmlChar and $htmlEntity above, if a tag's value begines
#  with and ampersand (&), then the string will be executed when the
#  tag appears in the input file, otherwise the string will be sent to
#  the output file.  For example, the definitions below mean that the
#  <P> paragraph tag will translate to a blank line in the outputfile,
#  while the <IMG> tag will call the &htmlIMG subroutine for further
#  processing.  The </P> tag will be removed from the file, since it
#  has no definition below.
#
#  The .tag files can augment the basic functionality of this file by
#  defining translation strings new tags, or different strings for
#  some of the tags listed below.
#

$htmlTag{"P"} = "\n\n";    # a blank line

$htmlTag{"BR"} = "\n";     # a line break
$htmlTag{"HR"} =           # a horizontal line
   "\n---------------------------------------------------------------\n";
$htmlTag{"IMG"} = '&htmlIMG';  # process images specially


#
#  The text between <HEAD> and </HEAD> or <TITLE> and </TITLE>
#  will be ignored and will not appear in the output file
#
$htmlTag{"HEAD"} = '&htmlSuspendOutput';
$htmlTag{"/HEAD"} = '&htmlRestoreOutput';
$htmlTag{"TITLE"} = '&htmlSuspendOutput';
$htmlTag{"/TITLE"} = '&htmlRestoreOutput';

#
#  Lists simply start on a new line (see html2text.tag for a more
#  complete implementation of lists).
#
$htmlTag{"UL"} = "\n"; $htmlTag{"/UL"} = "\n";
$htmlTag{"OL"} = "\n"; $htmlTag{"/OL"} = "\n";
$htmlTag{"LI"} = "\n";
$htmlTag{"DL"} = "\n"; $htmlTag{"/DL"} = "\n";
$htmlTag{"DT"} = "\n";
$htmlTag{"DD"} = "\n";

#
#  Blockquotes are separate paragraphs (see html2text.tag for a more
#  complete implementation)
#
$htmlTag{"BLOCKQUOTE"} = "\n\n";
$htmlTag{"/BLOCKQUOTE"} = "\n\n";

#
#  PRE formatted text is handled specially
#
$htmlTag{"PRE"} = '&htmlPRE';
$htmlTag{"/PRE"} = '&htmlPREend';

#
#  Make headers be separate paragraphs
#
$htmlTag{"H1"} = "\n\n"; $htmlTag{"/H1"} = "\n\n";
$htmlTag{"H2"} = "\n\n"; $htmlTag{"/H2"} = "\n\n";
$htmlTag{"H3"} = "\n\n"; $htmlTag{"/H3"} = "\n\n";
$htmlTag{"H4"} = "\n\n"; $htmlTag{"/H4"} = "\n\n";
$htmlTag{"H5"} = "\n\n"; $htmlTag{"/H5"} = "\n\n";
$htmlTag{"H6"} = "\n\n"; $htmlTag{"/H6"} = "\n\n";

#
#  FORMs appear as separate paragraphs.  Ignore all the input items
#  (see html2text.tag for a more complete implementation).
#
$htmlTag{"FORM"} = "\n\n";
$htmlTag{"/FORM"} = "\n\n";
$htmlTag{"INPUT"} = '&htmlIgnoreSpaces';
$htmlTag{"TEXTAREA"} = '&htmlIgnoreSpaces';
$htmlTag{"SELECT"} = '&htmlIgnoreSpaces';

#
#  Ignore leading spaces in the text that follows
#
sub htmlIgnoreSpaces {$htmlLineSpace = 1}

#
#  Prevent text from going to the output file.  Calls to these
#  reoutines can be nested, and output will not restart until the
#  outermost &htmlRestoreOutput call.
#

sub htmlSuspendOutput {$htmlNoOutput++}
sub htmlRestoreOutput {$htmlNoOutput-- if ($htmlNoOutput > 0)}

#
#  Turn on and off PRE formatted mode
#
sub htmlPRE {&htmlPrint("\n"); $htmlPreMode = 1}
sub htmlPREend {$htmlPreMode = 0; &htmlPrint("\n")}

#
#  For an image, parse the rest of the tag parameters
#  If there is an ALT string, use it, otherwise print "[IMAGE]"
#
sub htmlIMG {&htmlParseTags; &htmlTextIMG}
sub htmlTextIMG
{
  if (defined($tag{"ALT"})) {&htmlOutputHTML($tag{"ALT"})}
    else {&htmlOutput("[IMAGE]")}
}

#
#  For INPUT tags, get the rest of the tag parameters
#  Get the type of the tag (TEXT is the default)
#  Call the appropriate subroutine to handle it
#
sub htmlInput
{
  local ($type);

  &htmlParseTags;
  $type = &htmlGetTag("TYPE","text");
  $type =~ tr/a-z/A-Z/;
  eval "&htmlInput$type";
}

#
#  <INPUT TYPE=hidden> has no function.  The .tag files must supply
#  other INPUT tag types.
#
sub htmlInputHIDDEN {}




###########################################################################
#
#  The following routines are the core of the html2text processor, and
#  should not be modified without great care.  The variables defined
#  here can be used by subroutines defined in .tag files, and can even
#  be modified when the need arises.
#
###########################################################################


#
#  This is the place where the unprocessed text from the input file is
#  stored.
#
$htmlBuffer = "";

#
#  &htmlMain  - the main loop
#
#  Get the list of special characters
#  If initial-final-string flag is set
#    Print the initial string
#  While there is more data in the file
#    Get the next line from the file
#    Try to process the data
#  If initial-final-string flag is set
#    Print the final string
#  Flush any buffered output
#
sub htmlMain
{
  local ($htmlCharList) = '[\\'.join('',sort(keys(%htmlChar))).']';

  if ($htmlPrintInitFinStr)  {&htmlPrint($htmlInitialString);}
  while (!eof(STDIN))
  {
    $htmlBuffer .= <STDIN>;
    &htmlHandleBuffer;
  }
  if ($htmlPrintInitFinStr)  {&htmlPrint($htmlFinalString);}
  &htmlPrint("\n") if ($htmlLine ne "");
}

#
#  &htmlHandleBuffer  - Process the characters in the input buffer
#
#  Convert tabs to spaces (even in PRE mode)
#  While there is a special character in the buffer
#    Set the buffer to be whatever follows it
#    Output the stuff that preceeds it
#    Process the special character
#  Output any remaining text and clear the buffer
#  
sub htmlHandleBuffer
{
  $htmlBuffer =~ s/\t/ /g;
  while ($htmlBuffer =~ m/$htmlCharList/o)
  {
    $htmlBuffer = $';
    &htmlOutput($`);
    &htmlHandleChar($&);
  }
  &htmlOutput($htmlBuffer);
  $htmlBuffer = "";
}

#
#  &htmlFindNext  - Look for a pattern in the input file
#
#  If we're allowed to read more data, read from the file until we
#   find the pattern.
#  If the buffer contains the pattern
#    Save the stuff following it in the buffer
#    Return the material up to the match, and the match itself
#  Otherwise
#    Return the entire buffer (with no match string), and clear the buffer
# 
$htmlReadingSTDIN = 1;   # controls whether to read more from the
			 # input file or just use what's in the buffer
sub htmlFindNext
{
  local ($pattern) = @_;

  while ($htmlBuffer !~ m/$pattern/i && ! eof(STDIN) && $htmlReadingSTDIN)
    {$htmlBuffer .= <STDIN>}
  if ($htmlBuffer =~ m/$pattern/i) {
    $htmlBuffer = $';
    return ($`,$&);
  } else {
    local ($tmp) = $htmlBuffer;
    $htmlBuffer = "";
    return ($tmp,"");
  }
}

######################################################################
#
#  Output routines
#
######################################################################

#
#  &htmlPrint  - send a string to the output buffer verbatim
#
#  Don't compress spaces
#  Change \n to \r (so we can tell that these are real newlines and
#    not ones from the file)
#  Output the string
#
$htmlForceSpaces = 0;		# true if output should not compress spaces
sub htmlPrint
{
  local ($htmlForceSpaces) = 1;
  local ($string) = @_;
  $string =~ s/\n/\r/g;
  &htmlOutput($string);
}


#
#  &htmlOutputHTML  - send a string to the output buffer, processing
#                     any embedded HTML commands
#
#  Locally set the buffer to the output string
#  Locally don't allow reading from the file
#  Process the buffer (i.e., look for Entities or other translations)
#    Warning:  this allows for nested tags, which is not really legal,
#              but it was the easiest way to do this.
#
sub htmlOutputHTML
{
  local ($htmlBuffer) = @_;
  local ($htmlReadingSTDIN) = 0;
  &htmlHandleBuffer;
}


#
#  &htmlOutput  - break a string into lines and print them
#
#  If we have text to output, and we are allowing output
#    Break the string into lines and send them to the output routine
#    Output the last part with no line terminator
#
sub htmlOutput
{
  local ($string) = @_;

  if ($string ne "" && !$htmlNoOutput)
  {
    while ($string =~ m/(\n|\r+)/) {&htmlOutputLine($`,$&); $string = $'}
    &htmlOutputLine($string,"") if ($string ne "");
  }
}


$htmlLineNL = 0;	# 1 if we are at a line break in the input file
$htmlLinePar = 2;	# counts the number of \n we have printed
$htmlLineSpace = 1;     # 1 if the last character printed was a space,
		        # -1 if it was the $htmlBreakNL character

$htmlPreMode = 0;	# 1 if PRE mode in effect
$htmlIndent = "";	# indentation string
$htmlLine = "";		# text waiting to be output


#
#  &htmlOutput  - cook a line and send it to the output buffer
#
#  If we are in PRE mode
#    Add the indenting if this is the beginning of a line
#    Add the text to be printed and print it
#  Otherwise
#    Add a leading space if there was a NL in the file and
#      either the line is not empty and the previous thing wasn't a
#      space, or we just had a forced line break with $htmlBreakNL
#    If we are not preserving spaces
#      Make double spaces into single ones (except at sentence ends)
#      Eliminate leading spaces if we already have printed one
#      Eliminate trailing spaces if we have a newline to print
#    If we still have something to print, or we have a newline to print
#      Record whether there is a newline from the file
#      Add the data to the line buffer (may cause actual output)
#      If the newline contains \r, substitute \n for them and print
#    Otherwise
#      Check if there is a newline from the file
#      
sub htmlOutputLine
{
  local ($line,$nl) = @_;

  if ($htmlPreMode)
  {
    $htmlLine = $htmlIndent if ($htmlLine eq "");
    $htmlLine .= $line;
    &htmlPrintLine($nl);
  } else {
    $line = " ".$line if ($htmlLineNL && 
       (($htmlLine ne "" && !$htmlLineSpace) || $htmlLineSpace == -1));
    if (!$htmlForceSpaces)
    {
      $line =~ s/([^\.\:\!\?\"\']|^)  +/\1 /g;         ###LINE633
      $line =~ s/^ +// if ($htmlLineSpace == 1);
      $line =~ s/ +$// if ($nl ne "");
    }
    if ((($line ne " " || !$htmlLineNL) && $line ne "") || $nl =~ m/\r/)
    {
      $htmlLineNL = ($nl eq "\n");
      &htmlAddToLine("$line");
      if ($nl =~ s/\r/\n/g) {&htmlPrintLine($nl)}
    } else {
      $htmlLineNL |= ($nl eq "\n");
    }
  }
}


#
#  &htmlPrintLine  - print the output buffer and record new lines
#
#  If the line has some datta, print it, and clear the newline counter
#  Set the ignore-initial-spaces flag
#  Clear the line buffer
#  If this is a paragraph break
#    Print the correct number of newlines and count them
#  Otherwise if this is a line break
#    Print a newline if needed and count it
#  Otherwise the last thing printed is not a new line
#
sub htmlPrintLine
{
  local ($nl) = @_;

  if ($htmlLine ne $htmlIndent) {print $htmlLine; $htmlLinePar = 0}
  $htmlLineSpace = 1;
  $htmlLine = "";
  if ($nl eq "\n\n")
  {
    if ($htmlLinePar == 0) {print "\n\n"}
    elsif ($htmlLinePar == 1) {print "\n"}
    $htmlLinePar = 2;
  } elsif ($nl eq "\n") {
    print "\n" if (!$htmlLinePar);
    $htmlLinePar = 1;
  } else {$htmlLinePar = 0}
}

#
#  &htmlAddToLine  - Add some data to the output line buffer
#
#  Add the indentation if this is the start of a line
#  Add the new data to the line
#  While the line is too long:
#    Find the last space before the line gets too long
#    If there is no such space
#      If there are additional break characters and one of them is found
#        If it is the first thing on the line
#          Give up: simply break the line at the maximum length 
#          Add the break termination character (% for TeX)
#        Otherwise
#          Break the line before the given character and save the rest
#      Otherwise (no other breakpoints)
#        Give up: simply break at the maximum width and add the
#          break NL character (% for TeX)
#    Otherwise (a space was found)
#      Break the line at the space and remove the space
#    Print the portion of the line before the breakpoint
#    If there is more data, insert the indentation
#    Indicate that there is data after the last line break and that
#      spaces are still important
#  If the remaining line is not empty
#    Record whether it ended with a space (so new spaces will be ignored)
#    Record that we have data since the last line break
#    
sub htmlAddToLine
{
  local ($line,$i);

  $htmlLine = $htmlIndent if ($htmlLine eq "");
  $htmlLine .= "@_";
  while (length($htmlLine) > $htmlWidth)
  {
    $i = rindex($htmlLine," ",$htmlWidth);
    if ($i < length($htmlIndent))
    {
      if ($htmlBreakChars ne "" &&
          $line =~ m/[$htmlBreakChars][^$htmlBreakChars]*$/)
      {
	if ($& eq $htmlIndent)
	{
	  $line = substr($htmlLine,$htmlWidth);
	  $htmlLine = substr($line,0,$htmlWidth).$htmlBreakNL;
	} else {
	  $line = $&; $htmlLine = $`.$htmlBreakNL;
	}
      } else {
	$line = substr($htmlLine,$htmlWidth);
	$htmlLine = substr($htmlLine,0,$htmlWidth).$htmlBreakNL;
      }
    } else {
      $line = substr($htmlLine,$i+1);
      $htmlLine = substr($htmlLine,0,$i);
      $htmlLine =~ s/^ +//;
    }
    &htmlPrintLine("\n");
    if ($line ne "") {$htmlLine = $htmlIndent.$line}
    $htmlLinePar = 0; $htmlLineSpace = 1;
  }
  if ($htmlLine ne $htmlIndent)
  {
    $htmlLineSpace = (substr($htmlLine,-1,1) eq " ");
    $htmlLinePar = 0;
  }
}

#
#  &htmlHandleChar  - perform a special character's action
#
#  Get the string associated with the given character
#  Do what the string asks
#
sub htmlHandleChar
{
  local ($command) = $htmlChar{"@_"};
  &htmlDoString($command);
}

#
#  &htmlDoString  - execute or print a string
#
#  If the string begins with "&"
#    Evaluate the string as a perl command and report any errors
#  Otherwise print the string
#
sub htmlDoString
{
  local ($string) = @_;
  if (substr($string,0,1) eq "&") {eval $string; warn $@ if ($@)}
    else {&htmlPrint($string)}
}


######################################################################
#
#  Routines to handle Tags, Entities, etc.
#
######################################################################

#
#  &htmlTag  - look up and do an HTML tag
#
#  Get the next character
#  If it is "!" do the comments
#  Otherwise if it is a space or newline or nothing, print a "<"
#  Otherwise (a real tag)
#    Put back the character
#    Find the end of the tag
#    Split the tag at equal-signs or spaces or new lines
#    Get the name of the tag and put it in upper case
#    If the tag is defined, do what it says, otherwise ignore it
#
sub htmlTag
{
  local ($empty,$end) = &htmlFindNext(".");    ###LINE795
  local ($name,@tags,%tag);

  if ($end eq "!") {&htmlComment}
  elsif ($end eq " " || $end eq "\n" || $end eq "")
  {
    &htmlOutput($htmlLtString.$end);
  } else {
    $htmlBuffer = $end.$htmlBuffer;
    ($name,$end) = &htmlFindNext(">");
    @tags = split("([ \n]*=[ \n]*|[ \n]+)",$name);
    $name = shift(@tags); $name =~ tr/a-z/A-Z/;
    if (defined($htmlTag{$name})) {&htmlDoString($htmlTag{$name})}
  }
}

#
#  &htmlParseTags  - get an array of tags and their values
#
#  While there are more items in the tag list
#    If the item is a name not an equal sign or a space
#      Translate the name to upper case
#      If the next item is an equal sign
#        Remove it and parse the item's value
#      Otherwise set the item's value to be empty
#    
sub htmlParseTags
{
  local ($id);

  while ($id = shift(@tags))
  {
    if ($id !~ m/( *= *| +)/)
    {
      $id =~ tr/a-z/A-Z/;
      if (@tags[0] =~ m/=/) {shift(@tags); &htmlParseValue} ###LINE830
        else {$tag{$id} = ""}
    }
  }
}

#
#  &htmlParseValue  - get the value for an item of the form ID=VALUE
#                     (takes quotes into account)
#
#  Get the next item and use that as the value
#  If the first character is a quote
#    As long as the last character is not a quote
#      If there are no more tags, add an end quote explicitly
#      Add the next item to the value (the value may have been split at
#        spaces, for example)
#    Remove the quotation marks
#  Set the item to its value
#
sub htmlParseValue
{
  local ($value) = shift(@tags);

  if (substr($value,0,1) eq '"')
  {
    while (substr($value,-1,1) ne '"' || length($value) eq 1)
    {
      if ($#tags < 0) {@tags = ('"')}
      $value .= shift(@tags);
    }
    $value = substr($value,1,length($value)-2);
  }
  $tag{$id} = $value;
}

sub htmlGetTag
{
  local ($name,$value) = @_;
  $value = $tag{$name} if (defined($tag{$name}));
  return ($value);
}

#
#  &htmlComment  - handle a comment tag
#
#  Get the next two characters
#  If they are two dashes (i.e, a long comment "<!--")
#    Look for the end comment ("-->")
#  Otherwise
#    Put back the two characters
#    Find the end comment (">")
#  If we have a comment handler, call it on the comment data
#
sub htmlComment
{
  local ($com,$end) = &htmlFindNext("..");
  if ($end eq "--") {($com,$end) = &htmlFindNext("-->")} else
  {
    $htmlBuffer = $end.$htmlBuffer;
    ($com,$end) = &htmlFindNext(">");
  }
  if (defined($htmlComment)) {eval $htmlComment."(\$com)"}
}

#
#  &htmlEntity  - handle an HTML entity name
#
#  Find the end of the name (a space, semi-colon or end-of-line)
#  If the name is blank, output an ampersand
#  Otherwise
#    If the first character is a number sign, do a number entity
#    Otherwise if the entity is defined, do it
#    Otherwise output the entity name as it appeared in the file
#
sub htmlEntity
{
  local ($name,$end) = &htmlFindNext("( +|\;|\$)");

  if ($name eq "") {&htmlOutput($htmlAmpString.$end)} else
  {
    if (substr($name,0,1) eq "\#") {&htmlNumberEntity}
    elsif (defined($htmlEntity{$name})) {&htmlDoString($htmlEntity{$name})}
    else {&htmlOutput($htmlAmpString.$name.$end)}
  }
}

#
#  &htmlNumberEntity  - Handle &#nnn; entities
#
#  Remove the initial number sign
#  If the "nnn" is less than 160, print that ASCII character
#  Otherwise do the entity whose name is given in the htmlNumberEntity array
#
sub htmlNumberEntity
{
  substr($name,0,1) = "";
  if ($name < 160) {&htmlPrint(sprintf("%c",$name))}
  else {&htmlDoString($htmlEntity{@htmlNumberEntity[$name-160]})} ###LINE927
}


######################################################################
#
#  File I/O and Initialization routines
#
######################################################################


#
#  &htmlFindFormat  - locate a .tag file in the path
#
#  If the name is an absolute one
#    If the file is readable, return it
#  Otherwise
#    For each directory in the $htmlFormatPath string
#      If the file is there, return its name
#  Otherwise return nothing
#
sub htmlFindFormat
{
  local ($path);
  local ($name) = @_;

  if (substr($name,0,1) eq "/")
  {
    if (-r "$name.tag") {return "$name.tag"}
  } else {
    foreach $path (split(":",$htmlFormatPath))
      {if (-r "$path/$name.tag") {return "$path/$name.tag"}}
  }
  return "";
}

#
#  &htmlRequire  - load a required .tag file
#
#  Find the format file
#  If it exists, load it, otherwise print a warning
#
sub htmlRequire
{
  local ($file) = &htmlFindFormat("@_");
  if ($file ne "") {require $file}
    else {warn "Can't locate required format file '@_'"}
}

#
#  &htmlInitialize  - load the header files and set up variables
#
#  Get the .tag file for the current format, if any
#  Get the name of the current format in upper case
#  If there is an environment variable for this format, use it
#    Otherwise look in the home directory for a dot file
#  If a customization file exists for this format, load it
#
sub htmlInitialize
{
  local ($name);
  $name = &htmlFindFormat($htmlCommandName);
  if ($name ne "") {require $name}

  $name = $htmlCommandName;
  $name =~ tr/a-z/A-Z/;
  if (defined($ENV{$name})) {$name = $ENV{$name}}
    else {$name = "$HOME/.$htmlCommandName";}       ###LINE994
  if ($name ne "" && (-r $name)) {require $name}
}

#
#  &htmlOpenFiles  - open the input and output files
#
#  If no input file was specified, read from stdin
#  If no output file was specified
#    If the input is stdin, use stdout
#    Otherwise, use the input file but replace the extension
#  If the input file is not stdin
#    Try to open the input file, and error if not successful
#  If the output file is not stdout
#    Try to open the output file, and error if not successful
#
sub htmlOpenFiles
{
  if ($htmlInFile eq "") {$htmlInFile = "-"}
  if ($htmlOutFile eq "")
  {
    if ($htmlInFile eq "-") {$htmlOutFile = "-"} else
    {
      $htmlOutFile = $htmlInFile;
      $htmlOutFile =~ s#(.*/|^)(.*)\..*#\2$htmlExtension#;  ###LINE1018
    }
  }
  if ($htmlInFile ne "-")
  {
    if (!open(STDIN,$htmlInFile))
       {&cliError("Can't open '$htmlInFile' for reading")}
  }
  if ($htmlOutFile ne "-")
  {
    if (!open(STDOUT,">".$htmlOutFile))
      {&cliError("Can't open '$htmlOutFile' for writing")}
  }
}


######################################################################
#
#  Command Line Argument Processing Routines
#
######################################################################

#
#  &cliReadArgs  - handle command line arguments
#
#  While there are more arguments to process
#    If the next argument is a dash followed by some flag
#      Get the flag name
#      If the flag is defined, do its associated routine
#      Otherwise warn that no such flag is defined
#    Otherwise
#      If the input file is not specified, this is it
#      Otherwise if the output file is not set, this is it
#      Otherwise there are too many command line arguments
#
sub cliReadArgs
{
  local ($arg);

  while ($#ARGV >= 0)
  {
    $arg = shift(@ARGV);
    if (substr($arg,0,1) eq "-" && length($arg) > 1)
    {
      $arg = substr($arg,1);
      if (defined($cliArg{$arg})) {eval $cliArg{$arg}}
      else {&cliError("Undefined option '-$arg'")}
    } else {
      if ($htmlInFile eq "") {$htmlInFile = $arg}
      elsif ($htmlOutFile eq "") {$htmlOutFile = $arg}
      else {&cliError("Too many file names specified on command line")}
    }
  }
}

#
#  &cliError   - print an error and exit
#
sub cliError {print STDERR $htmlCommandName,":  @_\n"; exit 1;}

#
#  The array below defines the valid command-line arguments.  The value
#  of each item in the associative array is the function to call when
#  that flag is found in the command line.
#
#  The .tag files can define additional flags if desired.
#

$cliArg{"f"} = '&cliFlagF';

#
#  &cliFlagF  - implements the "-f format" command-line option
#
#  Load the required format file
#
sub cliFlagF {&htmlRequire(shift(@ARGV))}

#
#  &cliFlagNoInitStr  - Disables printing of the initial and final strings
#
#  This sets the variable $htmlPrintInitFinStr, which is checked in 
#  &htmlMain before the initial and final strings are printed to the 
#  output files.
#
$cliArg{"noinitstring"} = '&cliFlagNoInitStr';

sub cliFlagNoInitStr {$htmlPrintInitFinStr = 0}



#
#  This variable holds the name of the executing command
#
$htmlCommandName = substr($0,rindex($0,'/')+1);

#
#  The input and output file names
#
$htmlInFile = "";
$htmlOutFile = "";

#
#  Get the format-file search path (if specified)
#
if (defined($ENV{"HTML2FORMAT"})) {$htmlFormatPath = $ENV{"HTML2FORMAT"}}

#
#  Initialize everything and load the formats
#  Parse the command line
#  Open the input and output files
#  Process the input file

&htmlInitialize;
&cliReadArgs;
&htmlOpenFiles;
&htmlMain;
