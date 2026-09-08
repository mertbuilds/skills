#!/usr/bin/env bash
# pad.sh - pad photos onto a solid canvas at the ratio a social feed actually shows,
# so the full frame is visible in the timeline before anyone taps.
#
# Usage:
#   pad.sh <layout> [options] <photo>...
#
# Layouts (canvas per image):
#   x1        X single image            2400x1920  5:4
#   x2        X two images, side by side 2100x2400  7:8 each
#   x3big     X three images, left big   2100x2400  7:8
#   x3small   X three images, right pair 2100x1200  4:7 each
#   x4        X four images, 2x2 grid    2400x1200  2:1 each
#   ig        Instagram feed / carousel  2160x2880  3:4
#   igblack   Instagram feed / carousel, black canvas, rounded photo corners  2160x2880  3:4
#   film      Instagram feed, film-scan frame   1512x2016  3:4  (full-bleed photo, black border, rounded inner corners)
#   threads   Threads feed / carousel    2160x2700  4:5
#   li        LinkedIn portrait          2160x2700  4:5
#   li-wide   LinkedIn landscape         2400x1256  1.91:1
#   square    any platform, 1:1          2160x2160  1:1
#
# Options:
#   -o DIR       output directory (default ./out)
#   --fit F      photo occupies F of the canvas on its constraining axis (default 0.953; x1, xc, ig 0.95)
#   --bg COLOR   canvas color, any ffmpeg color name or hex (default white; igblack defaults to black)
#   --radius N   round the photo corners by N canvas px (default 0; igblack defaults to 91)
#   -q N         JPEG quality 2..31, lower is better (default 2)
#
# Requires ffmpeg.
set -euo pipefail

layout=${1:-}; shift || true
[ -n "$layout" ] || { sed -n '2,27p' "$0"; exit 1; }

case $layout in
  x1)      W=2400; H=1920; deffit=0.95 ;;  # X single image; 5:4 so a 3:2 or 4:3 photo is width-limited like the carousel (16:9 left a 3:2 photo at ~76% width with fat side margins); 95% = 2.5% side margins, live-tested 2026-09-04
  xc)      W=2400; H=1920; deffit=0.95 ;;  # X carousel slide (2-4 images), 5:4 slot, object-fit cover (measured 2026-08-29); 95% to match x1 since 2026-09-04
  x2)      W=2100; H=2400 ;;  # legacy X grid, obsolete since X moved to carousel (2026)
  x3big)   W=2100; H=2400 ;;  # legacy X grid, obsolete
  x3small) W=2100; H=1200 ;;  # legacy X grid, obsolete
  x4)      W=2400; H=1200 ;;  # legacy X grid, obsolete
  ig)      W=2160; H=2880; deffit=0.95 ;;  # Instagram feed frame is 3:4; a 4:5 canvas gets ~6% cropped per side (live-tested 2026-08-29); 95% = 2.5% side margins since 2026-09-07; 92% read as too-thick margins next to a reference post with ~2.4% sides
  igblack) W=2160; H=2880; deffit=0.95; defbg=black; defradius=91 ;;  # `ig` on black with rounded photo corners (2026-09-08): the uncropped alternative to `film` for horizontal photos; r=91 is film's r64/1512 scaled to 2160
  film)    W=1512; H=2016 ;;  # Instagram-only film-scan frame; photo cover-cropped to 3:4 then a black border mask overlaid; not X-safe (X slot is 5:4)
  threads|li) W=2160; H=2700 ;;
  li-wide) W=2400; H=1256 ;;
  square)  W=2160; H=2160 ;;
  *) echo "unknown layout: $layout" >&2; exit 1 ;;
esac

out=./out; fit=${deffit:-0.953}; bg=${defbg:-white}; radius=${defradius:-0}; q=2
files=()
while [ $# -gt 0 ]; do
  case $1 in
    -o) out=$2; shift 2 ;;
    --fit) fit=$2; shift 2 ;;
    --bg) bg=$2; shift 2 ;;
    --radius) radius=$2; shift 2 ;;
    -q) q=$2; shift 2 ;;
    *) files+=("$1"); shift ;;
  esac
done
[ ${#files[@]} -gt 0 ] || { echo "no input files" >&2; exit 1; }
command -v ffmpeg >/dev/null || { echo "ffmpeg not found" >&2; exit 1; }

mkdir -p "$out"
fw=$(awk -v w=$W -v f=$fit 'BEGIN{printf "%d", w*f}')
fh=$(awk -v h=$H -v f=$fit 'BEGIN{printf "%d", h*f}')
# keep even dimensions for yuv420p safety
fw=$((fw - fw % 2)); fh=$((fh - fh % 2))

for f in "${files[@]}"; do
  base=$(basename "$f"); name=${base%.*}
  dest="$out/$name-$layout.jpg"
  if [ "$layout" = film ]; then
    mask="$(cd "$(dirname "$0")" && pwd)/film-frame-${W}x${H}.png"
    [ -f "$mask" ] || { echo "film frame mask missing: $mask (run scripts/make-film-frame.py)" >&2; exit 1; }
    ffmpeg -y -loglevel error -i "$f" -i "$mask" \
      -filter_complex "[0:v]scale=w=${W}:h=${H}:force_original_aspect_ratio=increase:flags=lanczos,crop=${W}:${H},format=rgba[img];[img][1:v]overlay=0:0,format=yuvj420p,setsar=1" \
      -frames:v 1 -q:v "$q" "$dest"
  elif [ "$radius" -gt 0 ]; then
    # rounded photo corners: alpha mask via geq, then composite onto the canvas color
    R=$radius
    c="lt(X,$R)*lt(Y,$R)*gt(hypot(X-$R,Y-$R),$R)+gt(X,W-$R)*lt(Y,$R)*gt(hypot(X-(W-$R),Y-$R),$R)+lt(X,$R)*gt(Y,H-$R)*gt(hypot(X-$R,Y-(H-$R)),$R)+gt(X,W-$R)*gt(Y,H-$R)*gt(hypot(X-(W-$R),Y-(H-$R)),$R)"
    ffmpeg -y -loglevel error -i "$f" -f lavfi -i "color=${bg}:s=${W}x${H}" \
      -filter_complex "[0:v]scale=w=${fw}:h=${fh}:force_original_aspect_ratio=decrease:flags=lanczos,format=rgba,geq=r='r(X,Y)':g='g(X,Y)':b='b(X,Y)':a='255*(1-($c))'[img];[1:v][img]overlay=(W-w)/2:(H-h)/2:format=auto,format=yuvj444p,setsar=1" \
      -frames:v 1 -q:v "$q" "$dest"
  else
    ffmpeg -y -loglevel error -i "$f" \
      -vf "scale=w=${fw}:h=${fh}:force_original_aspect_ratio=decrease:flags=lanczos,pad=${W}:${H}:(ow-iw)/2:(oh-ih)/2:color=${bg},setsar=1" \
      -q:v "$q" "$dest"
  fi
  echo "$dest"
done
