#! /usr/bin/perl

$type = 2; # triangles
$region = 1;

while(<@ARGV>){
  if(/-h/){ &HELP; exit; }
  if(/-t/){ shift; $type = shift; }
  if(/-r/){ shift; $region = shift; }
}

print "$NOD\n";

$n = 0; # Number of lines in file
$p = 0; # Number of points
$t = 0; # Number of triangles

while(<>){
  $n++;
  @in = split;
  $x = $in[0];
  $y = $in[1];
  $z = $in[2];
  #$type = $in[3];

  if(/^\s?\#/){ next; }
  
  if($n == 2){
    $points = $in[0];
    $triangles = $in[1];
    print "\$NOD\n$points\n";
    next;
  }
  
  if( $p < $points ){
    
    $p++;
    #printf "Point(%d)\t=\t{ %12.6f, %12.6f, %12.6f, 0};\n", $p, $x, $y, $z;
    printf "%d\t %12.6f %12.6f %12.6f\n", $p, $x, $y, $z;

    if($p == $points){ print "\$ENDNOD\n\$ELM\n$triangles\n"; }

  } else {
    # these are triangles
    $t++;
    printf "%d\t $type  $region  %d %d %d\n", $t, $x, $y, $z;

    if($t == $triangles){ print "\$ENDELM\n"; }
  }
  
}


############################################################
# Types:
#   1  Line (2 nodes, 1 edge). 
#   2  Triangle (3 nodes, 3 edges). 
#   3  Quadrangle (4 nodes, 4 edges). 
#   4  Tetrahedron (4 nodes, 6 edges, 4 facets). 
#   5  Hexahedron (8 nodes, 12 edges, 6 facets). 
#   6  Prism (6 nodes, 9 edges, 5 facets). 
#   7  Pyramid (5 nodes, 8 edges, 5 facets). 
#   15 Point (1 node). 

# The $region value is the number of the physical entity to which the
# element belongs.

