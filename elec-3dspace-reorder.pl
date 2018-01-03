#! /usr/bin/perl


while(<@ARGV>){
  if(/-h/){ &HELP; }
}


#####################################################
# Declarations

@miss = ("LEFT", "VEOGR", "HEOG", "NA1");

@landmarks = ("Nasion", "Left", "Right", "Centroid", "Ref");

$hsp_n = 400;


#####################################################
# Input from STDIN

while(<>){

  @data = split(/\s+/, "   $_");

  if($data[1] =~ /Centroid/i) {
    $dat{$data[1]} = "  $_";
    $hsp = $hsp_n;
    next;
  }

  if($data[1] =~ /Ref/i) {
    $dat{$data[1]} = "  $_";
    next;
  }

  if($hsp < $hsp_n){
    $dat{$data[1]} = "  $_";
  } else {
    $dat{$hsp} = "  $hsp  $_";
    $hsp++;
  }
}


#####################################################
# Output to STDOUT

@d = split(/\s+/, $dat{"Nasion"});
printf "%s%10s\t%d\t%8.6f\t%8.6f\t%8.6f\n",$d[0],$d[1],$d[2],$d[3],$d[4],$d[5];
@d = split(/\s+/, $dat{"Left"});
printf "%s%10s\t%d\t%8.6f\t%8.6f\t%8.6f\n",$d[0],$d[1],$d[2],$d[3],$d[4],$d[5];
@d = split(/\s+/, $dat{"Right"});
printf "%s%10s\t%d\t%8.6f\t%8.6f\t%8.6f\n",$d[0],$d[1],$d[2],$d[3],$d[4],$d[5];

foreach $k ( sort {$a<=>$b} keys (%dat) ){

  $pr = "yes";

  # Skip various points defined above in @miss and @landmarks
  foreach $m (@miss, @landmarks) {
    if ($k =~ /$m/i) { $pr = "no"; }
  }

  # otherwise, print ordered list of points
  if($pr eq "yes"){

    if($k < $hsp_n){

      #Output normal electrode positions
      @d = split(/\s+/, $dat{$k});
      printf "%s%10s\t%d\t%8.6f\t%8.6f\t%8.6f\n",$d[0],$d[1],$d[2],$d[3],$d[4],$d[5];

    } elsif($k == $hsp_n){

      #Output centroid and ref points before hsp points
      @d = split(/\s+/, $dat{"Centroid"});
      printf "%s%10s\t%d\t%8.6f\t%8.6f\t%8.6f\n",$d[0],$d[1],$d[2],$d[3],$d[4],$d[5];
      @d = split(/\s+/, $dat{"Ref"});
      printf "%s%10s\t%d\t%8.6f\t%8.6f\t%8.6f\n",$d[0],$d[1],$d[2],$d[3],$d[4],$d[5];
      @d = split(/\s+/, $dat{$k});
      $d[1] = "";
      printf "%s%10s\t%d\t%8.6f\t%8.6f\t%8.6f\n",$d[0],$d[1],$d[2],$d[3],$d[4],$d[5];

    } else {

      #Output hsp points, set hsp number ""
      @d = split(/\s+/, $dat{$k});
      $d[1] = "";
      printf "%s%10s\t%d\t%8.6f\t%8.6f\t%8.6f\n",$d[0],$d[1],$d[2],$d[3],$d[4],$d[5];

    }
  }
}


sub HELP {
  print "\n\nelec-3dspace-reorder.pl\n\n",
  
        "This script reorders a Neuroscan 3Dspace 3dd export\n",
        "file into numerical order and creates ASCII output\n",
        "capable of being imported back into 3d space.\n\n",
  
        "Input is STDIN and output is STDOUT\n\n";
  exit;
}
