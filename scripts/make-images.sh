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
# The source is a dark night shot, so the crop is taken around the face and the
# exposure is lifted — more for the favicons, which would otherwise be a dark
# blob at 16 px. If profile.jpg is replaced with a different picture, adjust
# `face_crop` (WIDTHxHEIGHT+X+Y in source pixels) so the face is centred; the
# offsets can be checked by drawing a rectangle on the source:
#
#   magick profile.jpg -resize 1000x1000! -stroke lime -fill none \
#     -draw "rectangle 270,200 770,700" /tmp/check.png

set -euo pipefail
cd "$(dirname "$0")/.."

src="profile.jpg"
[ -f "$src" ] || { echo "error: $src not found"; exit 1; }

# head and a little shoulder, centred on the face (1122 px square at +606+449)
face_crop="1122x1122+606+449"

# black & white by default; set to toning="" to keep the original colour
# (extra contrast is applied below, since a grey night shot looks flat)
toning="-colorspace Gray"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# avatar: black & white, gentle lift, webp for the web
magick "$src" -crop "$face_crop" +repage $toning -resize 320x320 \
  -modulate 108,100 -brightness-contrast 0x6 -unsharp 0x0.75+0.6+0.02 -quality 88 \
  static/img/avatar.webp

# icons: stronger lift so the shape survives at 16 px
magick "$src" -crop "$face_crop" +repage $toning -resize 180x180 \
  -modulate 116,100 -brightness-contrast 4x10 -unsharp 0x0.8+0.7+0.02 \
  "$tmp/icon-180.png"

magick "$tmp/icon-180.png" -resize 32x32 -unsharp 0x0.8+0.8+0.02 static/img/favicon-32x32.png
magick "$tmp/icon-180.png" -resize 16x16 -unsharp 0x0.8+0.8+0.02 static/img/favicon-16x16.png
cp "$tmp/icon-180.png" static/img/apple-touch-icon.png

identify static/img/avatar.webp static/img/favicon-32x32.png \
         static/img/favicon-16x16.png static/img/apple-touch-icon.png
