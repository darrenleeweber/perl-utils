#! /usr/local/bin/tcsh

#if (! `ls *.sub` ) then
#    echo ""
#    echo "Please check file names, no *.sub found."
#    echo ""
#    exit
#endif

foreach f (`ls *.sub`)
  set d=`echo $f | sed s/_..sub//p`
  mkdir $d
  cd $d
  cpio -ivdum -I ../$f
  uncompress *.Z
  cd ..
end

chmod -R g+rw .

set dir=`pwd | sed s/.floyd//p`
rsh floyd "chgrp -R MRI $dir"

