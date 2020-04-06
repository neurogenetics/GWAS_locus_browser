## GWAS Locus Browser Locus Zoom Scripts
#- **Author** - Frank Grenn
#- **Date Started** - June 2019
#- **Quick Description:** script to convert locus zoom pdfs to pngs

#!/bin/bash

module load ImageMagick

for fullfilename in "$PATH1/locuszoom/LocusZoomPdfs"/*; do
	echo "$fullfilename"
	filename=$(basename -- "$fullfilename")
	filenamenoext="${filename%.*}"
	
	echo "$filenamenoext"
	
	snp="${filenamenoext:7}"
	echo "$snp"
	
	magick convert -density 300 -depth 8 -quality 85 "${fullfilename}[0]" "$PATH1/locuszoom/LocusZoomPngs/${snp}.png"
done
