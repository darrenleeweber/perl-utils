#! /usr/bin/perl

while(<@ARGV>){
  if(/-h/){ &HELP; exit; }
}

$n = 0; # Number of lines in the input file
$p = 0; # Number of points
$l = 0; # Number of lines (defined by any 2 points)
$t = 0; # Number of triangles (defined by any 3 line loops)

while(<>){
  $n++;
  @in = split;
  $x = $in[0];
  $y = $in[1];
  $z = $in[2];
  #$type = $in[3];

  if(/^\s?\#/){ next; }
  
  if($n == 2){ $points = $in[0];  
	       $triangles = $in[1];
	       next;
  }
  
  if( $p < $points ){
    
    $p++;
    printf "Point(%d)\t=\t{ %12.6f, %12.6f, %12.6f, 1};\n", $p, $x, $y, $z;

  } else {
    # these are lines and triangles
    
    $x++; $y++; $z++; #increase from base index of 0 to 1.

    # lines
    for( $i = 0; $i <= 2; $i++ ) {
      if($i == 0){ $a = $x; $b = $y; }
      if($i == 1){ $a = $y; $b = $z; }
      if($i == 2){ $a = $z; $b = $x; }
      &GOTLINE;
      if($gotline){
	$line[$i] = $gotline;
      } else {
	$l++; $line[$i] = $l; print "Line($l) = {$a,$b};\n";
        $Lines{$l} = "$a,$b";
      }
    }
    
    # line loop (triangle)
    $l++; print "Line Loop($l) = {$line[0],$line[1],$line[2]};\n";
    $loops++; $Loops{$loops} = "$line[0],$line[1],$line[2]";
    # surface (of triangle)
    $l++; $t = $l - 1; 
    print "Plane    Surface($l) = {$t};\n";
    print "Physical Surface(100) = {$l};\n";

    $surf++; #if($surf > 1000){exit;}
    if ($surf > $triangles){ exit; }
  }
}



###################################################################
sub GOTLINE {
  $gotline = 0;
  foreach $line (keys %Lines){
    $pts = $Lines{$line};
    if( $pts eq "$a,$b" ){
      $gotline = $line; last; # already got this line
    }
    if( $pts eq "$b,$a" ){
      $gotline = -1 * $line; last; # already got this line
    }
  }
}
