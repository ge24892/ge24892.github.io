#!/usr/bin/env bash
# Regenerate the site's images from profile.jpg:
#
#   static/img/avatar.webp          square profile picture on the home page (60px)
#   static/img/favicon-32x32.png    browser tab
#   static/img/favicon-16x16.png    browser tab
#   static/img/apple-touch-icon.png iOS home screen
#
# Usage:  ./scripts/make-images.sh
#
# profile.jpg is 831x831, bright daylight, subject centred. A mild crop keeps the
# head and shoulders, in colour. If profile.jpg is replaced, adjust
# `face_crop` (WIDTHxHEIGHT+X+Y in source pixels) so the face is centred — you can
# check the framing by drawing a rectangle on the source:
#
#   magick profile.jpg -resize 1000x1000! -stroke lime -fill none \
#     -draw "rectangle 277,200 770,700" /tmp/check.png

set -euo pipefail
cd "$(dirname "$0")/.."

src="profile.jpg"
[ -f "$src" ] || { echo "error: $src not found"; exit 1; }

# head and shoulders, centred on the face (580 px square at +125+75)
face_crop="580x580+125+75"

# colour is the current style; set toning="-colorspace Gray" for black & white
toning=""

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# avatar: already well exposed, so only tone + sharpen
magick "$src" -crop "$face_crop" +repage $toning -resize 320x320 \
  -modulate 102,102 -unsharp 0x0.75+0.6+0.02 -quality 88 \
  static/img/avatar.webp

# icons: a touch more contrast so the shape survives at 16 px
magick "$src" -crop "$face_crop" +repage $toning -resize 180x180 \
  -modulate 104,104 -brightness-contrast 0x4 -unsharp 0x0.8+0.7+0.02 \
  "$tmp/icon-180.png"

magick "$tmp/icon-180.png" -resize 32x32 -unsharp 0x0.8+0.8+0.02 static/img/favicon-32x32.png
magick "$tmp/icon-180.png" -resize 16x16 -unsharp 0x0.8+0.8+0.02 static/img/favicon-16x16.png
cp "$tmp/icon-180.png" static/img/apple-touch-icon.png

identify static/img/avatar.webp static/img/favicon-32x32.png \
         static/img/favicon-16x16.png static/img/apple-touch-icon.png
