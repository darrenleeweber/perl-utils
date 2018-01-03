#! /usr/bin/csh

#set local parameters
set dataset=""
set newdataset=""
set new=""
set oldbit=""
set newbit=""

#echo usage, if no arguments given
if ($#argv == 0) then
  echo " "
  echo "File Renaming Utility: ren -data <dataset> -old <oldbit> -new <newbit>"
  echo " "
  echo "For example: ren -data c0012 -old c0012 -new c0012a"
  echo "             will copy c0012* into c0012a*"
  echo " "
  exit 1
endif

#collect arguments
while ($#argv != 0)
  switch ($1)
      case "-data":
        shift
        set dataset=$1
        shift
       breaksw
      case "-old":
        shift
        set oldbit=$1
        shift
       breaksw
      case "-new":
        shift
        set newbit=$1
        shift
       breaksw
      default:
        echo "Unknown option '$1'"
        exit 1
       breaksw
    endsw
end
       
if (("$dataset" != "") && ("$newbit" != "") && ("$oldbit" != "")) then
  foreach f ( $dataset* )
    set new=`echo $f | sed s/$oldbit/$newbit/p`
    set newdataset="$newdataset $new"
    cp $f $new
  end
else
  echo " "
  echo "Please supply all arguments as such:"
  echo " "
  echo "File Renaming Utility: ren -data <dataset> -old <oldbit> -new <newbit>"
  echo " "
  echo "For example: ren -data c0012 -old c0012 -new c0012a"
  echo " "
endif

foreach f ( $dataset* )
  ls -l $f
end
foreach f ( $newdataset* )
  ls -l $f
end

