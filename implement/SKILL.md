---
name: implement
description: "Build a feature in an isolated worktrunk worktree, commit, open a ready-for-review PR, and merge it when the risk tier allows. Use whenever the user asks to implement, build, add, or fix something that touches code — e.g. '/implement', 'implement X', 'build X', 'add X', 'fix X', 'let's build it', 'ship it', 'drop this in', 'go code it up'. Skip for questions, explanations, research, and trivial one-line docs/config edits. Skip if already inside a worktrunk worktree (just implement directly)."
user-invocable: true
---

# Implement: worktrunk-isolated build, ready-for-review PR out

A lean implementation flow. You've already discussed what to build in the conversation — this skill takes it from there: isolate to a worktree, implement, commit, push, open a PR that is ready for review. Stay in the worktree so the user can iterate on review feedback without switching. The PR is the merge path: merge it yourself for low and normal risk, ask first for high. `wt merge` is never used.

## When NOT to invoke this skill

- Questions, explanations, code reading, research
- Trivial one-line edits to config/docs in the current repo (just edit in place)
- User explicitly says "do it here" / "don't branch"
- Already inside a worktrunk worktree (just implement + commit directly, no new worktree)
- Not in a git repo
- Change is genuinely multi-file with unclear scope and needs real architecture discussion — suggest the heavier `/worktree-dev:worktree-dev` flow instead

## Workflow

### 1. Scope check (one paragraph, no questions unless truly ambiguous)

State in one sentence what you're about to build. Trust the conversation context — don't open an AskUserQuestion loop.

