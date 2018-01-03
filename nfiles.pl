#! /usr/bin/perl

$size = 3;

#while(<@ARGV>){
#  if(/-cpio/){ $size = 2; }
#}

while(<>){
  unless( (/^total/) || (m#\./$#) ){
    unless(m#/$#){ 
	$f++; @f_info = split; $f_size += $f_info[$size];
    } else { $d++; }
  }
}

unless ($f_size) { $f_size = "??"; }
unless ($d) { $d = 0; }
write;

# print $f_size,$f,$d;

format =

============================================================
@>>>>>>>>> bytes in @>>>> Files
$f_size, $f
                    @>>>> Directories
$d
============================================================
.
