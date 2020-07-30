# Prepare Pic For Posting

Many digital pics have metadata which can leak personal information
(most notably GPS, camera and date/time)

This script prepares your picture for social media through the following steps:

* fix rotation according to exif data
* discard ALL exif data
* resize to a "suitable for screen" resolution (1000 max edge)
* watermark (not yet implemented)



# Usage

pp4p.sh {image.jpg}

creates image_export.jpg 
