#! /usr/bin/perl

$scriptpath = "/d/MyDocuments/programming/perl/";
$path = "/d/data_emse/ptsdpet/scd14hz/";
$area = "/d/data_emse/ptsdpet/scd14hz/point_p420.area";
$cond = "dat";
$comp = "p420";
$file = "$comp";
$exp = "oac";
$con = "ouc";

while(<@ARGV>){
    if(/-force/){ shift; $::force = "yes"; }
    if(/-comp/) { shift; $::comp = shift; }
    if(/-exp/)  { shift; $::exp = shift; }
    if(/-con/)  { shift; $::con = shift; }
    if(/-file/) { shift; $::files = shift; }
    if(/-spss/) { shift; $::spss = "yes"; }
    if(/-h/)    { &HELP; }
}

foreach $f (`ls $path`){
  
  unless($f =~ /$cond/){ next; }
  chop($f);
  
  $txt = $f;
  ($out = $f) =~ s/.$cond/_$comp.points/;
  
  # Check the last modification time of the output file
  @::stat = stat("$path$out");
  $::modtime = $::stat[9];
  $::currenttime = $^T;
  $::timesincemod = $::currenttime - $::modtime;
  
  unless($::force){
    # Allow 6 hours before automatic update of peak values
    if ($::timesincemod <= 21600) {
      print STDERR ";;;\tFiles recently processed, skipping. Use -force option to over-ride.\n";
      next;
    }
  }
  
  if( $f =~ /"$exp"/ ){
    print STDERR "\n$f  $txt attended common\n";
    #system("perl \"${scriptpath}row2col.pl\" -c 124 -f \"${path}$f\" > \"${path}$txt\"");
    #system("perl \"${scriptpath}rowXcol.pl\" -f \"${path}$txt\"");
    system("perl \"${scriptpath}region_points_avg.pl\" -epoch -200 1500 -sample 2.5 -area \"${area}\" -file \"${path}$txt\" -out \"${path}$out\"");
  } elsif( $f =~ /"$con"/ ){
    print STDERR "\n$f  $txt unattended common\n";
    #system("perl \"${scriptpath}row2col.pl\" -c 124 -f \"${path}$f\" > \"${path}$txt\"");
    #system("perl \"${scriptpath}rowXcol.pl\" -f \"${path}$txt\"");
    system("perl \"${scriptpath}region_points_avg.pl\" -epoch -200 1500 -sample 2.5 -area \"${area}\" -file \"${path}$txt\" -out \"${path}$out\"");
  }
}


foreach $c ($exp, $con){

  @attrib = ("amp","lat");

  $script = join("",$scriptpath, "region_points_collate.pl");
  
  foreach $a (@attrib){
    
    $outfile = join("", "all_", $file, "_", $c, "_", $a, ".txt");
    $command = "$script -files $file -path $path -cond $c -attrib $a -output $outfile -notime -addcond";
    system("perl $command");
  }
}
