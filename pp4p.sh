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
# * interactive mode (prompt each step to proceed and size)
#   ...even prompt per-exif data

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
# resize to 50%
#convert -geometry 50% $TMP.jpg ${OUT}.jpg
# smartly resize (but shrink only) so longest edge is 1000 pixels
# from discussion and doco...
# https://www.imagemagick.org/discourse-server/viewtopic.php?t=13175
# http://www.imagemagick.org/Usage/resize/#resize
convert "$MIDFILE" -resize "${size}x${size}>" "${OUT}.jpg"

# apply watermark
# * convert (resize and watermark (-composite)

# http://www.imagemagick.org/Usage/annotating/#watermarking
# ...this is applied after resize, since it'll keep watermark more consistently appropriate
# ...multiple options to explore
#   * super obvious / obstruction
#   * not obstructing, but nonetheless easily visible
#   * not easily visible (v. small but distinct, or even steganographic methods)

rm -f "$TMP.jpg"*

ls -roth "$IN" "$OUT"*
