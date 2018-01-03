###########################################################################
#
#  html2latex.tag
#
#  This is a configuration file for html2text that implements
#  html2latex, which translates HTML to LaTeX.
#
#  The format of this file is perl code.  See the html2text file for
#  more details on its contents.
#
#  If the environment variable HTML2LATEX is defined, it should point
#  to a cusomization file that extends or modifies these definitions.
#
###########################################################################
#
#  Update History:
#
#  who     when		what
#  -----  --------     ------------------------------------------
#  dpvc	   10/95	Wrote it.
#

#
# Load the variables that are local to the system we are running on.
#
&htmlRequire("html2latex-local");

# This variable allows us to use Blackboard Bold and Fraktur characters,
# along with the symbols \ltimes and \rtimes.
# It may be necessary to make this an optional package installed only
# when such symbols are used.
#
$htmlIncludeAMSSYMB = "\\usepackage{amssymb}";

#
#  The initialization string for when there are images to be
#  processed.

$htmlInitialStringPS=
"\\documentstyle[12pt,epsf]{article}
$htmlIncludeAMSSYMB
\\begin{document}
\\input $h2llocation/html2latex

";

#
#  The initialization string for when there are no images
#
$htmlInitialStringNoPS =
"\\documentstyle[12pt]{article}
$htmlIncludeAMSSYMB
\\begin{document}
\\input $h2llocation/html2latex

";

#
#  The termination string for the output file
#
$htmlFinalString = "\n\n\\end{document}\n";

#
#  Load the common TeX information
#

######################################################################
### The following used to be the file    html2tex-common.tag   #######
######################################################################
###########################################################################
#
#  html2tex-common.tag
#
#  The format of this file is perl code.  See the html2latex file for
#  more details on its contents.
#
###########################################################################
#
#  Update History:
#
#  who     when		what
#  -----  --------     ------------------------------------------
#  dpvc	   10/95	Wrote it.
#  schaefer 3/98        Added the file to html2latex.tag


#
#  The default extension for output files.
#
$htmlExtension = ".tex";

#
#  How to output "<" and "&".
#
$htmlLtString = '{\htmlLt}';
$htmlAmpString = '\&';

#
#  Allow line breaks at "\" and "{", and put a "%" at the and of a
#  line when it breaks at one of these places.
#
$htmlBreakChars = '\\\{';
$htmlBreakNL = "%";


#
#  Some characters need to be treated specially.  We output the TeX
#  codes for typesetting these.
#
$htmlChar{"\$"} = '\$';    ###LINE110
$htmlChar{"\#"} = '\#';
$htmlChar{"{"} = '\{';
$htmlChar{"}"} = '\}';
$htmlChar{"%"} = '\%';
$htmlChar{"_"} = '\_';
$htmlChar{">"} = '{\htmlGt}';
$htmlChar{"|"} = '{\htmlBar}';
$htmlChar{"~"} = '{\htmlTilde}';
$htmlChar{"^"} = '{\htmlHat}';
$htmlChar{"\\"} = '{\htmlBackslash}';
$htmlChar{'"'} = '&htmlQuote';

#
#  The entities need to be converted to TeX format.
#  Some do not have TeX equivalents, and are left blank.
#
$htmlEntity{"amp"} = '\&';
$htmlEntity{"lt"} = '{\htmlLt}';
$htmlEntity{"gt"} = '{\htmlGt}';
$htmlEntity{"nbsp"} = '~';

$htmlEntity{"iexcl"} = '{\char"3C}';
$htmlEntity{"cent"} = '{\cents}';
$htmlEntity{"pound"} = '{\it\$}';
$htmlEntity{"curren"} = '';
$htmlEntity{"yen"} = '';
$htmlEntity{"brvbar"} = '\htmlBar';
$htmlEntity{"brkbar"} = '\htmlBar';
$htmlEntity{"sect"} = '\S';
$htmlEntity{"uml"} = '{\char"7F}';
$htmlEntity{"copy"} = '{\copyright}';
$htmlEntity{"ordf"} = '';
$htmlEntity{"laquo"} = '$\ll$';
$htmlEntity{"not"} = '$-$';
$htmlEntity{"shy"} = '\-';
$htmlEntity{"reg"} = '';
$htmlEntity{"hibar"} = '{\char"16}';
$htmlEntity{"deg"} = '$^\circ$';
$htmlEntity{"plusmn"} = '$\pm$';
$htmlEntity{"sup2"} = '$^2$';
$htmlEntity{"sup3"} = '$^3$';
$htmlEntity{"acute"} = '{\char"13}';
$htmlEntity{"micro"} = '$\mu$';
$htmlEntity{"para"} = '\P';
$htmlEntity{"middot"} = '$\cdot$';
$htmlEntity{"cedil"} = '{\char"18}';
$htmlEntity{"sup1"} = '$^1$';
$htmlEntity{"ordm"} = '';
$htmlEntity{"raquo"} = '$\gg$';
$htmlEntity{"frac14"} = '$\htmlFrac 1/4$';
$htmlEntity{"frac12"} = '$\htmlFrac 1/2$';
$htmlEntity{"frac34"} = '$\htmlFrac 3/4$';
$htmlEntity{"iquest"} = '{\char"3E}';
$htmlEntity{"Agrave"} = '\`A';
$htmlEntity{"Aacute"} = "\\'A";
$htmlEntity{"Acirc"} = '\^A';
$htmlEntity{"Atilde"} = '\~A';
$htmlEntity{"Auml"} = '\"A';
$htmlEntity{"Aring"} = '{\AA}';
$htmlEntity{"AElig"} = '{\AE}';
$htmlEntity{"Ccedil"} = '\c C';
$htmlEntity{"Egrave"} = '\`E';
$htmlEntity{"Eacute"} = "\\'E";
$htmlEntity{"Ecirc"} = '\^E';
$htmlEntity{"Euml"} = '\"E';
$htmlEntity{"Igrave"} = '\`I';
$htmlEntity{"Iacute"} = "\\'I";
$htmlEntity{"Icurc"} = '\^I';
$htmlEntity{"Iuml"} = '\"I';
$htmlEntity{"ETH"} = '';
$htmlEntity{"Dstrok"} = '';
$htmlEntity{"Ntilde"} = '\~N';
$htmlEntity{"Ograve"} = '\`O';
$htmlEntity{"Oacute"} = "\\'O";
$htmlEntity{"Ocirc"} = '\^O';
$htmlEntity{"Otilde"} = '\~O';
$htmlEntity{"Ouml"} = '\"O';
$htmlEntity{"times"} = '$\times$';
$htmlEntity{"Oslash"} = '{\O}';
$htmlEntity{"Ugrave"} = '\`U';
$htmlEntity{"Uacute"} = "\\'U";
$htmlEntity{"Ucirc"} = '\^U';
$htmlEntity{"Uuml"} = '\"U';
$htmlEntity{"Yacute"} = "\\'Y";
$htmlEntity{"THORN"} = '';
$htmlEntity{"szlig"} = '{\ss}';
$htmlEntity{"agrave"} = '\`a';
$htmlEntity{"aacute"} = "\\'a";
$htmlEntity{"acirc"} = '\^a';
$htmlEntity{"atilde"} = '\~a';
$htmlEntity{"auml"} = '\"a';
$htmlEntity{"aring"} = '{\aa}';
$htmlEntity{"aelig"} = '{\ae}';
$htmlEntity{"ccedil"} = '{\c c}';
$htmlEntity{"egrave"} = '\`e';
$htmlEntity{"eacute"} = "\\'e";
$htmlEntity{"ecirc"} = '\^e';
$htmlEntity{"euml"} = '\"e';
$htmlEntity{"igrave"} = '{\`\i}';
$htmlEntity{"iacute"} = "{\\'\\i}";
$htmlEntity{"icirc"} = '{\^\i}';
$htmlEntity{"iuml"} = '{\"\i}';
$htmlEntity{"eth"} = '';
$htmlEntity{"ntilde"} = '\~n';
$htmlEntity{"ograve"} = '\`o';
$htmlEntity{"oacute"} = "\\'o";
$htmlEntity{"ocirc"} = '\^o';
$htmlEntity{"otilde"} = '\~o';
$htmlEntity{"ouml"} = '\"o';
$htmlEntity{"divide"} = '$\div$';
$htmlEntity{"oslash"} = '{\o}';
$htmlEntity{"ugrave"} = '\`u';
$htmlEntity{"uacute"} = "\\'u";
$htmlEntity{"ucirc"} = '\^u';
$htmlEntity{"uuml"} = '\"u';
$htmlEntity{"yacute"} = "\\'y";
$htmlEntity{"thorn"} = '';
$htmlEntity{"yuml"} = '\"y';
$htmlEntity{"quot"} = '&htmlQuote';


