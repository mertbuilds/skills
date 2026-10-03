# Logo + app icon principles: research notes (first run, 2026-10-03)

## Masters

### Paul Rand, "Logos, Flags, and Escutcheons" (1991) [Exa]
https://www.paulrand.design/writing/articles/1991-logos-flags-and-escutcheons.html
- "A logo is a flag, a signature, an escutcheon. A logo doesn't sell (directly), it identifies. A logo is rarely a description of a business. A logo derives its meaning from the quality of the thing it symbolizes, not the other way around. A logo is less important than the product it signifies; what it means is more important than what it looks like."
- "It is only by association with a product ... that a logo takes on any real meaning." "Only after it becomes familiar does a logo function as intended."
- Mercedes star has nothing to do with cars; Lacoste croc, Bacardi bat.
- "Design, good or bad, is a vehicle of memory." "It is easier to remember a well designed image than one that is muddled."
- IBM stripes "reminds me of the Georgia chain gang"; Westinghouse "pawnbroker's sign" -> early ridicule is normal.

### Sagi Haviv (Chermayeff & Geismar & Haviv) [Exa]
TEDxPenn https://www.youtube.com/watch?v=OcF1KBnlvTc ; The Futur https://thefutur.com/content/the-3-rules-of-good-logo-design ; Logo Geek podcast https://logogeek.uk/podcast/sagi-haviv/
- Three criteria: appropriate (personality, "doesn't mean expressive... the less they say, the better"), distinctive & memorable ("we can describe it to someone, or doodle it on a piece of paper"), simple (works tiny and huge).
- "A logo is not communication. It's identification. It's the period at the end of a sentence; not the sentence itself."
- Logo as flag: "It doesn't say very much about the country it represents... over the years it has become a vessel that holds all the associations."
- Client "doesn't need to fall in love with the logo right away."
- Conservation International: rejected the obvious (human figure), explored "dozens and dozens of pages", landed on blue planet + green underline stroke: "unusual, something new, and yet it's so simple."

### Michael Flarup [Exa]
https://medium.com/@flarup/designing-better-app-icons-bac276f89ead ; https://blog.adobe.com/en/publish/2015/07/23/flarup-app-icon
- "An app icon is a visual anchor for your product... a tiny piece of branding that... ideally also communicate[s] the core essence of your application."
- "App icons are not logos." Raster outputs in a square canvas at specific sizes/contexts; different job and criteria.

### Literal vs abstract [Exa]
- Elan Miller, "Great logos aren't literal" (2025) https://offmenu.substack.com/p/great-logos-arent-literal : "The best logos signal a philosophy, not a product." "Literal logos are symptoms of shallow positioning." Brief the designer on what you believe.
- Subverse (2025) https://dissidentchoir.com/the-logo-isnt-a-rulebook-when-literal-beats-abstract-and-vice-versa/ : spectrum literal -> symbolic/reference -> abstracted -> purely abstract. "The further a mark sits from the audience's mental model, the more work the brand has to do to teach meaning." Non-descriptive name puts burden on logo; descriptive name frees the mark to be abstract.

### Flarup "5 core aspects" [Parallel]
https://medium.com/@flarup/designing-better-app-icons-bac276f89ead
- Scalability, Recognizability, Consistency, Uniqueness, No words.
- "An app icon is like a little song." "While scalability is a huge part of recognisability, so is novelty. The search for a balance between these qualities is the very crux of the discipline."
- "Bland, overly complicated icons are the enemy of recognisability." "Try removing details from your icon until the concept starts to deteriorate."
- "Line them up in a grid and try to glance over them" (grid glance test). Test against varied backgrounds.
- "good icon design is an extension of what the app is all about" (consistency with app UI palette).

