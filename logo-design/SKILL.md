---
name: logo-design
description: "Research-first logo and app icon design for a product. Use when the user says '/logo-design', 'make an icon', 'design a logo', 'app icon for X', 'favicon for X', 'new mark for X', or wants icon/logo directions for an app, site, extension or Mac app. Runs parallel research (principles, competitor icons, curated marks, YouTube lessons) across several search engines, builds mood boards, offers 10+ grounded directions, then generates and critiques the picked ones."
user-invocable: true
---

# Logo Design

Design a logo or app icon the way a professional studio would: learn the product, research the category and the craft, build mood boards, and only then offer directions. Generate images only for directions the user picked.

## Hard rules

- **No directions before research.** Directions taken straight from a product brief come out literal: a missing tile, an eraser, a phone outline, a plug, a monogram. Offer directions only after Phase 2.
- **Identify, do not explain.** A mark is "the period at the end of the sentence" (Haviv). It gets its meaning from the product over time (Rand). Do not draw the mechanism or the UI.
- **For abstract ideas, borrow a sign.** Absence, focus, permanence and trust cannot be drawn directly. Borrow a glyph that a sign system already uses for that meaning: engineering and electrical symbols, music notation, proofreading marks, map and maritime signs, typographic marks, Otl Aicher pictograms. This is Susan Kare's "undo" method.
- **Black and white first.** The idea must survive with the accent colour removed; Apple's tinted and clear modes remove it anyway. The accent gets one job.
- **Design for the smallest place first.** That is usually the 16px favicon or Chrome toolbar, not the 1024px canvas.
- **Never ship raw AI raster output.** The final mark is a hand-built SVG.

## Phase 0: Brief

1. **Read the product context.**
   - The repo: README, AGENTS.md or CLAUDE.md, brand tokens and accent colour, current logo files, landing copy.
   - The live landing page. Compare it with the repo, because main can be ahead of production.
   - Any notes about positioning.
2. **Write 4 short things.** They go into every subagent prompt.
   - **Belief:** one sentence about what the product believes, not what it does.
   - **Truths:** concrete facts about the product, especially mechanics no competitor has.
   - **Visual language:** palette, typeface, corner radius, mood.
   - **Anti-brief:** directions already rejected, plus known category clichés.
3. **List the surfaces where the mark appears, with sizes:** favicon 16/32, Chrome toolbar 16 and store 128 (96px art), Mac Dock, iOS home screen, social avatar. If the product has no app on a device, drop that surface.

## Phase 1: Research (4 parallel subagents)

Spawn all 4 in one message as background agents. Give each the full brief. Every agent uses every search engine you have (for example Exa, Parallel, context.dev, and built-in web search) and reports what each one found. Save outputs under `<tmp>/<product>-research/{principles,competitors,curation,youtube}/`.

1. **Principles.** Read `references/principles-notes.md` and `references/sources.md` first. Refresh them with anything new: Apple HIG changes, new talks, trend reports. Apply the playbook to this product. Return a concept process, an evaluation rubric, the category clichés, 5–8 case studies of abstract marks, and 3–5 insights specific to this product.
2. **Competitors.** Find 35–50 similar and adjacent products.
   - App Store icons come from the iTunes Search API: `https://itunes.apple.com/search?term=<q>&entity=software` (or `macSoftware`). Take `artworkUrl512`, swapped to `1024x1024bb`.
   - Chrome Web Store icons come from the store page. Web logos come from the favicon, apple-touch-icon, or a brand-data API.
   - Save PNGs, an `index.json` and a labelled `sheet.png`.
   - Return the metaphor and palette per product, which territories are saturated, the white space nobody uses, the 5 best marks, and **who already owns your accent colour**.
3. **Curation mood board.** Sources: Logobook, LogoArchive (BP&O), the Chermayeff & Geismar & Haviv portfolio, Logo Index, LogoLounge, macOS/iOS Icon Gallery, icon.museum.
   - Mine 40–60 marks that relate to the product's themes, translated abstractly. Add 10–15 app icons with character from minimal means, and utilitarian references (Teenage Engineering, Braun, Swiss).
   - Group them into 5–8 visual territories. Save images, an `index.json` and a `sheet.png`.
   - Also read the course previews listed in `references/sources.md`.
