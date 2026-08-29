#!/usr/bin/env bash
# pad.sh - pad photos onto a solid canvas at the ratio a social feed actually shows,
# so the full frame is visible in the timeline before anyone taps.
#
# Usage:
#   pad.sh <layout> [options] <photo>...
#
# Layouts (canvas per image):
#   x1        X single image            2400x1350  16:9
#   x2        X two images, side by side 2100x2400  7:8 each
#   x3big     X three images, left big   2100x2400  7:8
#   x3small   X three images, right pair 2100x1200  4:7 each
#   x4        X four images, 2x2 grid    2400x1200  2:1 each
#   ig        Instagram feed / carousel  2160x2700  4:5
#   threads   Threads feed / carousel    2160x2700  4:5
#   li        LinkedIn portrait          2160x2700  4:5
#   li-wide   LinkedIn landscape         2400x1256  1.91:1
#   square    any platform, 1:1          2160x2160  1:1
#
# Options:
#   -o DIR       output directory (default ./out)
#   --fit F      photo occupies F of the canvas on its constraining axis (default 0.953)
#   --bg COLOR   canvas color, any ffmpeg color name or hex (default white)
#   -q N         JPEG quality 2..31, lower is better (default 2)
#
# Requires ffmpeg.
set -euo pipefail

layout=${1:-}; shift || true
[ -n "$layout" ] || { sed -n '2,25p' "$0"; exit 1; }

case $layout in
  x1)      W=2400; H=1350 ;;  # X single image and every slide of a 2-4 image carousel
  x2)      W=2100; H=2400 ;;  # legacy X grid, obsolete since X moved to carousel (2026)
  x3big)   W=2100; H=2400 ;;  # legacy X grid, obsolete
  x3small) W=2100; H=1200 ;;  # legacy X grid, obsolete
  x4)      W=2400; H=1200 ;;  # legacy X grid, obsolete
  ig|threads|li) W=2160; H=2700 ;;
  li-wide) W=2400; H=1256 ;;
  square)  W=2160; H=2160 ;;
  *) echo "unknown layout: $layout" >&2; exit 1 ;;
esac

out=./out; fit=0.953; bg=white; q=2
files=()
while [ $# -gt 0 ]; do
  case $1 in
    -o) out=$2; shift 2 ;;
    --fit) fit=$2; shift 2 ;;
    --bg) bg=$2; shift 2 ;;
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
  ffmpeg -y -loglevel error -i "$f" \
    -vf "scale=w=${fw}:h=${fh}:force_original_aspect_ratio=decrease:flags=lanczos,pad=${W}:${H}:(ow-iw)/2:(oh-ih)/2:color=${bg},setsar=1" \
    -q:v "$q" "$dest"
  echo "$dest"
done