#
#  Define the different character styles
#
$htmlTag{"B"} = '{\bf '; $htmlTag{"/B"} = '}';
$htmlTag{"I"} = '{\it '; $htmlTag{"/I"} = '}';
$htmlTag{"U"} = '{\sl '; $htmlTag{"/U"} = '}';
$htmlTag{"TT"} = '{\tt '; $htmlTag{"/TT"} = '}';
$htmlTag{"EM"} = '{\it '; $htmlTag{"/EM"} = '}';
$htmlTag{"STRONG"} = '{\bf '; $htmlTag{"/STRONG"} = '}';
$htmlTag{"CODE"} = '{\tt '; $htmlTag{"/CODE"} = '}';
$htmlTag{"SAMP"} = '{\tt '; $htmlTag{"/SAMP"} = '}';
$htmlTag{"CITE"} = '{\tt '; $htmlTag{"/SITE"} = '}';
$htmlTag{"KBD"} = '{\tt '; $htmlTag{"/KBD"} = '}';
$htmlTag{"VAR"} = '{\it '; $htmlTag{"/VAR"} = '}';
$htmlTag{"DFN"} = '{\rm '; $htmlTag{"/DFN"} = '}';
$htmlTag{"ADDRESS"} = "\\htmlBR{\\it "; $htmlTag{"/ADDRESS"} = "}\\htmlBR";

#
#  Use special macros for <BR> and <HR>
#
$htmlTag{"BR"} = "\\htmlBR\n";
$htmlTag{"HR"} = "\\htmlHR\n";

#
#  Handle FORMs correctly
#
$htmlTag{"INPUT"} = '&htmlInput';
$htmlTag{"SELECT"} = '&htmlSelect';
$htmlTag{"/SELECT"} = '&htmlSelectEnd';
$htmlTag{"OPTION"} = '&htmlOption';
$htmlTag{"TEXTAREA"} = '&htmlTextarea';
$htmlTag{"/TEXTAREA"} = '&htmlTextareaEnd';