### Apple HIG app icons (changelog: June 8 2026 "Refined guidance for Liquid Glass") [context.dev scrape; WebFetch failed on JS page]
https://developer.apple.com/design/human-interface-guidelines/app-icons
- "A unique, memorable icon expresses your app's or game's purpose and personality and helps people recognize it at a glance."
- "Find a concept or element that captures the essence of your app or game, make it the core idea of your icon, and express it in a simple, unique way with a minimal number of shapes."
- "Prefer a simple background, such as a solid color or gradient... you don't need to fill the entire icon canvas with content."
- "Consider basing your icon design around filled, overlapping shapes." Overlap + transparency = depth.
- "Prefer clearly defined edges in foreground layers." avoid feathered edges.
- "Vary opacity in foreground layers to increase the sense of depth and liveliness."
- "Let the system handle blurring and other visual effects... no need to include specular highlights, drop shadows..., beveled edges, blurs, glows."
- "Include text only when it's essential." Mnemonic first letter OK.
- "avoid extremely thin line weights and sharp corners" (lose detail small).
- "don't just replicate standard UI components or use app screenshots."
- Appearances: default, dark, clear light/dark, tinted light/dark (iOS/iPadOS/macOS). "Keep your icon's core visual features the same" across appearances. "A great app icon is visible, legible, and recognizable, regardless of its appearance variant." -> mono/tinted test is mandatory; the accent colour will vanish in tinted/clear.
- visionOS: "Avoid adding a shape that's intended to look like a hole or concave area" (system highlights make it stand out). Relevant to "absence/hole" concepts.
- watchOS: avoid black backgrounds (blends in). On macOS/iOS a pure black tile is fine but blends into dark mode wallpaper/dock.
- Icon Composer: background layer + up to several foreground layers; 1024px; P3.

### Susan Kare [Parallel]
- Stanford interview 2000 https://web.stanford.edu/dept/SUL/sites/mac/primary/interviews/kare/books.html : used Dreyfuss "Symbol Sourcebook", road signs, kanji, hobo signs "when you're desperate for an idea... others defy the visual, like 'undo'... This kind of symbol appeals to me because it had to be really simple, and clear to a group of people who were not going to be studying these for years."
- YC Startup School 2026 https://www.ycombinator.com/library/Xc-susan-kare-designing-icons-graphics-for-the-original-mac : "my bias in icons is the a salient detail or two, but don't lard it with a lot of extra stuff." School-crossing sign: could have plaid lunchboxes but would "take away from that instant recognition".
- "Meaningful, memorable, clear." Icons "more like traffic signs than illustrations." "Nobody seems to need to redesign the stop sign every two years." (via blakecrosley.com summary)
- Abstract-concept lesson: "undo" defies the visual -> mine old sign systems (hobo signs, kanji) for proven abstract glyphs.

### Vignelli Canon (RIT PDF) [Parallel]
https://www.rit.edu/vignellicenter/sites/rit.edu.vignellicenter/files/documents/The%20Vignelli%20Canon.pdf
- Semantics ("the search of the meaning of whatever we have to design"), Syntactics, Pragmatics.
- Ambiguity as positive: "a plurality of meanings... the possibility of being read in different ways - each one complementary to the other." But "if not well measured it can backfire."
- Appropriateness: "there are times for just black and white."
- Timelessness: "We despise the culture of obsolescence, the culture of waste, the cult of the ephemeral."
- "In a world where everybody screams, silence is noticeable."

### Michael Bierut [Parallel]
- "A brand new logo seldom means a thing. It is an empty vessel awaiting the meaning that will be poured into it by history and experience. The best thing a designer can do is make that vessel the right shape for what it's going to hold." (widely attributed; from his Design Observer writing)
- "The primitive power of logos" talk https://www.youtube.com/watch?v=I0jw-Q7r-ng : "there is something very primitive about it... not much further evolved than hieroglyphics." "if you act with intelligence and integrity and consistency you'll develop a brand."
- Bierut confirmed at It's Nice That https://www.itsnicethat.com/features/michael-bierut-logo-design [WebSearch+WebFetch]: "The logo is the simplest form of graphic communication. In essence, it is a signature, a way to say, 'This is me.'" Warns companies use logo redesigns as a shortcut for harder sustained communication.

### David Airey, Logo Design Love (ch.3 "Elements of iconic design") [context.dev found chapter list; Exa + Parallel fetched text]
https://archive.davidairey.com/graphic-design/what-makes-a-good-logo/ ; free chapter PDF https://www.logodesignlove.com/images/books/Logo_Design_Love_free_chapter.pdf (WebFetch failed: >10MB)
- Elements: keep it simple, make it relevant, incorporate tradition, aim for distinction, commit to memory, think small, focus on one thing.
- "so recognisable, in fact, that just its shape or outline gives it away. Working only in black and white can help you create more distinctive marks... Colour... really is secondary to the shape and form."
- "a logo doesn't have to go so far as to literally reveal what a company does." (BMW, Virgin Atlantic)
- Commit to memory: "remember after just one quick glance"; "limit how much time you spend on each sketch idea"; "try 30 seconds."
- Think small: "work at a minimum size of around one inch, without loss of detail."
- Focus on one thing: "just one feature to help with differentiation. That's it. Just one. Not two, three, or four." Example: CND logo (Gerald Holtom 1958).

