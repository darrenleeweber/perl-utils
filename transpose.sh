#! /usr/bin/bash

for FILE in `ls *.txt`; do {
    NFILE=`echo $FILE | sed s/.txt/.dat/g`;
    if ! [ -e $NFILE ]; 
    then
	echo $NFILE;
	matrix_ascii_transpose.pl -f $FILE > $NFILE;
    fi;
} done


