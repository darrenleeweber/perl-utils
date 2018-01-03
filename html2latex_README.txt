HTML2LATEX Documentation

Description

The Perl 5 script html2latex converts an HTML file (which may contain WebEQ
applets) into a LaTeX2e file.  Any WebEQ applet tags that contain WebTeX
commands will be replaced with the equivalent LaTeX commands. 

html2latex can also put images from the HTML file into the LaTeX file if you
have an image conversion program such as ImageMagick's convert. 
---------------------------------------------------------------

Usage

UNIX: 
html2latex [options] [infile] [outfile] 

Windows/DOS: 
html2lat [options] [infile] [outfile]
This uses the batch file html2lat.bat. 

The HTML input file infile and the LaTeX output file outfile are dealt with in
the following way: 

infile is the name of the HTML file to parse (or "-" for  standard input)  

If infile is missing, it defaults to "-".  

outfile is the name of the file to write (or "-" for standard out).  

If outfile is missing, it defaults to the input file name with  its extension
replaced by ".tex" (or possibly some other string  specified in the .tag
file), or to "-" if infile is "-". 

[options] include one or more of 

-images  
Process images into PostScript form 

-noimages  
Don't process images (the default) 

-ps  
Same as -images 

-nops  
Same as -noimages 

-home dirname 
Specifies the directory where the image files reside.  (The default is the
current directory.) 

-texcomments  
Reads in special comments which allow  the addition of LaTeX commands.  There
are two things that are done when this option is used: 
Extra LaTeX commands may be added by placing them in an HTML comment that
looks like this: 
<!--\TeX ...your LaTeX commands here...-->
A block of HTML commands which you do not want to be placed in the LaTeX
output file can be removed by surrounding them with the pair of comments 
<!--SUSPENDinTeX-->
... HTML code here will be ignored ...
<!--RESUMEinTeX-->

-teximages  
If the ALT parameter of images contains LaTeX code,  the image is replaced
with the LaTeX  (The other images are still processed if you  use -images.)
The first four characters of the ALT parameter should be \TeX followed by a
space.  The remaining characters in the parameter will be placed verbatim in
the output LaTeX file. An example is 
<IMG SRC="array.gif" ALT="\TeX $\begin{array}{cc}a&b\\c&d\end{array}$"&gt;
This option also automatically sets the -texcomments flag. 

-noinitstring 
if you will be including the LaTeX output file  in a larger document, you can
use -noinitstring  to supress the initial and final lines  (for example,
\begin{document} ) 

-f formatfile 
Specifies an additional .tag file to load.  This allows the user to expand
html2latex to convert HTML tags that are not currently recognized. 

Environment Variables

The following environment variables control the behavior of html2latex: 

HTML2FORMAT 
Gives the location of the .tag files. (Default is the directory containing
html2latex.) 

HTML2LATEX 
Points to a user-customized .tag file that will be processed after
html2latex.tag.  This allows users to modify the rules for converting HTML
tags to LaTeX. 

HTML2TEXT_PSDIR 
Points to the name of the directory where the .eps files will be stored.
(Default is the current directory.) 

Examples

To change the HTML file input.html to the LaTeX2e file output.tex, use the
command 
        html2latex input.html output.tex

If input.html contains images that you would like inserted in the output, add
the -images flag: 
        html2latex -images input.html output.tex
(This converts the GIF and JPEG images into PostScript files that are called
by LaTeX when it processes output.tex.) 

The LaTeX2e file output.tex should be converted to DVI with the command 
latex2e output. 

Image Conversion

html2latex uses a program you specify to convert any images linked by the HTML
page into the EPS format which may by included in LaTeX files.  One program
that does this is "convert", part of the ImageMagick package.  Whatever
program you use, you will need to give the command format in the file
html2latex-local.tag.  Replace the existing string assigned to the variable
$htmlConvert with the command you will use, leaving the strings "%in" and
"%out" where the command expects the names of the input and output files,
respectively. 

Files

README 
html2latex 
html2latex.tag 
html2latex.tex 
webtex2latex.tag 
html2latex-local.tag 
html2lat.bat 

Installation

Download html2latex from the Geometry Center html2latex page.  If you are
working on a UNIX system, unpack html2latex with the command corresponding to
the file you've downloaded: 
        gunzip < GChtml2latex.tar.gz | tar xvf -
        uncompress < GChtml2latex.tar.Z | tar xvf -
The directory GChtml2latex will be created containing the files listed above. 

On a Windows system, use WinZip or a similar program.

You will need to customize your copy by changing the variables in the file
html2latex-local.tag to reflect the position of the directory in your system. 

NOTE:  The first line of the file html2latex must be changed to reflect the
exact path of perl on your system. 

Programs Used by html2latex

Perl 5 is required to run html2latex.  Perl 4 will also work.  On Windows
machines, Perl for Win32 has been tested. 
To work with pages that have images, you can download the ImageMagick
utilities; in particular, convert is the one that is used by default in
html2latex.  You may use a different image conversion program by specifying
the conversion command in html2latex-local.tag. 

Known Bugs

It is likely that the output file created by html2latex will cause LaTeX
errors when you try to run latex2e. Some of the more common problems that
cause this are listed here: 

Complicated HTML tables and WebTeX arrays may not be converted correctly. In
particular, nested arrays are likely to need adjustment once they are
converted to LaTeX. 

There may be many other instances where you need to tweak the LaTeX output to
make it acceptable for the LaTeX compiler.  Sometimes html2latex will put a
line break (preceded by a percent sign) in the middle of a LaTeX command, if
there is no obvious place to break the line.  If too many of these line breaks
occur, you may reduce their likelihood by increasing the value of the variable
$htmlWidth in the file html2latex-local.tag. 

Frames and background images are not understood. 

This program does NOT work across the network.  The images must be on the
system you are using to run html2latex. 

It would be nice to convert a WebTeX source file directly to LaTeX. Currently,
a WebTeX source file must be run through the WebEQ Wizard to create the WebEQ
applets before it can be converted to LaTeX. 

At this time, it is not known whether there are any image conversion programs
which will work with html2latex on Windows machines. 
---------------------------------------------------------------

Credits

The Geometry Center's original version of html2latex was written by Davide
Cervone.  This version was developed by Jeffrey Schaefer. 

Jeffrey Schaefer <schaefer@geom.umn.edu> Last modified: Tue May 5 19:05:16
1998 
