#!/bin/bash

[ -z "$1" ] && echo "usage: $0 file.HEIC [resizepct (\"thumb\"=10)]" && exit 1

# [ -n "$2" ] && echo "usage: $0 file.HEIC [resizepct (\"thumb\"=10)]" && exit 2

echo "$(date) - converting $1"

outfile=${1}.jpg

if [ -n "$2" ] ; then
    case $2 in
        thumb)
            convertopts="-geometry 10%"
            outfile=${1}.thumb.jpg
            ;;
        [0-9][0-9])
            convertopts="-geometry $2%"
            outfile=${1}.resized.jpg
            ;;
        *) 
            echo "Unknown option $2"
            exit 1
            ;;
    esac
fi

convert $convertopts $1 $outfile

touch -r $1 $outfile

ls -lh $1 $outfile
