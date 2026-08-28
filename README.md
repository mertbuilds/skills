# skills

My public [Claude Code](https://claude.com/claude-code) skills.

Skills are self-contained capabilities Claude Code loads on demand — each is a directory with a `SKILL.md` file that has YAML frontmatter (name, description) and a prompt body. See [Anthropic's skills docs](https://docs.claude.com/en/docs/agents/skills) for the format.

## Install

Clone a skill directly into your skills dir:

```bash
# user-level (available in every project)
git clone https://github.com/mertbuilds/skills.git /tmp/mert-skills
cp -r /tmp/mert-skills/<skill-name> ~/.claude/skills/

# or project-level
cp -r /tmp/mert-skills/<skill-name> .claude/skills/
```

Or drop individual `SKILL.md` files into `~/.claude/skills/<skill-name>/SKILL.md`.

Claude Code picks up new skills on next launch.

## Skills

### [`implement`](./implement/SKILL.md)

Build a feature in an isolated git worktree, commit, and open a draft PR. Triggers on "implement X", "build X", "fix X", `/implement`.

**Requires [worktrunk](https://github.com/worktrunk/worktrunk)** (the `wt` CLI). The skill uses `wt switch --create` for worktree isolation and `wt step copy-ignored` for env file propagation. Without worktrunk, the workflow won't run as written — fork and swap `wt` calls for `git worktree add` if you prefer vanilla git.

### [`domain-research`](./domain-research/SKILL.md)

Research a product name and `.com` domain by combining Google Trends trajectory, Ahrefs keyword validation, and batch RDAP availability checks. Returns a ranked shortlist with a top pick.

**Opinionated:** biased toward descriptive `.com` names that do SEO work, against invented/brandable names, against alt-TLDs unless every sensible `.com` is taken. If that's not your strategy, fork it.

**Requires:**
- [agent-browser](https://github.com/agent-browser/agent-browser) for Google Trends + Ahrefs scraping
- An Ahrefs account logged into Brave (skill uses the free keyword generator behind login)
- `curl` for RDAP batch availability

### [`feed-safe-images`](./feed-safe-images/SKILL.md)

Pad photos onto a white canvas at the ratio social-media feeds use, so the full photo is visible on X, Instagram, Threads, or LinkedIn before anyone taps. Ships `scripts/pad.sh`: one ffmpeg call per photo, layouts for X 1-4 image posts (16:9, 7:8, 4:7, 2:1), Instagram and Threads 4:5, LinkedIn 4:5 and 1.91:1.

**Requires** `ffmpeg`. No accounts, no API keys.

## License

MIT — see [LICENSE](./LICENSE).