#
#  Handle quotes specially:  put out the correct set depending on
#  whether this is an open or a close quote.
#  11/21/97 schaefer -- We only do this if we are not in PRE mode.
sub htmlQuote
{
    if ($htmlPreMode) {&htmlPrint(q/"/)}
    else {
	if ($htmlQuoteOpen) {&htmlPrint(q/''/)} else {&htmlPrint(q/``/)}
	$htmlQuoteOpen = !$htmlQuoteOpen;
    }
}


#
#  Process comments specially:
#  If the command begins with "\TeX" then the rest of the comment is
#  inserted into the tex output verbatim (this provides a method of
#  embedding TeX commands in the HTML file but not having them mess up
#  the look when it is viewed on the web).
#
$htmlComment = "&htmlTeXcomment";
sub htmlTeXcomment
{
  local ($comment) = @_;
  if ($comment =~ m/^\\TeX +/i) {&htmlPrint($')}
}

#  This second comment handler adds the ability to turn off the html output
#  when it is convenient to replace it with the TeX commands.
#  Turn off with <!--SUSPENDinTeX-->
#  Turn back on with <!--RESUMEinTeX-->
#  10-31-97 J. Schaefer

sub htmlTeXcommentWithSuspend
{
  local ($comment) = @_;
  if ($comment =~ m/^\\TeX +/i) {&htmlPrint($')}
  if ($comment =~ m/^SUSPENDinTeX/i) {&htmlSuspendOutput}
  if ($comment =~ m/^RESUMEinTeX/i) {&htmlRestoreOutput}
}

#
#  &htmlNewLine  - conditionally print a newline
#
#  If there is some text one the current line
#    End the current line with a "%"
#    Make sure that leading spaces are retained
#
sub htmlNewLine
{
  if ($htmlLinePar eq 0)
  {
    &htmlPrint($htmlBreakNL."\n");
    $htmlLineSpace = -1;
  }
}


######################################################################
#
#  Routines to handle FORMs
#


#
#  &htmlInputCHECK  - process a check box
#
#  Output \htmlInputCheckbox with the correct checked status.
#
sub htmlInputCHECKBOX
{
  local ($check) = "";
  $check = "checked" if (defined($tag{"CHECKED"}));
  &htmlPrint("\\htmlInputCheckbox{$check} ");
}

#
#  &htmlInputRADIO  - process a radio button
#
#  Output \htmlInputRadio with the correct checked status.
#
sub htmlInputRADIO
{
  local ($check) = "";
  $check = "checked" if (defined($tag{"CHECKED"}));
  &htmlPrint("\\htmlInputRadio{$check} ");
}

#
#  &htmlInputSUBMIT  - process a submit button
#
#  Output \htmlINputButton with the correct button name (translating
#  any entities within the button name).
#
sub htmlInputSUBMIT
{
  &htmlPrint("\\htmlInputButton{");
  &htmlOutputHTML(&htmlGetTag("VALUE","Submit"));
  &htmlPrint("}");
}

#
#  &htmlInputRESET  - process a reset button
#
#  Output \htmlINputButton with the correct button name (translating
#  any entities within the button name).
#
sub htmlInputRESET
{
  &htmlPrint("\\htmlInputButton{");
  &htmlOutputHTML(&htmlGetTag("VALUE","Reset"));
  &htmlPrint("}");
}

#
#  &htmlInputBUTTON  - process a reset button
#
#  Output \htmlInputButton with the correct button name (translating
#  any entities within the button name).
#
sub htmlInputBUTTON
{
  &htmlPrint("\\htmlInputButton{");
  &htmlOutputHTML(&htmlGetTag("VALUE",""));
  &htmlPrint("}");
}

#
#  &htmlInputTEXT  - process a single-line text entry field
#
#  Get the size and default text.
#  If the size has both a row and column value (obsolete HTML)
#    Split the size into its parts
#    Start a multi-column input area
#    Send out the text in PRE-formatted mode
#    End the text area
#  Otherwise
#    Output \htmlInputText withthe correct size and text (translating
#    any entities in the default text).
#
sub htmlInputTEXT
{
  local ($size) = &htmlGetTag("SIZE","30");
  local ($value) = &htmlGetTag("VALUE","");
  local ($rows,$cols);

  if ($size =~ m/,/)
  {
    ($cols,$rows) = split(", *",$size);
    &htmlNewLine;
    &htmlPrint("\\htmlTextarea{$cols}{$rows}%\n");
    $htmlPreMode++;
    &htmlOutputHTML($value);
    $htmlPreMode--;
    &htmlPrint("\n\\htmlEnd\n");
  } else {
    &htmlPrint("\\htmlInputText{$size}{");
    &htmlOutputHTML($value);
    &htmlPrint("}");
  }
}

#
#  &htmlInputIMAGE  - process a selectable image
#
#  If we're in Postscript mode
#    Make sure this is marked as an ISMAP item and do the PS image
#  Otherwise do a regular text image
#
sub htmlInputIMAGE
{
  if ($htmlPS)
  {
    $tag{"ISMAP"} = "";
    &htmlDoIMGps;
  } else {&htmlTextIMG}
}

#
#  &htmlTextarea  - process a multi-line text area
#
#  Parse the tags and get the ROWS and COLS items
#  Print a new line, if needed
#  Output the \htmlTextarea command with the correct size
#  Start PRE-formatted mode
#
sub htmlTextarea
{
  local ($rows,$cols);

  &htmlParseTags;
  $rows = &htmlGetTag("ROWS",1);
  $cols = &htmlGetTag("COLS",30);
  &htmlNewLine;
  &htmlPrint("\\htmlTextarea{$cols}{$rows}%\n");
  $htmlPreMode++;
}
#
#  End PRE-formatted mode
#  End the text area
#
sub htmlTextareaEnd
{
  $htmlPreMode-- if ($htmlPreMode);
  &htmlPrint("\\htmlEnd\n");
}

#
#  &htmlSelect  - process a single- or multi-line menu selection
#
#  Parse the tags and look for the SIZE item
#  Split it into rows and columns (or just columns if only one is suplied)
#  If this is a single line item
#    Suspend output until the selected <OPTION> is found
#  Otherwise
#    Start a new line if needed
#    Start a multi-line menu in PRE-formatted mode
#
sub htmlSelect
{
  local ($rows,$cols);
  local ($size);

  &htmlParseTags;
  $size = &htmlGetTag("SIZE","30,1");
  ($cols,$rows) = split(",",$size);
  if ($rows eq "") {$rows = $cols; $cols = 30}
  if ($rows == 1)
  {
    &htmlSuspendOutput;
  } else {
    &htmlNewLine;
    &htmlPrint("\\htmlSelect{$cols}{$rows}%\n");
    $htmlPreMode++;
  }
}

#
#  &htmlSelectEnd  - end a single-or multi-line menu
#
#  If this was a multi-line menu
#    End PRE_formatted mode and end the menu
#  Otherwise
#    If the output is suspended, restore it
#    Otherwise (we're in the selected <OPTION>) end the option text
#
sub htmlSelectEnd
{
  if ($htmlPreMode)
  {
    $htmlPreMode--;
    &htmlPrint("\\htmlEnd\n");
  } else {
    if ($htmlNoOutput) {&htmlRestoreOutput} else {&htmlPrint("}")}
  }
}

#
#  &htmlOption  - process a menu option
#
#  Parse the tags
#  If this is part of a multi-line menu
#    If the item is selected, output the select bullet
#    Otherwise output some blank spaces
#  Otherwise (single-line menu)
#    If the item is selected
#      Restore the output so the selected item will show up
#      Output the \htmlInputMenu macro (the menu name will follow)
#    Otherwise if the previous option was the selected on
#      Close the text string for it and suspend the output again
#
sub htmlOption
{
  &htmlParseTags;
  if ($htmlPreMode)
  {
    if (defined($tag{"SELECTED"})) {&htmlPrint("{\\htmlSelectBullet}")}
      else {&htmlPrint("  ")}
  } else {
    if (defined($tag{"SELECTED"}))
    {
      &htmlRestoreOutput;
      &htmlPrint("\\htmlInputMenu{");
    } elsif (!$htmlNoOutput) {
      &htmlPrint("}");
      &htmlSuspendOutput
    }
  }
}


######################################################################
#
#  Handle postscript conversion of images
#
######################################################################
### The following used to be the file    html2text-psIMG.tag   #######
######################################################################
###########################################################################
#
#  html2text-psIMG.tag
#
#  This is a configuration file for html2text that processes the .gif
#  files from <IMG> tags and converts them to .eps files for inclusion
#  into TeX documents.  This file is required by html2tex and
#  html2latex.
#
#  This file adds several new command line options:
#
#    -images		process images into postscript form
#    -noimages		don't process images (the default)
#    -ps		same as -images
#    -nops		same as -noimages
#    -home dirname	specifies where the image files reside
#
#
#  The environment variable HTML2TEXT_PSDIR points to the name of the
#  directory where the .eps files can be stored (defaults to ".")
#
#  The format of this file is perl code.  See the html2text file for
#  more details on its contents.
#
###########################################################################
#
#  Update History:
#
#  who     when		what
#  -----  --------     ------------------------------------------
#  dpvc	   10/95	Wrote it.
#  schaefer 3/98        Added this file to html2latex.tag


######################################################################
#
#  These are variables used in this file that you can customize
#  by editing the file html2latex-local.tag
#
#  This is where the main web tree begins
#
#  $htmlWebRoot
#
#  This is the name of the main web server
#
#  $htmlWebServer 
#
#  This is the directory where user's home directories are found
#
#  $htmlUserRoot
#
#  This is the name of the place where user's html files are stored
#
#  $htmlUserHTML
#
#  This is the directory where the document originally came from
#  (the picture files will be looked for here).  This can be specified
#  on the command line
#
#  $htmlWebHome
#
#  This is the command to convert .gif files to .eps files.  "%in"
#  will be replaced by the input file name and "%out" by the output
#  file name.
#
# $htmlScale
# $htmlConvert 

#####################################################################

#
#  This is where the converted postscript files will go.
#
$htmlTMP = $ENV{"HTML2TEXT_PSDIR"};
$htmlTMP = $ENV{"PWD"} if ($htmlTMP eq "");

#
#  These are the initialization strings for PS and non-PS modes
#
$htmlInitialStringPS = "" if (!defined($htmlInitialStringPS));
$htmlInitialStringNoPS = "" if (!defined($htmlInitialStringNoPS));


######################################################################
#
#  New command-line flags
#

#
#  Define the new command-line flags
#
$cliArg{"home"} = '$htmlWebHome = shift(@ARGV)';

$cliArg{"ps"} = "&cliFlagPS";
$cliArg{"nops"} = "&cliFlagNoPS";
$cliArg{"images"} = "&cliFlagPS";
$cliArg{"noimages"} = "&cliFlagNoPS";

$cliArg{"home"} = '$htmlWebHome = shift(@ARGV)';

#
#  For Postscript mode, set the initialization string, define the IMG
#  tag and indicate that we are in postscript mode
#
sub cliFlagPS
{
  $htmlInitialString = $htmlInitialStringPS;
  $htmlTag{"IMG"} = '&htmlIMGps';
  $htmlPS = 1;
}

#
#  For non-Postscript mode, set the initialization string, define the
#  IMG tag to be the standard routine, and mark that we are not in
#  postscript mode.
#
sub cliFlagNoPS
{
  $htmlInitialString = $htmlInitialStringNoPS;
  $htmlTag{"IMG"} = '&htmlIMG';
  $htmlPS = 0;
}

#
#  default to non-Postscript mode
#
&cliFlagNoPS;


######################################################################
#
#  The main routines
#

#
#  To process an IMG tag:
#    Check if the SRC field is specified; if so
#      Find the name of the file for the image; if it exists
#        If the ALIGN field is specified
#          Set the "where" variable to the correct character
#        Get the name of the original file and remove leading directories
#        Remove the extension and replace it with ".eps" (or add it if
#          there is no extension, or the file starts with .)
#        Add the PS directory name
#        Remove a leading ./ if any (just for looks)
#        Add the file names to the conversion command
#        Execute the conversion command
#        Call the routine to add the image to the output file
#  If there was a problem, do a plain text image
#
sub htmlIMGps {&htmlParseTags; &htmlDoIMGps}
sub htmlDoIMGps
{
  local ($name,$epsname);
  local ($command) = $htmlConvert;
  local ($where) = "b";

  if (defined($tag{"SRC"}))
  {
    if ($name = &htmlFindIMG($tag{"SRC"}))
    {
      if (defined($tag{"ALIGN"}))
      {
	$where = substr($tag{"ALIGN"},0,1);
        $where = tr/A-Z/a-z/;
	$where = "m" if ($where !~ m/[tbm]/);
      }
      $epsname = $name;
      $epsname =~ s:.*/::;
      $epsname =~ s/((.)\..*|$)/\2.eps/;
      $epsname = $htmlTMP."/".$epsname;
      $epsname =~ s:^\./::;
      $command =~ s/%in/$name/g; $command =~ s/%out/$epsname/g;
      system($command) if (! -e $epsname);
      eval $htmlEPSfile.'($where,$epsname)';
    }
  }
  &htmlTextIMG if ($name eq "");
}

#
#  Convert local image file names to their correct locations
#  Convert /~userid/ references to their correct locations
#  If the file exists, return its name, otherwise return ""
#
sub htmlFindIMG
{
  local ($file) = @_;
  $file =~ s#^($htmlWebServer/|/)#$htmlWebRoot/#o;
  $file =~ s#^$htmlWebRoot/~(.*)/#$htmlUserRoot/\1/$htmlUserHTML/#o;
  if (-e $file) {return($file)}
  if (-e "$htmlWebHome/$file") {return("$htmlWebHome/$file")}
  if (-e "$ENV{\"PWD\"}/$file") {return("$ENV{\"PWD\"}/$file")}

  if ($htmlInFile =~ m!.*/!) {
	if (-e "$&/$file") {return("$&/$file")}
  }

  return("");
}

#
#  This variable should hold the name of a routine that writes out the
#  .eps filename to the output file somehow.
#
$htmlEPSfile = "&htmlNOOP";
sub htmlNOOP {};
######################################################################
########   END of the file html2text-psIMG.tag    ####################
######################################################################


#
#  &htmlEPSfile
#
#  Output the \epsFile command with the correct placement and file
#  name.  If this is a mapped image, place a box around it.
#
$htmlEPSfile = "&htmlEPSfile";
sub htmlEPSfile
{
  local ($placement,$file) = @_;
  &htmlPrint("\\htmlBox{1pt}{") if (defined($tag{"ISMAP"}));
  &htmlPrint("\\epsFile{$placement}{$file}");
  &htmlPrint("}") if (defined($tag{"ISMAP"}));
}



#####################################################################
#Added by schaefer: 10/97

#  &htmlTeXImages
#
#  This subroutine allows us to place the TeX code in IMG tags whose 
#  images were created from TeX.  All other images are sent to the 
#  EPS subroutine (if the flag -images was used)
#  or to &htmlTextIMG.
#
#  Parse the tags.
#  If the ALT starts with \TeX,
#    Send the rest of the ALT string verbatim,
#  Otherwise
#    If we're using PostScript images, go to &htmlDoIMGps
#    Else use &htmlTextIMG
#
#
sub htmlTeXImages
{
    local ($alttag,$rest);

    &htmlParseTags;

    $alttag = &htmlGetTag("ALT",''); 
    if ($alttag =~ m/^\\TeX +/i) {
	$rest = $';
	$rest =~ s/\\gt +/>/g;
	$rest =~ s/\\lt +/</g;
	&htmlPrint($rest);
    }

    elsif ($htmlPS) {&htmlDoIMGps;}

    else {&htmlTextIMG;}



}

$cliArg{"teximages"} = '&cliTeXImages';

sub cliTeXImages
{
    $htmlTag{"IMG"} = '&htmlTeXImages';
    $htmlComment = '&htmlTeXcommentWithSuspend';
    $htmlPS = 1;
}

$cliArg{"texcomments"} = '&cliTeXComments';

sub cliTeXComments
{
    $htmlComment = '&htmlTeXcommentWithSuspend';
}

######################################################################
######## End of the file    html2tex-common.tag        ###############
######################################################################


#
#  Define the list tags
#
$htmlTag{"UL"} = "\n\n\\begin{itemize}\n";
$htmlTag{"/UL"} = "\n\\end{itemize}\n\n";
$htmlTag{"OL"} = "\n\n\\begin{enumerate}\n";
$htmlTag{"/OL"} = "\n\\end{enumerate}\n\n";
$htmlTag{"LI"} = "\n\\item ";
$htmlTag{"DL"} = '&htmlDL'; $htmlTag{"/DL"} = '&htmlDLend';
$htmlTag{"DT"} = '&htmlDT';
$htmlTag{"DD"} = '&htmlDD';

#
#  To process definition lists, we record whether a DT is currently in
#  effect.  If a DD occurs without a preceeding DT, then we use the
#  special \htmlDD macro, otherwise just use a paragraph break
#
$htmlDTopen = 0;
sub htmlDL {&htmlPrint("\n\n\\begin{description}\n"); $htmlDTopen = 0}
sub htmlDLend {&htmlPrint("\n\\end{description}\n\n")}
sub htmlDT {&htmlPrint("\n\\item "); $htmlDTopen = 1}
sub htmlDD
{
  if ($htmlDTopen) {&htmlPrint("\n\n")} else {&htmlPrint("\n\\htmlDD ")}
  $htmlDTopen = 1;
}


#
#  Define the special formatiing tags
#
$htmlTag{"BLOCKQUOTE"} = "\n\n\\begin{quote}\n";
$htmlTag{"/BLOCKQUOTE"} = "\n\\end{quote}\n\n";
$htmlTag{"PRE"} = '&htmlPRE';
$htmlTag{"/PRE"} = '&htmlPREend';

#
#  Print out the macros for PRE mode, and make sure the text between
#  them preserves its line breaks and spacing
#
sub htmlPRE {&htmlPrint("\n\n\\begin{PRE}\n"); $htmlPreMode = 1}
sub htmlPREend {$htmlPreMode = 0; &htmlPrint("\n\\end{PRE}\n\n")}


#
#  Define the heading classes
#
$htmlTag{"H1"} = "\n\n\\section*{";       $htmlTag{"/H1"} = "}\n\n";
$htmlTag{"H2"} = "\n\n\\subsection*{";    $htmlTag{"/H2"} = "}\n\n";
$htmlTag{"H3"} = "\n\n\\subsubsection*{"; $htmlTag{"/H3"} = "}\n\n";
$htmlTag{"H4"} = "\n\n\\paragraph*{";     $htmlTag{"/H4"} = "}\n\n";
$htmlTag{"H5"} = "\n\n{\\small ";         $htmlTag{"/H5"} = "}\n\n";
$htmlTag{"H6"} = "\n\n{\\scriptsize ";    $htmlTag{"/H6"} = "}\n\n";


#
# Load new tags for later versions of HTML
#
######################################################################
### The following used to be the file    newh2latex.tag        #######
######################################################################

#&htmlRequire("newh2latex");

#  This tag file for html2latex that allows the use of new tags 
#  not found in the original version.
#
#  6/25/97  schaefer  First draft of TABLE, TR, TD tags.
#  6/23/97  schaefer  Added CENTER tags.
#  3/25/98  schaefer  Added to the file html2latex.tag
#
#  It's not clear why this works, so I will comment it out for now.
#  This inserts an extra special character which
#  will allow the backslashes to be replaced correctly
#  Only when using this, single \'s are replaced with {\htmlBackslash} as
#  expected.
#
  $htmlChar{"\\\\"} = '{\jeffsBack}';



#Add a colon after the paragraph title to set it off from the text.
$htmlTag{"H4"} = "\n\n\\paragraph*{";     $htmlTag{"/H4"} = ":}\n\n";

#
$htmlTag{"CENTER"} = "\n\\begin{center}\n";
$htmlTag{"/CENTER"} = "\n\\end{center}\n\n";

# The BIG and SMALL tags will be changed to fixed sizes for now.
# Ideally, they should increase/decrease the size further when nested.
#
$htmlTag{"BIG"} = "{\\Large ";     $htmlTag{"/BIG"} = "}";
$htmlTag{"SMALL"} = "{\\footnotesize ";     $htmlTag{"/SMALL"} = "}";

# A really long subscript may cause problems, since LaTeX will not break a 
# line in the middle of a subscript (even if there are spaces).
# 
$htmlTag{"SUB"} = "\\raisebox{-.6ex}{";     $htmlTag{"/SUB"} = "}";
$htmlTag{"SUP"} = "\\raisebox{.6ex}{";     $htmlTag{"/SUP"} = "}";

# Underlining also does not work across line breaks, so instead we
# change to italics.
#
$htmlTag{"U"} = "{ \\em";     $htmlTag{"/U"} = "}";

# It is not clear yet what to do with the STRIKE tag
#   Alternatives are: Don't print anything
#                     Print with tiny letters or alternate font
#                     Use a different color (light gray)
#
#$htmlTag{"STRIKE"} = "???";     $htmlTag{"/STRIKE"} = "???";

#
#  Tags for Tables
#
$htmlTag{"TABLE"} = '&htmlTABLE';
$htmlTag{"/TABLE"} = '&htmlTABLEend';
$htmlTag{"TR"} = '&htmlTR';
$htmlTag{"TD"} = '&htmlTD';
$htmlTag{"TH"} = '&htmlTH';
# The optional /TR, /TH, and /TD tags are ignored.
$htmlTag{"CAPTION"} = '&htmlCAPTION';



# The following bugs occur in the TABLE and related tags:
#
# LaTeX is not happy about the extra line spaces that are placed
# around tables that are inside a \multicolumn{ } command.
# 
# Enclosing every single cell in braces { } causes LaTeX to think
# that those entries should be centered.  Perhaps the way around this 
# is to only use braces with \multicolumn{ } commands.

#  & htmlTABLE    
#
# RETURN if we have turned off output (with SUSPENDinTeX)
#
#  Initialize some variables that are used by this table 
#    and associated subroutines (&htmlTR, &htmlTD, etc.)
#    Any sub-tables will start their own local variables.
#  Parse attribute tags
#  If the table has a border, set border flag to '|'  ('' means no border)
#
#  Get html up to the end of this table. (Put into $u) 
#    get html up to next TABLE or /TABLE tag
#    If it's TABLE, increase depth marker
#    If it's /TABLE, decrease depth marker
#    Otherwise something is seriously wrong.
#    $u collects the html code for this table.
#    Include the depth number in the table tag
#    The temporary variable $TempU is the same as $u, 
#      with the depth of sub-tables marked.
#  Stop after the last /TABLE is reached 
#  Cut out any sub-tables in $TempU  
#      ( they're between <table2> and </table1> ) 
#      so that we can count the maximum number of columns 
#      in the rows of the main table.
#
#  Split $TempU into an array of rows
#  Count the number of columns in each row, 
#           keeping track of the maximum in $numcols
#  For each row,
#    Initialize $thisrowscols (actual TD's and TH's)
#           and $extracols (Those implied by COLSPAN)
#    Count TD's and TH's
#    Pull out the value of any COLSPAN's
#    For each value, add it to $extracols
#    If this row is the largest so far, set $numcols
#
#  Print out the first LaTeX lines of the table
#  Process the contents of the table.
#

sub htmlTABLE { 

    if ($htmlNoOutput) {return;}

    local($border);
    local($htmlTRfirst) = 1;
    local ($numcols) = 0;
    local ($colctr) = 0;	# Used in &htmlTR to keep track of columns

    local ($incaption, $endcap) = ('','');   # used in &htmlCAPTION
    local ($bottomcaption) = 0;

    &htmlParseTags;

    if (defined($tag{"BORDER"}) && &htmlGetTag("BORDER") > 0) { 
	$border ='|';}
    else {$border  = '';}


    local ($depth) = 1;
    local ($u, $TempU) = ('','');


    local ($rr,$tt);
    do {
	($rr,$tt) = &htmlFindNext("</TABLE>|<TABLE");
	if ($tt =~ m/<TABLE/i) {$depth++;}
	elsif ($tt =~ m!</TABLE!i) {$depth--;}
	else {print "No end to this table!\n";}
	
	$u = $u.$rr.$tt;


	$tt =~ s/table/table$depth/i;
	
	$TempU = $TempU.$rr.$tt;
    } until $depth == 0;   # Reached end of top table.

# Cut out any sub-tables  ( they're between <table2> and </table1> ) 
    $TempU =~ s!<table2(.|\s)*</table1>!!ig;

# Split the array into rows
    local (@rows);
    @rows = split(/<TR/i,$TempU); 

#count columns in each row.  Add extra cols. for colspan=k
    foreach $row (@rows) {
	local ($thisrowscols,$extracols) = (0,0);
	$thisrowscols = ($row =~ s/(<TD|<TH)/\1/ig);
# \d+ = # cols associated with each colspan
	@colspan = ($row =~ m/colspan\s*=\s*(\d+)/ig);  
	foreach $cs (@colspan) {
	    $extracols += $cs - 1;
	}
	$numcols = ( $numcols > $thisrowscols + $extracols) ?
	    $numcols : $thisrowscols + $extracols;
    }


    # print the first lines of the table
    &htmlPrint("\n\n\\begin{tabular}"); 
    &htmlPrint("{$border"."l$border"x$numcols ."}\n");
#    if ($border eq '|') { &htmlPrint("\n \\hline \n");} 

    &htmlOutputHTML($u);

}

#
# &htmlTABLEend  finish off a table
#
# RETURN if we have turned off output (with SUSPENDinTeX)
#
# Print a } to end the lower-right cell
# If there's a border, print the bottom line
# If the caption was saved until the last row, print it.
# Print the LaTeX code to end the table.
#

sub htmlTABLEend {
    if ($htmlNoOutput) {return;}

    &htmlPrint("}");
    if ($border eq '|') { &htmlPrint("\n\\\\ \\hline \n");}

    if ($bottomcaption) { &htmlPrintCaption; }

    &htmlPrint("\n\n\\end{tabular}\n\n");

}



#
# &htmlTR   Parse <TR> Table Row tags
#
# Set the 'first <TD>' flag to 1 
#     (we don't need a '&' before the first <TD> of the row.)
# Parse attribute tags
# Set $align corresponding to value of ALIGN
# If we are at the first <TR> tag,
#     Print a horizontal line above the table if there is a border
#     Set the 'first <TR>' flag to 0
# Otherwise, we are at some subsequent <TR>, print \\ and possibly a 
#     horizontal line.
#     Set column counter to 0
# Read the row into $uu
#     Use counters to keep track of any tables nested in this row.
# Process the contents of the row.
# Put the <TR tag found above back in the html buffer.
# If this row does not have the maximum number of columns, 
#     put in some extra &'s to make up the difference.
#

sub htmlTR { 
    local ($row, $tr, $tdcount, $align);
    local ($htmlTDfirst) = 1;

    &htmlParseTags;

# Get the alignment tag and set the $align string accordingly. 
    local ($aligntag);
    $aligntag = &htmlGetTag("ALIGN", "LEFT");

    if ($aligntag =~ /RIGHT/i) { $align = 'r'; }
    elsif ($aligntag =~ /CENTER/i) { $align = 'c'; }
    else { $align = 'l'; }


    if ($htmlTRfirst) {
	if ($border eq '|') { &htmlPrint("\n \\hline \n");} 		 
	$htmlTRfirst = 0; }

    else { &htmlPrint(" } \\\\\n"); # 2 backslashes and newline
	   if ($border eq '|') { &htmlPrint(" \\hline \n");} 
	   $colctr = 0;
       }

    local ($TRdepth) = 0;

    local ($rr,$tt) = ('','');
    local ($uu) = '';

    do {
	$uu .= $tt;
	($rr,$tt) = &htmlFindNext("<TR|<TABLE|</TABLE");
	# if we're at a table, set depth counter
	if ($tt =~ m/<TABLE/i) {$TRdepth++;}
	# if we're at a /table, decrease counter
	elsif ($tt =~ m!</TABLE!i) {$TRdepth--;}
	# if we're at a tr and depth ne 0, stop looking for 
	elsif ($tt =~ m/<TR/i) { 
	    if ($TRdepth == 0) {$TRdepth = -1;}
	}
	else {print "htmlTR: Didn't find TR, TABLE, /TABLE\n";}
	$uu .= $rr;
    } until ($TRdepth == -1);

    
    &htmlOutputHTML($uu);
    $htmlBuffer = $tt . $htmlBuffer;

    if ($colctr < $numcols) { &htmlPrint( ' } '.'& 'x($numcols-$colctr).' {');}
    

	 }

#
# &htmlTD   Parse <TD> Table Cell tags
# 
# Parse attribute tags
# Set $cellalign corresponding to value of ALIGN 
#        (horizontal alignment within the cell)
# Get the number of columns this cell spans.
# If this isn't the first cell of the row, close the previous cell
#        and print a '&'
# If the cell spans more than one column, or the cell is not left-justified,
#   print the multicol. latex command
#   The left-most cell needs a left-hand border (if there is a border.)
#   Print the alignment and the right-hand border.
# Begin the cell with a '{'
# Set flag indicating the next cell won't be the first
# Increment column counter by the no. of cols that this cell spans.
#
				 
sub htmlTD { 

# Get the alignment tag and set the $cellalign string accordingly. 
    local ($aligntag,$cellalign, $colspan) = ('','',1);

    &htmlParseTags;

    $aligntag = &htmlGetTag("ALIGN", '');
    
#    if ($align ne '') {$cellalign = $align;}
#    if ($aligntag eq '') {$cellalign = $align;}
    if ($aligntag =~ /RIGHT/i) { $cellalign = 'r'; }
    elsif ($aligntag =~ /CENTER/i) { $cellalign = 'c'; }
    elsif ($aligntag =~ /LEFT/i) { $cellalign = 'l'; }
    elsif ($align ne '') { $cellalign = $align; }
    else { $cellalign = 'l';}

    $colspan = &htmlGetTag("COLSPAN",1);

    if (!$htmlTDfirst) { 
	&htmlPrint("} & ");
    }

    if ($colspan != 1 || $cellalign ne 'l') {
	&htmlPrint("\\multicolumn{$colspan}{");
	if ($htmlTDfirst) { &htmlPrint($border); }
	&htmlPrint("$cellalign$border }");
    }

    &htmlPrint("{");
    $htmlTDfirst = 0; 
    $colctr += $colspan;
	
}

#
# &htmlTH  Parse <TH> Table Header tags.
#
# Parse attribute tags
# Set $cellalign corresponding to value of ALIGN 
#        (horizontal alignment within the cell)
# Get the number of columns this cell spans.
# If this isn't the first cell of the row, close the previous cell
#        and print a '&'
# Print the multicol. latex command
#   The left-most cell needs a left-hand border (if there is a border.)
#   Print the alignment and the right-hand border.
# Begin the cell with a '{' and LaTeX boldface command.
# Set flag indicating the next cell won't be the first
# Increment column counter by the no. of cols that this cell spans.
#

sub htmlTH { 

    local ($aligntag,$cellalign, $colspan);

    &htmlParseTags;

    $aligntag = &htmlGetTag("ALIGN", "CENTER");

    if ($aligntag =~ /RIGHT/i) { $cellalign = 'r'; }
    elsif ($aligntag =~ /LEFT/i) { $cellalign = 'l'; } 
    else { $cellalign = 'c'; }

    $colspan = &htmlGetTag("COLSPAN",1);

    if (!$htmlTDfirst) { 
	&htmlPrint("} & ");
    }

    &htmlPrint("\\multicolumn{$colspan}{");
    if ($htmlTDfirst) { &htmlPrint($border); }
    &htmlPrint("$cellalign$border }");

    &htmlPrint("{\\bf ");
    $htmlTDfirst = 0; 
    $colctr += $colspan;
	
}


# &htmlPrintCaption
#
# If there is no border and we are at the bottom of the table,
#   we need another end-of-row marker.
# Print the centering command.
# Print the caption into the file
# End the command and the line  
# The last \\ is needed only if we're at the top of the table


sub htmlPrintCaption {

    &htmlPrint(" \\\\ ") if ($bottomcaption && $border eq '');

    &htmlPrint("\\multicolumn{$numcols}{c}{\\bf ");
    &htmlOutputHTML($incaption);
    &htmlPrint(" } ");
    &htmlPrint("\\\\")  if (!$bottomcaption);
    &htmlPrint("\n");

}

# &htmlCAPTION     parse the caption tag
#
# Parse attribute tags
# Read in until /caption tag
# If the ALIGN = TOP, process the caption right away.
# (Otherwise this will wait until the /table tag.)


sub htmlCAPTION {

				# parse attribute tags
    &htmlParseTags;
    $captiontag = &htmlGetTag("ALIGN", "TOP");
    
    ($incaption, $endcap) = &htmlFindNext("</CAPTION>");

    if ($captiontag =~ /TOP/i) { &htmlPrintCaption; 
				 $bottomcaption = 0;
			     }
    else {			 $bottomcaption = 1;}

}



#  APPLET PARSER
#
#
#


$htmlTag{"APPLET"} = '&htmlAPPLET';
$htmlTag{"/APPLET"} = '&htmlAPPLETend';

$htmlTag{"PARAM"} = '&htmlPARAM';

# $htmlAppletName will contain the name of the current applet.
# This allows subsequent PARAM tags to be interpreted correctly.
#
$htmlAppletName = '';

# &htmlAPPLET
#
# Collect the tags from the applet
# read in the CODE tag; this tells exactly what applet is being used 
# If it's a webeq applet, Set the applet name flag, 
#   otherwise erase the flag and 
#   print the alt text or [APPLET]
#
sub htmlAPPLET  {

    # parse tags
    &htmlParseTags;

    # get the value of the code tag 
    $codetag = &htmlGetTag("CODE",'');
    
    # if 'webeq' is part of the applet, set WebEQ flag
    
    if ($codetag =~ /webeq/i) { $htmlAppletName = 'WEBEQ'; } 
    else { $htmlAppletName = ''; 
	   &htmlTextAPPLET;
       }

}

# &htmlTextAPPLET
#
# For unknown applets, we print the alt-text or 
# just an [APPLET] marker.
#
sub htmlTextAPPLET  {
    if (defined($tag{"ALT"})) {&htmlOutputHTML($tag{"ALT"});}
    else { &htmlOutput("[APPLET]");}
}

# &htmlAPPLETend
#
# This is called when the </APPLET> tag is found.
#
# Calls a subroutine which resets various flags to their default values.
#
sub htmlAPPLETend  { &htmlAPPLETreset; }

# &htmlAPPLETreset
#
# Resets various applet flags to their default values.
#
sub htmlAPPLETreset {
    
    $htmlAppletName = ''; 

    $WebTeXBeginChar = '$';
    $WebTeXEndChar   = '$';
    
}


# &htmlPARAM
#
# Parse the PARAM tags that occur inside applets.
# Currently, only WebEQ applets are supported.
#
# Parse the tags
# Get the NAME and VALUE tags
# If it's a WebEQ applet,
#   Check the name of the parameter:
#     STYLE: Send the value to &htmlWebEQStyle
#     EQ:    Send the value to &htmlWebEQEquation
# Other applets and parameter names are ignored, and we return
# to the calling routine.
#
sub htmlPARAM  {

    local ($nametag, $valuetag);

    # parse tags
    &htmlParseTags;

    # get the values of the tags 
    $nametag = &htmlGetTag("NAME",'');
    $valuetag = &htmlGetTag("VALUE",'');

    if ($htmlAppletName eq 'WEBEQ') {
      SWITCH: {
	  if ($nametag =~ /style/i) { &htmlWebEQStyle($valuetag); 
				      last SWITCH; }  
	  
	  if ($nametag =~ /eq/i) { &htmlWebEQEquation($valuetag); 
				   last SWITCH; }
      }
    }

}


# The LaTeX mathematical code will be placed between 
# $WebTeXBeginChar and $WebTeXEndChar
# Possible values are $ .. $  and \[ .. \]
#
$WebTeXBeginChar = '$';
$WebTeXEndChar   = '$';

# &htmlWebEQStyle
#
# Set the appropriate characters for the inline or displayed equations.
# The default will be $ ... $, unless a displayed equation is specified.
#
sub htmlWebEQStyle  {

    local($style) = @_;

    if ($style =~ /display/i) { 
	$WebTeXBeginChar = '\\[';
	$WebTeXEndChar   = '\\]';
    }
    else {
	$WebTeXBeginChar = '$';
	$WebTeXEndChar   = '$';
    }
}


# &htmlWebEQEquation
#
# Here we parse the WebTeX code and translate it to LaTeX.
# TEMPORARY:  We simply send the WebTeX code to the LaTeX file.  
#
sub htmlWebEQEquation {
    
    local ($eqtext) = @_;

    &htmlPrint($WebTeXBeginChar);

    $neweqtext = &webtexParse2Latex($eqtext);
    &htmlOutput($neweqtext);
    &htmlPrint($WebTeXEndChar);

}


#
# We replace WebTeX commands with the appropriate LaTeX commands
# by including the file webtex2latex.tag.
#

&htmlRequire("webtex2latex");

######################################################################
########   END of the file newh2latex.tag    #########################
######################################################################

1;  # make sure perl sees an OK return status