### AI-era clichés [WebSearch]
- Slate Dec 2025 "Why the sparkly star became the symbol for AI" https://slate.com/technology/2025/12/artificial-intelligence-tools-icon-google-gemini-chatgpt-design.html
- Setproduct "Why every AI startup looks the same" https://www.setproduct.com/blog/why-every-ai-startup-looks-the-same : near-black rectangle + purple glow + sparkle; lineage Linear/Vercel/OpenAI; convergence via imitation + AI tools trained on same corpus.
- "Diffusion models... learned that 'AI logo' means 'gradient circle with a hole in the middle'" (HN thread "Why do AI company logos look like buttholes" https://news.ycombinator.com/item?id=48956924)

### Halide icon [WebSearch]
- Sebastiaan de With: "An aperture forming the outline of an app icon" ("App-Erture"), visual pun between the subject and the container. https://dribbble.com/shots/5066013-Halide-Icon ; de With joined Apple design team Jan 2026 (9to5Mac).

## Case studies (abstract ideas)

### CND / peace symbol, Gerald Holtom 1958 [Exa]
https://cnduk.org/the-symbol/ ; https://www.bradford.ac.uk/library/special-collections/our-collections/nuclear-disarmament-symbol-drawings/
- Built from an existing code system: semaphore N + D. Plus a private human gesture: "I was in despair... I drew myself... with hands palm outstretched outwards and downwards in the manner of Goya's peasant before the firing squad. I formalised the drawing into a line and put a circle round it. It was ridiculous at first and such a puny thing."
- Lesson: abstract cause -> borrow a real code (semaphore) + a body gesture; double-reading; looked "puny" at first.

### Chase octagon, Chermayeff & Geismar 1961 [Exa]
https://cghnyc.com/work/project/chase-bank ; Heller in The Atlantic https://www.theatlantic.com/entertainment/archive/2011/12/from-mobil-to-chase-bank-6-iconic-logos-and-how-they-came-to-be/248971/
- "there is no symbol that really means banking" (Geismar). Abstract "but not without meaning": Chinese coin, square in octagon suggests vault; 45-degree cuts give motion. "a single unit made up of separate parts." Executives resisted, then wore it as cufflinks within months.
- Lesson: when the concept has no picture, choose a geometric form with a quiet, deniable reference (coin/vault), then let repetition teach it.

### Are.na [Exa + WebSearch]
- Mark = two six-pointed asterisks (Unicode glyphs) ; Are.na: "There are no 'likes' on Are.na. Instead, it connects things" (Artforum 2018 https://www.artforum.com/columns/the-founders-of-are-na-talk-about-the-history-of-their-online-platform-239620/). Typeface Areal (Dinamo) = a refresh of Arial "keeps Arial's familiar silhouette" as a meaningful gesture inspired by Kristin Lucas' "Refresh" https://abcdinamo.com/news/areal-a-refresh-of-arial-made-for-are-na
- Lesson: anti-attention-economy brand uses default, typed, almost-non-designed glyphs; the restraint is the message.

### Teenage Engineering, Jesper Kouthoofd (SFMOMA 2024) [Exa]
https://www.sfmoma.org/read/stay-curious-stay-naive-an-interview-with-teenage-engineering-jesper-kouthoofd/
- "I set up restrictions when I design. I always work with simple geometric shapes, RAL colors... I stick to rules and try to understand them, because then I can become free again."
- "I connect colors to a meaning and then apply that to all products. If it's orange or red, it means recording." Triangle = yellow, square = blue, circle = red. Lowercase only: "It's democratic."

### Light Phone [Exa]
- Tagline "designed to be used as little as possible" (Joe Hollier, PORT). Packaging essay "It's not really a phone we're selling" https://medium.com/the-light-phone/the-light-phone-packaging-9714f022f895
- Hollier: the object should be "something that you'll be proud to pull out of your pocket."

### Headspace [Exa]
- Raw.Studio case study https://raw.studio/blog/how-headspace-designs-for-mindfulness/ : searched Google "meditation" -> silhouettes on mountaintops -> rejected. Principle: "Communicate abstract ideas through metaphors"; "literal interpretations of emotions aren't necessarily the best way." ITAL/C rebrand: evolve, don't reinvent.
- Headspace's mark is a plain orange circle -> an orange dot is OWNED in the mindfulness category.

### Proton (2022) [Exa]
https://proton.me/blog/new-visual-universe
- Avoided pure lock: Mail icon "based on the bottom half of the original Proton Mail padlock" (cropped cliché -> abstracted). Proton P: "turning away from the path that has been laid out for you and boldly going in a different, better direction"; alludes to encryption keys. Family resemblance across product icons.

### DuckDuckGo [Exa]
- Sean Martell 2021 refresh https://www.seanmartell.com/ddg-branding.html : tested "a plethora of tweaks to every detail of Dax"; mascot (a name pun) not a lock/shield. 2025 browser redesign framed "calm instead of chaotic, streamlined instead of cluttered, secure instead of surveilled."

### Signal [WebSearch]
- Speech bubble with dashed outline: the dashes read as the protected "boundary" around a conversation -> privacy via a broken/dotted edge, not a lock.

### Brick [Exa]
- Literal name-as-object (a brick). Copy: "the 'key' that re-enables distractions is always within reach... Brick lets you leave that key behind."

## Trends 2026 [Exa]
- Envato 2026 trends https://elements.envato.com/learn/logo-and-branding-trends : kinetic logos, "childlike anarchy" anti-design, slick retro, sensory/3D liquid, authenticity; "AI slop the one trend to avoid."

## Indie icon craft [Exa]
- Raycast (2022) https://www.raycast.com/blog/a-fresh-look-and-feel : "We experimented with metaphors... glass cubes, magnifier glasses, and more. But what stuck was a keycap." Launch week: "We took the literal, tangible thing every user... use[s] when opening Raycast... and put our spin on it." Red glow = brand accent on aluminum. -> pick the TOUCHPOINT, not the category symbol.
- Flighty "Boardy" alternate icon (BasicAppleGuy 2023) https://basicappleguy.com/basicappleblog/boardy : split-flap board motif; "Getting to 80% is relatively easy; perfecting from there requires grit"; ~30 variations sent for critique.
- Things OS 26 icon https://culturedcode.com/things/blog/2025/09/things-for-os-26/ : "iconic blue box, refined and realigned... familiar at a glance"; ships Default/Dark/Tinted/Clear. -> Equity: one primitive (box/checkbox) refined for 15+ years.
- Halide: aperture shaped like an app icon outline (pun container/subject).
- Linear 2025: rebuilt Liquid Glass "from first principles... pragmatic level that felt true to the Linear brand" (Saarinen). Linear/Vercel/OpenAI = source of the dark-gradient SaaS sameness (Setproduct).

## macOS icon platform reality [WebSearch + Parallel]
- macOS 26 Tahoe forced all icons into the squircle; non-conforming icons shrunk into a gray squircle ("squircle jail"). https://lapcatsoftware.com/articles/2025/6/2.html ; https://9to5mac.com/2025/08/07/macos-26-icon-changes/
- Rogue Amoeba "Free The Icons" (June 26 2026) https://weblog.rogueamoeba.com/2026/06/26/free-the-icons : macOS 27 Golden Gate refines Apple icons ("superfluous Liquid Glass removed") but shape prohibition remains; "Icons are now harder to distinguish because they're no longer allowed to be distinctive." -> differentiation must come from the INNER glyph + tile color, not silhouette of the tile.

## More masters
- Saul Bass (quoted in Guardian review of "Saul Bass: A Life in Film & Design") https://www.theguardian.com/artanddesign/2011/oct/30/saul-bass-life-film-review : "The ideal trademark is one that is pushed to its utmost limits in terms of abstraction and ambiguity, yet is still readable. Trademarks are usually metaphors of one kind or another. And are, in a certain sense, thinking made visible." Also: "If it's simple simple, it's boring... We try for the idea that is so simple that it will make you think and rethink." [Parallel + WebSearch]
- Jony Ive, iOS 7 (2013) TechCrunch https://techcrunch.com/2013/06/11/jony-ives-debutes-ios-7-bringing-order-to-complexity : "True simplicity is derived from so much more than just the absence of clutter and ornamentation. It's about bringing order to complexity." Also: "Simplicity is somehow essentially describing the purpose and place of an object." [Parallel]
- Aaron Draplin [WebSearch]: reduce to one color; thick lines -> thick type; "no bullshit"; reproducible small and large. Logo Geek podcast https://logogeek.uk/podcast/aaron-draplin/

## Process technique [Exa]
- Logo Geek idea generation https://logogeek.uk/podcast/idea-generation-techniques : word mapping (centre word -> associations -> thesaurus), "picture mix & match" (search "<word> symbol", sketch everything, combine two sets), visual storytelling; 4 categories: corporate activity, corporate ideals, corporate name, abstract.

## More (late batch)
- C&G Print interview https://www.printmag.com/branding-identity-design/marks-men-an-interview-with-ivan-chermayeff-tom-geismar-and-sagi-haviv-of-chermayeff-geisma : Chermayeff: "A memorable identity is one that is appropriate, flexible, and distinguished by its originality... a good trademark... is devoid of fashion or trend." Swooshes: "never!" [Parallel]
- Geismar 99% Invisible https://99percentinvisible.org/episode/making-mark-visual-identity-tom-geismar : criteria appropriate / distinctive / flexible; Chase had to work in black-and-white for newspapers; presents without naming a favorite; "it's never love at first sight"; asks clients to "imagine what it might be". [Parallel]
- FedEx (Lindon Leader, 1994) https://www.retailbrew.com/stories/2022/10/07/logo-big-or-go-home-how-fedex-s-secret-arrow-was-created-accidentally : 200+ designs mocked up, refined to 6, then noticed the arrow. Persuaded client to drop 9 of 14 letters. [Parallel]
- PMC 2023 study https://pmc.ncbi.nlm.nih.gov/articles/PMC10317936/ : "people do not unconsciously perceive the FedEx arrow"; hidden negative-space meaning has no subliminal effect, only once known. -> Hidden meanings are story, not perception. [Parallel]
- Tate (Wolff Olins 2000) https://www.creativereview.co.uk/the-tate-logo/ : theme "look again, think again"; a family of logos moving in and out of focus; "one way of writing Tate, which is always changing." Abstract concept (seeing anew / focus) done via a behaviour of type, not an icon. [WebSearch]
- Opal https://brandkit.opal.so/ : gems = gamified focus rewards. Category cliché: gem. [WebSearch]
- Kenya Hara / MUJI [Exa]: https://www.pacificplace.com.hk/en/entertainment/thestylesheet/muji-kenya-hara-interview-q4-2021 : "create a vessel that can accept those ideas"; simplicity vs emptiness (Henckels knife = simple, yanagiba = empty). SOMA https://www.somamagazine.com/kenya-hara/ : "MUJI is an empty vessel." "Emptiness is a creative receptacle that is not a message by itself." Japanese flag: "There is no exact meaning for the red circle except 'red circle.'"

## Search engine contribution log
- Exa: primary texts and case studies (Rand essay, Haviv talks, CND, Chase, Are.na, TE/Kouthoofd, Kenya Hara, Light Phone, Headspace, Proton, DDG, Brick, Raycast, Flighty, Things, 2026 trends, literal-vs-abstract essays, Logo Geek process).
- Parallel: quote verification and primary interviews (Flarup 5 aspects, Kare Stanford + YC 2026, Vignelli Canon, Bierut, Saul Bass, Ive, Geismar/99pi, C&G Print interview, FedEx/PMC, Rogue Amoeba macOS 27, Airey page fetch).
- context.dev: Apple HIG full text (only tool that rendered the JS page; needed approval) + Airey chapter list.
- WebSearch/WebFetch: AI sparkle cliché sources, Halide, Signal, Are.na asterisks, Tahoe squircle jail, Draplin, Tate, Opal, Bierut (It's Nice That, WebFetch). WebFetch failed on Apple HIG (JS) and Airey PDF (>10MB).
