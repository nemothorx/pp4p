#!/bin/bash

# pp4p = prepare pic for posting


### TODO 
# change size default
# add a "final thing" function (default to nothing)
# add config file that can override the aboves
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
convert "$MIDFILE" -resize "1000x1000>" "${OUT}.jpg"

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
