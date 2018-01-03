#! /usr/bin/perl

$nnumber = 15;
$wd = `pwd`; chop($wd);

while(<@ARGV>){
  if(/-wd/){ shift; $wd = shift; }
  if(/-nn/){ shift; $nnumber = shift; }
  if(/-h/) { &HELP; }
}

foreach $f (`ls ${wd}/*3dd.dat`){

  ($s = `basename $f`) =~ s/_3dd.dat//; chop($s);

  # Get electrode co-ordinates from 3DSPACE export file
  open(EFILE,"$f") || die "\nCan't open $f\n\n";
  EFILE: while(<EFILE>){
    @dat = split;
    $dat_x{$dat[0]} = $dat[2];
    $dat_y{$dat[0]} = $dat[3];
    $dat_z{$dat[0]} = $dat[4];
    if(/^\s+Ref/){ last EFILE; }
  }
  close(EFILE);

  # Estimate electrode distances and sort for nearest neighbours
  foreach $e (sort {$a <=> $b} keys %dat_x){
    if($e =~ /^\d+/){
      printf "%4s %5s: ",$s,$e;
      &NN;			# estimate electrode distances

      # print first $nnumber nearest neighbours
      @order = split(/\s+/,$order); $n = 0;
      until ($n == $nnumber){
	@ddat = split(/,/,$order[$n]);
	printf "%4d%10.4f,",$ddat[0],$ddat[1];
	$n++;
      }
      print "\n";
    }
  }
}

sub NN {

  # calculate distance from electrode $e to electrode $ec
  foreach $ec (sort {$a <=> $b} keys %dat_x){
    if($ec =~ /^\d+/){
      $xd = $dat_x{$ec} - $dat_x{$e};
      $yd = $dat_y{$ec} - $dat_y{$e};
      $zd = $dat_z{$ec} - $dat_z{$e};
      $nn{$ec} = sqrt ( ($xd * $xd) + ($yd * $yd) + ($zd * $zd) );

    }
  }

  # sort all $ec electrodes according to their distance from electrode $e
  # and store electrode numbers in $order

  $order = "";

  foreach $d (sort {$nn{$a} <=> $nn{$b}} keys %nn){
    unless ($d == $e){
      $order .= "$d,$nn{$d} ";
    }
  }
}

sub HELP {
  print "\a\nNN_ELEC\n\n",
  "Creates nearest neighbour files for all *3dd.dat files in current directory.\n\n";
  exit;
}
# some debugging stuff

#    printf "%15s%10.4f%10.4f%10.4f\n",$dat[0],$dat_x{$dat[0]},$dat_y{$dat[0]},$dat_z{$dat[0]};
#      printf "subj  e1 vs   e2      xdif      ydif      zdif      dist\n";
#      printf "%4s%4s vs %4s%10.4f%10.4f%10.4f%10.4f\n",$s,$e,$ec,$xd,$yd,$zd,$nn{$ec};
#      printf "%4s%10.4f%15s\n",$d,$nn{$d};
