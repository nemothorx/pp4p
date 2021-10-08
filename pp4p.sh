#!/bin/bash

# pp4p = Prepare Pic For Posting

### Config defaults Local personalisations should go in ~/.pp4p.conf
size=1000       # image will be sized down so longest edge matches this. 


# configuration file for personalisation. 
# Create this file from scratch by copying the Config block above. 
[ -e ~/.pp4p.conf ] && source ~/.pp4p.conf


### TODO 
# add a "final thing" function (default to nothing)
# add switches for
# * interactive mode (prompt for settings and whether to proceed at each step)
#   ...even prompt per-exif data / complete exif data edit

if [ "$1" == "-i" ] ; then
    cat ~/.pp4p.conf
    exit
fi

IN=$1
TMP=__$RANDOM
OUT=${IN%.*}_export

suffix=${IN##*.}

case $suffix in
    jpg|JPG|jpeg|JPEG)
        # * exiftran (rotate based on exif tag)
        exiftran -a "$IN" -o "$TMP.jpg"

        # * exiftool (clear exif)
        exiftool -ALL= "$TMP.jpg"
        # note: creates an out.jpg_original file

        MIDFILE="${TMP}.jpg"
        ;;
    *)
        MIDFILE=$IN
        ;;
esac

### RESIZE
#
case $size in
    *%)     # $size detected as a percentage
        convert -geometry $size $MIDFILE ${OUT}.jpg
        ;;
    *)      # assume $size is a number, therefore...
# smartly resize (but shrink only) so longest edge is $size pixels
# from discussion and doco...
# https://www.imagemagick.org/discourse-server/viewtopic.php?t=13175
# http://www.imagemagick.org/Usage/resize/#resize
        convert "$MIDFILE" -resize "${size}x${size}>" "${OUT}.jpg"
        ;;
esac

### WATERMARK
# * convert (resize and watermark (-composite)

# http://www.imagemagick.org/Usage/annotating/#watermarking
# ...this is applied after resize, since it'll keep watermark more consistently appropriate
# ...multiple options to explore
#   * super obvious / obstruction
#   * not obstructing, but nonetheless easily visible
#   * not easily visible (v. small but distinct, or even steganographic methods)

rm -f "$TMP.jpg"*

touch -r $IN "${OUT}"*
ls -roth "$IN" "$OUT"*
