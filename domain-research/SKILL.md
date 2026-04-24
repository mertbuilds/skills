---
name: domain-research
description: "Research a product name and domain with keyword demand + availability data. Use when the user says 'domain research', 'research a domain', 'check a domain', 'find a name', 'brainstorm domain', 'evaluate domain', 'is X.com available', or pitches a product/project and wants to pick a useful .com. Runs Google Trends trajectory, Ahrefs keyword validation, batch .com availability via RDAP, and returns a ranked shortlist."
user-invocable: true
---

# Domain Research

Help the user pick a useful, descriptive .com for a new product by combining keyword demand data (Google Trends + Ahrefs) with batch availability checks (RDAP). Optimize for SEO-as-marketing, not brand-building.

## Baked-in preferences

These apply unless the user explicitly overrides them:

- **.com first, always.** Only look at alt-TLDs (.io, .so, .app, .dev, .ai) if the user opens that door or every sensible .com is taken.
- **Useful > brandable.** The user's strategy is descriptive naming that does SEO work. Do NOT suggest invented/abstract names (Obsidian/Roam style) as primary options — the user can't afford brand-building spend.
- **No obscure acronyms.** `ai` and `llm` are fine (widely understood). `kb`, `pkb`, `pkm`, `kms` and similar are not — spell them out.
- **"llm" dates fast.** Flag it when suggesting names that contain it. "ai" is less risky but still mention the concern.
- **Watch trademarks.** Flag when a name is close to a well-known brand (e.g. "Second Brain" = Tiago Forte territory).

## Step 0: Confirm agent-browser + Ahrefs session

Ahrefs keyword research requires the user to be logged into Ahrefs in Brave. Before doing anything:

1. Check if Brave is running with debugging enabled by trying `agent-browser --auto-connect get url` (quick, cheap).
2. If that fails, ask the user: "I need you to open Brave and log into Ahrefs at https://ahrefs.com so I can run keyword research. Let me know when you're ready."
3. When ready, open `https://app.ahrefs.com/dashboard` and check the URL. If it redirects to `/pricing` or `/login`, Ahrefs is not logged in on this account's plan — tell the user and fall back: skip the Ahrefs step and use Google autocomplete + common-sense volume guesses instead. Google Trends does not require login.

Session check is part of every run, even if the skill ran successfully earlier — sessions expire.

## Step 1: Understand the product

If the user hasn't already described the product in conversation, ask:

1. What does the product do? (one or two sentences)
2. Who is it for? (developers, general consumers, specific niche)
3. What phrases would a user type into Google to find it?

Infer the search terms if the user's description is clear enough. Don't over-ask — one round is usually enough.

## Step 2: Propose 2-3 keyword pathways

Based on the product, identify 2-3 candidate head terms — the phrases people might search that the domain could anchor on. For a knowledge/PKM tool the pathways might be:

- "second brain" (biggest pond, but Tiago Forte conflict)
- "personal knowledge base" (cleaner, smaller)
- "wiki" or "personal wiki" (smallest, most specific)

For other products, pick whatever pathways fit. Present 2-3 with trade-offs (volume, KD, conflict risk, typicality of phrasing). Ask the user which pathway to dig into, or offer to run all in parallel.

## Step 3: Google Trends trajectory (required)

Before sinking time into detailed keyword research, validate direction. A term with >1000 monthly searches but a declining trend over 12 months is worse than a term with >100 and a 2x climb.

Google Trends supports side-by-side comparison of up to 5 terms. Use agent-browser:

```bash
# URL-encode the comma-separated query string; %2C = ","
agent-browser --auto-connect open "https://trends.google.com/trends/explore?q=term1%2Cterm2%2Cterm3&geo=US&date=today%2012-m"
agent-browser --auto-connect wait --load networkidle
agent-browser --auto-connect wait --text "Interest over time" --timeout 30000
agent-browser --auto-connect screenshot /tmp/trends.png
```

Read the screenshot visually to compare trajectory lines. Record for each pathway:

- Average interest (0-100, relative scale — Google Trends is NOT absolute volume)
- Trend direction: climbing / flat / declining
- Ratio between terms (e.g. "second brain runs ~3-5x higher than personal wiki")

