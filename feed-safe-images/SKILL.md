---
name: feed-safe-images
description: "Pad photos onto a white canvas at the exact ratio social-media feeds use, so the whole photo is visible on X, Instagram, Threads, or LinkedIn before anyone taps. Use when the user wants to post photos to social media, asks why their image got cropped in the timeline, says 'make this feed safe', 'add white borders for X', 'prep these for instagram', or attaches 2-4 photos for one post."
user-invocable: true
---

# Feed-safe images

Social feeds crop photos to a fixed ratio in the timeline. Only the full-screen view shows the whole frame, and most people never tap. The fix is to put the photo on a solid canvas at the ratio the feed will show, so the crop hits the padding instead of the photo.

This skill ships `scripts/pad.sh`, an ffmpeg one-liner wrapped with the right canvas per platform layout.

## Ratios

| Layout | Platform and case | Canvas per image | Ratio |
| --- | --- | --- | --- |
| `x1` | X, single image | 2400 x 1350 | 16:9 |
| `xc` | X, every slide of a 2-4 image carousel | 2400 x 1920 | 5:4 |
| `x2` `x3big` `x3small` `x4` | X, legacy grid layouts. Obsolete, see note below | | |
| `ig` | Instagram feed post or carousel slide | 2160 x 2700 | 4:5 |
| `threads` | Threads post or carousel slide | 2160 x 2700 | 4:5 |
| `li` | LinkedIn, portrait (most feed space) | 2160 x 2700 | 4:5 |
| `li-wide` | LinkedIn, landscape | 2400 x 1256 | 1.91:1 |
| `square` | any platform, 1:1 | 2160 x 2160 | 1:1 |

Canvases are 2x to 3x the platform's display size so they survive recompression. The photo is fit to 95.3% of the canvas on its constraining axis and centered. That margin was measured from a photographer's Instagram grid that reads well at thumbnail size; override with `--fit`.

**X multi-image posts are a carousel now, not a grid.** Since 2026 (X Lite Android April, wider rollout by June, x.com web by late August) a post with 2-4 images shows as a horizontal swipe carousel. Each slide renders at its own full aspect ratio with no crop, so the old grid pads (7:8, 4:7, 2:1) are wrong: they show as squat white-barred slides. The carousel slot itself is 5:4 with `object-fit: cover` (measured on x.com 2026-08-29: 479 x 383 at every viewport width), so anything wider than 5:4 is cropped (16:9 loses about 30% of its width) while portrait down to 7:8 passes through. Pad every slide with `xc` (5:4). The `x2` / `x3big` / `x3small` / `x4` layouts stay in the script for anyone still seeing the grid, but do not reach for them by default.

Live-tested: `x1` (single), `xc` slot measurement (16:9 slides confirmed cropped in a live carousel), `ig`. The rest come from platform docs and third-party size guides current as of 2026 and can drift; third-party size guides still described the X grid months after it was gone, so trust a live post over a guide. If a preview still crops, check the platform's current layout and adjust the table.

## Usage

```bash
scripts/pad.sh <layout> [-o DIR] [--fit 0.953] [--bg white] [-q 2] <photo>...
```

Examples:

```bash
# two- to four-photo X post: same layout for every slide
scripts/pad.sh xc IMG_001.jpg IMG_002.jpg IMG_003.jpg

# instagram carousel, custom output folder, off-white canvas
scripts/pad.sh ig -o ./ig-out --bg '#fafafa' *.jpg
```

Output is `<out>/<name>-<layout>.jpg`, JPEG quality 2 (near lossless). Requires `ffmpeg`.

## How to apply it

1. Ask how many photos go in the post and which platform. Pick the layout from the table. One layout covers single posts and multi-image posts on every platform; for X that is `x1` for a single image and `xc` for every slide of a 2-4 image post.
2. Run `pad.sh` on the originals, never on already-resized exports.
3. Show the user one padded result before uploading. Read the file back and check: photo centered, canvas color solid, no crop.
4. Upload the padded files in post order. Keep the originals; the padded versions are only for the feed.

## Notes

- Mixed ratios in one multi-image post get cropped unpredictably. Pad every image to the same layout.
- Portrait sources on a landscape canvas (or the reverse) are fit by height instead of width; the script handles both.
- Dark mode: a white canvas shows as a white card on dark timelines. That is the intended look. Use `--bg black` if the account's feed is dark.
- Screenshots and graphics with text are fine too, but consider `--fit 0.9` so text does not sit against the canvas edge.