- If the request is genuinely ambiguous (multiple valid interpretations, not just underspecified), ask one clarifying question inline and stop.
- If the change involves a **non-trivial design choice**, sketch 2–3 options with tradeoffs in a few lines and let the user pick before proceeding (per the user's brainstorm-first preference).
- If scope feels too big for this lean flow — multi-subsystem, needs real architecture work — recommend `/worktree-dev:worktree-dev` and stop.

### 2. Create the worktree

Pick a descriptive branch name. Use repo convention prefixes (`fix/`, `add/`, `feat/`, `chore/`, `refactor/`, `perf/`) — check `git log --oneline -10` if unsure.

```bash
wt switch --create <branch-name> --yes
```

This switches your working directory into the new worktree.

### 3. Implement (delegate, verify, repeat)

You orchestrate. You do not write code. Every code change goes to an `implementer` subagent (user-level agent at `~/.claude/agents/implementer.md`: Opus, medium effort; reviewer runs high), one small chunk per agent.

- Split the work into the smallest chunks that each leave the repo building. Typical chunk: one module, one route, one migration, one test file. Never "implement the whole feature" in one agent.
- Spawn with the Agent tool, `subagent_type: "implementer"`, and a prompt that carries everything the agent needs: absolute repo path (the worktree), the exact files to touch, the conventions to follow, the verify commands, and what NOT to do. The agent has no conversation context.
- After each chunk, verify yourself before the next: read the diff, run the typecheck/lint/tests the agent claims passed. Reject and re-spawn on anything that skips, casts to `any`, disables rules, or drifts from the spec.
- Follow the repo's CLAUDE.md rules and the user's memory feedback (minimalism, no premature abstractions, no unnecessary comments, no em dashes).
- Keep the diff focused. No unrelated cleanup.
- Ops, investigation, config, and one-line doc fixes stay with you. Code goes to the implementer.

**Ask for irrefutable proof.** Every chunk and the whole change must show it works, not claim it. Evidence: an end-to-end walkthrough of the real run, screenshots or a screen recording of the real UI (light and dark, mobile width where visible), before/after numbers, command output of the real run, a test that failed before the change and passes after. This is not evidence: "typecheck passes", "lint passes", "build succeeds" on their own, "should work", "I updated X", "tests pass" when no test covers the change, a reviewer agent saying it looks fine. Collect it as you go; it goes in the PR body under "Proof".

**Risk tier.** The change sets the tier, not the author. It goes in the PR body and decides the merge gate (step 5).
- High: billing, payments, paywalls or licensing; auth, sessions, keys or secrets; CI or GitHub workflow files; release, installer or auto-updater code; database migrations, schema or row-level security.
- Low: copy, docs, styles, UI layout, isolated components, additive behind a flag.
- Normal: everything else.

**Review by blast radius.** Before every push, run the `code-reviewer` agent. Give it the risk tier, the review depth (fan-out or quick pass) with the risky area, and the proof collected so far (the draft Proof section).
- Full review with fan-out: high tier, plus env handling, deploy config, data writes or deletion, scheduled jobs, public API routes, diffs over ~400 lines or 10 files, anything the repo's AGENTS.md marks as central. These extras get the deep review but stay normal tier at merge. Tell the user explicitly which risky area changed.
- One quick pass, no fan-out: low and other normal changes. Naming, closure vs class, and small duplication are not findings.
- Every review still checks: does it work, was it tested end to end, can it be changed in a month.
- Max 3 review rounds per PR, counting AI reviewers (cubic, Bugbot). Round 2+ reviews only the new diff. Still finding things after round 3: stop and rethink the approach.

### 4. Commit

```bash
git commit -m "$(cat <<'EOF'
<short message — match recent commit style>
EOF
)"
```

Rules (same as `/commit`):
- Match recent commit style (`git log --oneline -10`).
- Focus on the "why" for non-trivial commits. For small chores, the "what" is enough.
- No Co-Authored-By lines, no "Generated with Claude" signature.
- If a pre-commit hook fails, fix the underlying issue, re-stage, and create a NEW commit. Never `--no-verify`. Never `--amend`.
- Before staging, scan the diff for obvious secrets (API keys, tokens, JWTs) — abort and warn the user if any appear.

### 5. Push and open a ready-for-review PR

```bash
git push -u origin <branch-name>
```

Detect the base branch:
```bash
gh repo view --json defaultBranchRef -q '.defaultBranchRef.name'
```

Open the PR **ready for review** (never draft, so AI reviewers like cubic run automatically):
```bash
gh pr create --title "<short title, under 70 chars>" --body "$(cat <<'EOF'
## Summary
<1-3 bullets: what changed and why>

## Proof
<evidence it works: walkthrough, screenshots, before/after numbers, real command output, failing-then-passing test>

## Risk
Tier: <low | normal | high>. Area: <the risky area this touches, or "none">.

## How to revert
<revert the merge commit, turn off the flag, roll back the release, or undo the migration>

## Test plan
- [ ] <relevant check>
- [ ] <relevant check>
EOF
)"
```

- Base PR title + body on ALL commits on this branch vs. the default branch, not just the latest commit.
- If the branch name contains an issue number (`fix/DEV-123-...`, `feat/42-...`), include `Closes #<number>` in the body.
- No "Generated with Claude" line by default. User's preferred voice: lowercase, direct, no em dashes.

**Merge gate** (tier from step 3). Low and normal: merge yourself once CI is all-green (read the check results in their own step first), the reviewer pass is clean and AI reviewer comments are addressed. High: stop at "ready". Show the user the PR link, the Risk and How to revert sections and a two-line summary, and ask for their go. A reviewer agent's pass never replaces it. New commits after the go need a fresh go.

### 6. Start the dev server (if the repo has one)

The whole point of worktree isolation is that multiple features can run side-by-side on different ports. Next.js, Vite, and most modern frameworks auto-increment the port if the default is taken — no flags needed.

**Env files should already be present** — worktrunk's user-level `post-create` hook at `~/.config/worktrunk/config.toml` runs `wt step copy-ignored` after every `wt switch --create`, which copies `.env.local`, `.env.*`, `node_modules`, and other gitignored files from the source worktree. If the dev server fails on missing `process.env.X`, the hook didn't fire — fall back to a manual `wt step copy-ignored --from <source-branch>` before retrying.

1. Check `package.json` for a `dev` script. If none exists (or the project isn't web/JS), skip this step.
2. Detect the package manager: `bun.lockb` → `bun`, `pnpm-lock.yaml` → `pnpm`, `yarn.lock` → `yarn`, else `npm`.
3. Start in the background using Bash's `run_in_background: true`:
   ```bash
   <pkg-manager> run dev
   ```
4. Poll the background output with `BashOutput` until you see the "ready"/"local"/"listening" line that includes a port (`http://localhost:3001`, `:5174`, etc.).
5. Extract the port number.

If the ready line doesn't appear within ~15 seconds, report that startup is still in progress, give the expected port (default + worktree count), and continue — don't block the skill on server startup.

### 7. Report (tight — a few lines, not a wall)

Tell the user:
- Branch name + PR URL (the key output)
- **Dev server URL** (if started): `http://localhost:<port>`
- Files changed + commit hash
- Typecheck/test result if you ran one
- Proof that it works (same as the PR's Proof section; for repos that commit to main without a PR, this report is where it lives)
- Risk tier and review depth; for high tier or a fan-out review, which risky area changed
- Merge state: merged (low/normal), or waiting for the user's go (high)
- Any known limitations or follow-ups
- After merge, run `wt remove` and delete the branch; until then, stay in the worktree.

### 8. Clean up background tasks

When the user signals the implement flow is done — PR approved, no more in-session iteration needed, or they switch topics — kill any background tasks this skill started so they don't leak across sessions.

- Dev server: `kill` the background task id, or `ps aux | grep -E "next.dev|vite|bun.*dev" | grep -v grep | awk '{print $2}' | xargs -r kill`
- Any other `run_in_background: true` tasks this skill started
- Do this proactively at end-of-flow; don't wait for the user to ask.

If the user is actively iterating (asking for follow-up edits in the same session), keep the server running — they'll want the preview. The trigger for cleanup is session boundary, not every tool call.

## What this skill does NOT do

- No `wt switch -` back to the original worktree — stay here for iteration.
- No `wt merge`: merging happens via the PR (see Merge gate).
- No parallel architect agents: that's `/worktree-dev:worktree-dev`. Review fan-out happens inside the `code-reviewer` agent.
- No draft PRs. Always open ready for review; if a PR ends up draft, mark it ready (`gh pr ready <number>`, or GraphQL `markPullRequestReadyForReview`).
- No force-push, no `--no-verify`, no amending existing commits.
