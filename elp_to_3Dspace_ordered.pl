#! /usr/local/bin/perl

# This script extracts x,y,z values from an elp file in numerical order
# and creates a formated output capable of being imported into
# 3d space

#####################################################
# Declarations

@miss = ("LEFT", "VEOGR", "HEOG", "NA1");

@landmarks = ("Nasion", "Left", "Right", "Centroid", "Ref");

#####################################################
# Input from STDIN

$n = 0;

while(<>){

  # Exclude first 2 lines of EMSE filetype code
  $n++;  if($n < 3){ next; }

  # Identify input data type
  if(/ecProbe/i){ $ecProbe = "y"; next; }
  if(/nsensors/i){ $nsensors = "y"; next; }
  if(/Fiducials/i){ $Fiducials = "y"; next; }
  if(/state/i) { $state = "y"; next; }
  if(/Sensor name/i){ $name = "y"; next; }
  if(/sphere origin/i){
    if($Centroid){ next; } else { $Origin = "y"; next; }
  }
  if(/origin/i){ $elec = "y"; next; }

  # Extract input data by data type
  if($ecProbe){ $ecProbe = ""; next; }
  if($nsensors){ $nsensors = ""; next; }
  if($Fiducials){
    $fn++;
    if($fn == 1){ $dat{"Nasion"} = $_; next; }
    elsif($fn == 2){ $dat{"Left"} = $_; next; }
    elsif($fn == 3){ $dat{"Right"} = $_; next; }
    else { $Fiducials = ""; next; }
  }
  if($Origin){
    $Centroid = "y";
    $dat{"Centroid"} = $_;
    $Origin = ""; next;
  }
  if($name){
    @in = split(/\s+/, "   $_");
    $elec_name = $in[2];
    $name = ""; next;
  }
  if($elec){
    $dat{$elec_name} = "%E      $_";
    $elec = ""; next;
  }

}




#####################################################
# Output to STDOUT

@d = split(/\s+/, $dat{"Nasion"});
$name = "Nasion";
$code = 110;
printf "%10s\t%d\t%8.6f\t%8.6f\t%8.6f\n",$name,$code,($d[2] * -100),($d[1] * 100),($d[3] * 100);

@d = split(/\s+/, $dat{"Left"});
$name = "Left";
$code = 108;
printf "%10s\t%d\t%8.6f\t%8.6f\t%8.6f\n",$name,$code,($d[2] * -100),($d[1] * 100),($d[3] * 100);

@d = split(/\s+/, $dat{"Right"});
$name = "Right";
$code = 114;
printf "%10s\t%d\t%8.6f\t%8.6f\t%8.6f\n",$name,$code,($d[2] * -100),($d[1] * 100),($d[3] * 100);

foreach $k ( sort {$a<=>$b} keys (%dat) ){

  $pr = "yes";

  # Skip various points defined above in @miss and @landmarks
  foreach $m (@miss, @landmarks) {
    if ($k =~ /$m/i) { $pr = "no"; }
  }

  # otherwise, print ordered list of points
  if($pr eq "yes"){

      #Output normal electrode positions

      @d = split(/\s+/, $dat{$k});
      $code = 69;
      printf "%10s\t%d\t%8.6f\t%8.6f\t%8.6f\n",$k,$code,($d[2] * -100),($d[1] * 100),($d[3] * 100);

    }
}

#Output centroid and ref points

@d = split(/\s+/, $dat{"Centroid"});
$name = "Centroid";
$code = 99;
printf "%10s\t%d\t%8.6f\t%8.6f\t%8.6f\n",$name,$code,($d[2] * -100),($d[1] * 100),($d[3] * 100);

@d = split(/\s+/, $dat{"Ref"});
$name = "Ref";
$code = 120;
printf "%10s\t%d\t%8.6f\t%8.6f\t%8.6f\n",$name,$code,($d[2] * -100),($d[1] * 100),($d[3] * 100);