4. **YouTube.** Search with `yt-dlp "ytsearch20:<query>" --flat-playlist --print "%(id)s|%(title)s|%(channel)s|%(view_count)s"` across many queries. Pick the 12–18 best videos.
   - Download subtitles with `yt-dlp --skip-download --write-auto-subs --sub-langs "en.*" --sub-format vtt`. Clean them to text and read them fully.
   - If YouTube returns 429, retry with other player clients.
   - Return the distilled lessons, quotes, the top 5 videos for the user to watch, and "how a pro would approach <product>" in 8–12 steps.

## Phase 2: Synthesis and mood board

1. Read every report and look at both sheets.
2. Open the sheets for the user.
3. Write down the 3–5 findings that change the approach: accent colour conflicts, saturated territories, the product truth no competitor draws, and where the mark is actually seen.

## Phase 3: Directions (at least 10)

Offer 10 or more directions. Each one has:
- the borrowed sign or product truth it comes from,
- its double reading,
- why it is free in this category (cite the competitor survey),
- its risk.

Recommend a top 5 with reasons. Wait for the user to pick. Do not generate before the pick.

## Phase 4: Generate (picked directions only)

**Model.** GPT Image 2.5 won a five-model benchmark in October 2026 (52/60, next best 41; also tested Seedream 5, FLUX.3, Recraft V4.1 Vector and Gemini 3 Pro Image). Use any provider that serves it.

- Prefer a provider whose API returns **image URLs**, not base64. With URLs, a dropped connection cannot lose finished images, and large base64 payloads do not flood the context.
- Submit small batches (about 5 at a time) to avoid rate limits.
- Run one paid call per script. If a long-running script with many paid calls is interrupted, every image it held is lost.
- Make 2 variants per direction. GPT Image follows simple geometric prompts literally, so both variants come out nearly the same. That is expected.
- Save files as `<tmp>/<product>-icons/NN-slug-V.png`.

**Prompt template.** Fill in the palette and the concept:

```
Flat app icon artwork, square 1024x1024, edge-to-edge solid background with NO rounded corners, no text, no letters, no gradients, no glass, no shadows, no 3D, no texture. Swiss modernist logomark in the spirit of Anton Stankowski and Chermayeff & Geismar: two or three bold geometric shapes, thick confident strokes, optically balanced, centered with generous margin (mark fills about 55% of the canvas). Palette: <background hex> background, <mark hex> mark, and exactly one small accent in <accent hex> used once. It must read clearly at 16 pixels. Concept: <the sign, described as plain geometry, saying which part carries the accent and what it means>.
```

**Contact sheet.** Run `uv run --with pillow python scripts/sheet.py <dir>`. It groups `NN-slug-V.png` files into rows and shows each icon at 300px plus the 16px and 32px tests.

## Phase 5: Critique

Score every direction against the rubric in `references/playbook.md`: one idea, 3 shapes or fewer, silhouette, 16px, mono-first, distinctive against the competitor sheet, appropriate, durable, not a cliché. Sort them into strong, middle and weak. Name what each weak one reads as instead, for example "the ratchet reads as a saw blade".

## Phase 6: Refine (after the user picks a winner)

1. **Hand-build the SVG.** Use exact geometry, optical balance, and stroke weights tuned for 16px. Make 3–4 variants per winner, mono first, with the accent added by rule.
2. **Mac and iOS:** use flat layers (background plus at most 4 groups) in Apple's Icon Composer. Let it add the glass. Check the dark, tinted and clear modes.
3. **Exports:**
   - Favicon: `favicon.ico` (16/32/48), `icon.svg`, 180px `apple-touch-icon.png`, 512px manifest PNG.
   - Chrome: 16/32/48/128, with 96px of art on the 128px canvas and no rounded corners.
4. **Present the winner in context:** Dock, installer window, site header, browser toolbar, sticker. Tell the user it is "never love at first sight". Put it in use for a week before you call it final.

## References

- `references/playbook.md`: the distilled principles, concept process, rubric, clichés and case studies.
- `references/principles-notes.md`: raw quotes and URLs from the first research run.
- `references/sources.md`: curation sites, courses and the best videos.
- `scripts/sheet.py`: the contact-sheet builder.