Also scroll to the "Related queries" section and screenshot "Rising" — this surfaces emerging phrasings the user might not have considered. Rising queries often make better domain bets than the head term itself.

If you need exact weekly data points, use the CSV export button. But a visual read of the chart is usually enough for naming decisions.

Important caveats to tell the user:

- Google Trends values are **relative, not absolute**. A term at "100" vs a term at "10" means 10x the relative interest, but neither value maps to search volume directly.
- Terms with low absolute volume may show as "0" even if they have some activity — combine Trends with Ahrefs volume buckets for the full picture.

## Step 4: Keyword validation via Ahrefs free tool

For each surviving pathway, visit `https://ahrefs.com/keyword-generator/?country=us&input=<PHRASE>` via agent-browser.

Extract the results dialog with:

```js
Array.from(document.querySelectorAll("tr")).slice(0,12).map(r =>
  Array.from(r.querySelectorAll("td,th")).map(c => c.innerText.trim().replace(/\s+/g," ")).join(" | ")
).join("\n")
```

Record volume (bucketed: `<100`, `>100`, `>1000`, `>10000`) and KD (Easy/Medium/Hard) for each head term. Also record a few adjacent phrases the user might target.

If Ahrefs returns "No keyword ideas," flag the term as invented/zero-volume.

Cloudflare challenges may appear — wait 5-10 seconds and re-check the page before concluding no data.

## Step 5: Generate descriptive .com candidate list

For each surviving pathway, generate ~10-15 descriptive .com candidate patterns. Apply baked-in preferences:

Good patterns:
- `<modifier><headterm>.com` — e.g., `aisecondbrain.com`, `livingsecondbrain.com`, `growingwiki.com`
- `<verb><headterm>.com` — e.g., `buildsecondbrain.com`, `ownyourwiki.com`
- `<headterm><suffix>.com` — e.g., `secondbrainapp.com` (weak), `secondbrainllm.com` (dates)
- `<differentiator>+<category>.com` — e.g., `compoundwiki.com`, `livingnotes.com`

Avoid patterns:
- Invented/abstract words as primary options (Obsidian-style) — save these as optional side list only
- Obscure acronyms (pkb, kb, pkm)
- Awkward multi-word stacks ("aisecondbrainapp.com" = too long)

Add user-mentioned candidates to the list — never silently drop them. Also consider rising queries from Step 3 as candidate seeds.

## Step 6: Batch availability check via RDAP

Use rdap.org (follows redirects to the right registry) — NOT macOS `whois`, which falls back to IANA for unfamiliar TLDs and returns false-positives.

```bash
for d in <list>; do
  c=$(curl -sL -o /dev/null -w "%{http_code}" "https://rdap.org/domain/$d" --max-time 8)
  if [ "$c" = "404" ]; then echo "AVAIL  $d"
  elif [ "$c" = "200" ]; then echo "taken  $d"
  else echo "?$c  $d"  # 429 = rate limit, retry
  fi
done
```

**Parallelism**: Start with `xargs -P 6` for speed. Sequential retry (with `sleep 0.4-0.6` between calls) for any that return `429`.

**429 handling**: Collect all 429s and rerun them sequentially in a retry pass. Do not mark a domain taken based on a 429.

**Big batch tip**: Run in `run_in_background: true` and use `Monitor` with `grep --line-buffered -E "^AVAIL"` to stream hits as they arrive.

## Step 7: Rank and present shortlist

Group by pathway, rank by:

1. **Matches head term** — higher volume head term = stronger SEO anchor
2. **Trajectory** — climbing term > flat > declining (from Step 3)
3. **Ages well** — no "llm" > "ai" > trendy suffixes
4. **Conflict risk** — flag proximity to known brands (Tiago Forte for "second brain", Notion/Obsidian/Roam for "note", etc.)
5. **Memorability** — short, pronounceable, not awkward

Present as a compact table. Include a "skip" list for weak available options so the user knows I evaluated them.

Always surface a **top pick** with one-sentence justification and a **runner-up** for comparison. Don't hedge with 10 equal options.

## Step 8: Market reality check (optional, ask first)

Before committing, offer: "Want me to run a market reality check on the top pick? Covers how buyers talk, who ranks for the head term, and signals from social."

If yes, run any combination of:

**a. Buyer-language scan via `last30days`**

