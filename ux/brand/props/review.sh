#!/bin/bash
# review.sh <cutout.png> <out.png>: the cutout whole on slate and paper, plus its four edges at 3x on slate
f=$1; o=$2; t=$(mktemp -d)
read W H < <(magick identify -format "%w %h" "$f")
for bg in 25292d e9e3d8; do magick -size $((W+40))x$((H+40)) xc:"#$bg" "$f" -gravity center -composite -resize 330x330 $t/w-$bg.png; done
magick -size $((W+40))x$((H+40)) xc:'#25292d' "$f" -gravity center -composite $t/s.png
cw=110; ch=110; X=$(((W+40)/2)); Y=$(((H+40)/2))
magick $t/s.png -crop ${cw}x${ch}+$((X-cw/2))+$((20-20)) +repage -filter point -resize 300% $t/e1.png
magick $t/s.png -crop ${cw}x${ch}+$((W+40-cw))+$((Y-ch/2)) +repage -filter point -resize 300% $t/e2.png
magick $t/s.png -crop ${cw}x${ch}+$((X-cw/2))+$((H+40-ch)) +repage -filter point -resize 300% $t/e3.png
magick $t/s.png -crop ${cw}x${ch}+0+$((Y-ch/2)) +repage -filter point -resize 300% $t/e4.png
magick $t/e1.png $t/e2.png $t/e3.png $t/e4.png +append -resize 1320x $t/edges.png
magick $t/w-25292d.png $t/w-e9e3d8.png +append $t/whole.png
magick $t/whole.png $t/edges.png -gravity center -background '#888' -append "$o"
rm -rf $t
