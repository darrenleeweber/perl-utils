#! /usr/local/bin/perl

$dir = `pwd`;
system "pushd $dir";

print "This utility will create an average of the electrode\n",
      "and reference data points within each of the ???_3dd.dat\n",
      "files in the 3dd_mean subdirectory for controls and patients.\n\n";

foreach $gp (c, p){
  if(-s "$gp.dat"){ system "rm $gp.dat";}
  open(DD_OUT, ">> $gp.dat") || die "Sorry can't open DD_OUT\n";
  $files = 0;
  @files = split(/\s+/, `ls ${gp}??_3dd.dat`);
  foreach $f (@files){
    $files++;
    open(DD,"$f") || die "Sorry cannot open DD, $f\n\n";
    GETDATA: while(<DD>){
      @data = split;
      $k = $data[0];
      if($files eq 1){ $keys .= "$k "; $n{$k} = "$data[1]"; }
      $x{$k} .= "$data[2] ";
      $y{$k} .= "$data[3] ";
      $z{$k} .= "$data[4] ";
      if($k eq "Ref"){ last GETDATA; }
    }
    close(DD);
  }
  @keys = split(/\s+/, $keys);
  foreach $k (@keys){
    @x = split(/\s+/, $x{$k});
    foreach $x (@x){ $sum += $x; } $avg_x = $sum / $files; $sum = 0;
    @y = split(/\s+/, $y{$k});
    foreach $y (@y){ $sum += $y; } $avg_y = $sum / $files; $sum = 0;
    @z = split(/\s+/, $z{$k});
    foreach $z (@z){ $sum += $z; } $avg_z = $sum / $files; $sum = 0;

    printf DD_OUT "%10s\t%s\t%10.6f\t%10.6f\t%10.6f\n",$k,$n{$k},$avg_x,$avg_y,$avg_z;

    $x{$k} = "";  $y{$k} = "";  $z{$k} = "";  $n{$k} = "";  $keys = "";
  }
}