Invoke the `last30days` skill with the head term as the query. It returns a synthesized report from Reddit, X, HN, YouTube, Bluesky, etc. Look specifically for:

- Phrases like "I need…" / "looking for…" / "recommend…" / "alternative to…"
- Repeated pain points the product could address
- Competitor names that keep coming up

Buyers' language on social often differs from how creators describe their own products — worth checking before committing to a name.

**b. Competitor SERP scan**

```bash
agent-browser --auto-connect open "https://www.google.com/search?q=<headterm>"
agent-browser --auto-connect screenshot /tmp/serp.png
```

Read the top 10 results. Note whether the SERP is:

- **Branded** (dominated by big products like Notion, Obsidian) — hard to rank, even with exact-match domain
- **Informational** (articles, listicles, guides) — easier to rank with original content
- **Mixed** — middle ground; look for exploitable gaps

Also check if the SERP has AI Overviews / featured snippets — those change the game.

**c. Buyer-intent search**

Quick X and Reddit searches for purchase intent:

```bash
# On X
agent-browser --auto-connect open "https://x.com/search?q=%22looking%20for%22%20<headterm>"
agent-browser --auto-connect open "https://x.com/search?q=%22recommend%22%20<headterm>"

# On Reddit via Google
agent-browser --auto-connect open "https://www.google.com/search?q=site%3Areddit.com+%22looking+for%22+<headterm>"
```

If the results are mostly "curious about" and "learning how" posts — low purchase intent. If they're "I've tried X, Y, Z — what else?" — high purchase intent. The latter is where money is.

## Step 9: Optional prior-art pass

Offer: "Want me to run a quick prior-art check on the top 2-3 (Google + USPTO + GitHub)?"

If yes:
- `agent-browser open "https://www.google.com/search?q=<name>"` — scan results for existing products, books, active projects
- `agent-browser open "https://tmsearch.uspto.gov/"` — search the phrase (US trademark only; global TM is out of scope for a quick pass)
- Search GitHub: `agent-browser open "https://github.com/search?q=<name>&type=repositories"`

Report anything that could cause friction: active products using the name, registered trademarks, GitHub projects with >1K stars.

## Step 10: Save a clip for wiki ingestion

After the user picks a direction (or passes on all of them), save a clip:

File: `raw/clips/domain-research-<product-slug>-<YYYYMMDD>.md`

```yaml
---
title: "Domain research: <product description>"
source: conversation
created: YYYY-MM-DD
context: "Domain/naming research session"
tags:
  - conversation
  - domain-research
---

# Domain research: <product>

## Product
<one-sentence description>

## Pathways considered
- <pathway 1>: <head term volume + KD + Trends trajectory>
- <pathway 2>: ...

## Candidates evaluated
<compact table or list with availability + rationale>

## Market reality (if run)
<buyer language, SERP landscape, buyer intent>

## Decision
<what the user picked, or "still deciding" if unresolved>

## Rationale
<why — include the trade-offs that mattered>
```

Write the clip quietly — don't ask permission. The wiki-sweep will pick it up later.

## Step 11: Commit the clip

After the clip is written, commit it.

```bash
git add raw/clips/domain-research-<product-slug>-<YYYYMMDD>.md
git commit -m "$(cat <<'EOF'
domain-research: capture <product> naming session
EOF
)"
```

Rules:
- Stage only the session clip. Never `git add .` or `git add -A`.
- Skip the commit if the session ended before Step 10 wrote a clip (e.g., user bailed at pathway selection).
- If a pre-commit hook fails, fix and create a new commit — do not `--amend`.
- Never push; that's a separate decision.

## What NOT to do

- Don't lead with brandable/invented names (cairn, engram, kiln) unless the user explicitly rejects descriptive options first.
- Don't run whois via macOS `whois` for anything other than `.com` — it returns IANA TLD records for unfamiliar TLDs and you'll report taken domains as available or vice versa.
- Don't claim prior-art is clean after a 30-second search. If you only did a quick pass, say so.
- Don't accept 429 / timeout as "taken" — always retry rate-limited domains.
- Don't recommend alt-TLDs unless the user opens that door or every sensible .com is taken.
- Don't present Google Trends values as absolute volumes — they are relative (0-100). Always pair with Ahrefs buckets for the full picture.
