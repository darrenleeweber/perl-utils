$path = '.';
$osname = "";
$osname = $^O;

if( $osname =~ /Win/ ){
    # were on a DOS file system
    unless( $path =~ /\\$/ ){
        print STDERR ";;;An ending backslash was added to $path\n";
        $path .= "\\";
    }
} elsif( $osname =~ /Mac/ ){
    # were on a mac file system, no idea what to do!
} else {
    # guess were on a unix style file system
    unless( $path =~ /\/$/ ){
        print STDERR ";;;An ending forwardslash was added to $path\n";
        $path .= "/";
    }
}
