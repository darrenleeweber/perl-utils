#! /usr/bin/perl -w

#####
# todo:
#    optimizations
#    full keyword list
#    special HTML characters
#####

use strict;
my $version     = "0.5.7";
my $script_name = "c2html.pl"; # this must match the name of the script
my $copy_years  = "&copy;2001";
my $home        = "http://www.webpak.net/~energon/";
my $company     = "Energon-Software";

# replace these colors with your prefered
my $bg_color   = '"#ffffff"';
my $text_color = '"#000000"';

my $multi = "false";
sub parse_line
{
    # replace these colors with your prefered
    my $key_color     = '"#0000cc"';
    my $string_color  = '"#cc0000"';
    my $comment_color = '"#007700"';

    my @preprocessor = ( "#define", "#include", "#if defined", "#endif", "#if !defined", "#error", "#pragma", "#ifndef", "#ifdef", "#elif defined" );
    my @keywords = ( "auto", "register", "sizeof", "volatile", "asm", "_asm", "operator", "this", "using", "namespace", "short", "int", "char", "long", "float", "double", "bool", "enum", "void", "const", "signed", "unsigned", "extern", "static", "inline", "struct", "class", "private", "protected", "public", "template", "typedef", "union", "friend", "virtual", "if", "else", "while", "do", "for", "switch", "case", "break", "continue", "default", "goto", "try", "catch", "true", "false", "NULL", "new", "delete", "return" );

    shift && chomp;
    s/</&lt;/g && s/>/&gt;/g;  # <> characters
    if((/\/\*/) || ($multi eq "true"))  # working w/ multiline comments
    {
        $multi = "true";
        if(/\/\*/) {
            $_ = "<font color=$comment_color>\n".$_;
        }
        if(/\*\//) {
            $_.="</font>";
            $multi = "false";
        }
    }
    else # not working w/ multiline comments
    {
        s/(\".+?\")/<font color=$string_color>$1<\/font>/g;      # strings
        s/('.+?')/<font color=$string_color>$1<\/font>/g;        # characters
        s/(&lt;.+?&gt;)/<font color=$string_color>$1<\/font>/g;  # standard headers

        foreach my $preproc (@preprocessor) {
            s/$preproc/<font color=$key_color>$preproc<\/font>/g;
        }
        foreach my $keyword (@keywords) {
            s/\b$keyword\b/<font color=$key_color>$keyword<\/font>/g;
        }

        # pull all font tags out of comments
        if(/\/\//) {
            s/<font color=\".*\">//g;
            s/<\/font>//g;
        }
        s/(\/\/.*)/<font color=$comment_color>$1<\/font>/g;
    }

    return;
}

sub optimize_line
{
    chomp;

    return $_."\n";
}

sub main
{
    my $html = "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n<html>\n<head>\n<meta name=\"generator\" content=\"$script_name v$version\">\n<title>";
    my $copyright = "\n<hr>Source Converted by $script_name $copy_years <a href=\"$home\">$company</a>";

    my $file = shift;
    die "Could not open $file\n" unless(open INFILE, $file);

    $html.="$file by $script_name</title>\n</head>\n\n<body bgcolor=$bg_color text=$text_color>\n\n<pre>\n";

    print "\nConverting file $file...\n";
    my $line;
    while(<INFILE>) {
        &parse_line;
        $line = &optimize_line;
        $html.=$line;
    }
    die "Could not close $ARGV[0]\n" unless(close INFILE);

    # fix file extension
    $file =~ s/\./_/g;
    my $htmlfile = $file.".html";

    $file.=".html";
    print "Writing file $htmlfile...\n";
    die "Could not create file $htmlfile\n" unless(open OUTFILE, ">$htmlfile");
    die "Could not write to $htmlfile\n" unless(print OUTFILE $html.$copyright."\n</pre>\n\n</body>\n</html>");
    die "Could not close $htmlfile\n" unless(close OUTFILE);

    print "Finished...\n"
}

die "Usage: $script_name /path/to/files_to_convert\n" unless @ARGV;
print $script_name." starting...\n";
foreach my $file(@ARGV) {
    &main($file) unless($file eq $script_name);
}
exit 0;
