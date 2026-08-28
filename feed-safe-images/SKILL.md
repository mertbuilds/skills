---
name: feed-safe-images
description: "Pad photos onto a white canvas at the exact ratio X, Instagram, Threads, or LinkedIn show in the feed, so the whole photo is visible before anyone taps. Use when the user wants to post photos to social media, asks why their image got cropped in the timeline, says 'make this feed safe', 'add white borders for X', 'prep these for instagram', or attaches 2-4 photos for one post."
user-invocable: true
---

# Feed-safe images

Social feeds crop photos to a fixed ratio in the timeline. Only the full-screen view shows the whole frame, and most people never tap. A 16:9 photo in a two-image X post loses about 60% of its area in the preview. The fix is to put the photo on a solid canvas at the ratio the feed will show, so the crop hits the padding instead of the photo.

This skill ships `scripts/pad.sh`, an ffmpeg one-liner wrapped with the right canvas per platform layout.

## Ratios

| Layout | Platform and case | Canvas per image | Ratio |
| --- | --- | --- | --- |
| `x1` | X, single image | 2400 x 1350 | 16:9 |
| `x2` | X, two images side by side | 2100 x 2400 | 7:8 |
| `x3big` | X, three images, the large left one | 2100 x 2400 | 7:8 |
| `x3small` | X, three images, each of the two stacked right | 2100 x 1200 | 4:7 |
| `x4` | X, four images, 2x2 grid | 2400 x 1200 | 2:1 |
| `ig` | Instagram feed post or carousel slide | 2160 x 2700 | 4:5 |
| `threads` | Threads post or carousel slide | 2160 x 2700 | 4:5 |
| `li` | LinkedIn, portrait (most feed space) | 2160 x 2700 | 4:5 |
| `li-wide` | LinkedIn, landscape | 2400 x 1256 | 1.91:1 |
| `square` | any platform, 1:1 | 2160 x 2160 | 1:1 |

Canvases are 2x to 3x the platform's display size so they survive recompression. The photo is fit to 95.3% of the canvas on its constraining axis and centered. That margin was measured from a photographer's Instagram grid that reads well at thumbnail size; override with `--fit`.

Live-tested: `x1`, `x2`, `ig`. The rest come from platform docs and third-party size guides current as of 2026 and can drift; if a preview still crops, check the platform's current layout and adjust the table.

## Usage

```bash
scripts/pad.sh <layout> [-o DIR] [--fit 0.953] [--bg white] [-q 2] <photo>...
```

Examples:

```bash
# two-photo X post
scripts/pad.sh x2 IMG_001.jpg IMG_002.jpg

# instagram carousel, custom output folder, off-white canvas
scripts/pad.sh ig -o ./ig-out --bg '#fafafa' *.jpg

# three-photo X post: first photo is the big one
scripts/pad.sh x3big IMG_001.jpg
scripts/pad.sh x3small IMG_002.jpg IMG_003.jpg
```

Output is `<out>/<name>-<layout>.jpg`, JPEG quality 2 (near lossless). Requires `ffmpeg`.

## How to apply it

1. Ask how many photos go in the post and which platform. Pick the layout from the table. For X, the count decides the layout; for Instagram, Threads, and LinkedIn, one layout covers single posts and carousels.
2. Run `pad.sh` on the originals, never on already-resized exports.
3. Show the user one padded result before uploading. Read the file back and check: photo centered, canvas color solid, no crop.
4. Upload the padded files in post order. Keep the originals; the padded versions are only for the feed.

## Notes

- Mixed ratios in one multi-image post get cropped unpredictably. Pad every image to the same layout.
- Portrait sources on a landscape canvas (or the reverse) are fit by height instead of width; the script handles both.
- Dark mode: a white canvas shows as a white card on dark timelines. That is the intended look. Use `--bg black` if the account's feed is dark.
- Screenshots and graphics with text are fine too, but consider `--fit 0.9` so text does not sit against the canvas edge.
