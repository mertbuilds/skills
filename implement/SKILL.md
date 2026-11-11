---
name: implement
description: "Build code changes on the project's ONE working branch (one long-lived worktree, one dev server at https://<name>.localhost), commit small, review batches, and open one ready-for-review PR per ship, merged when the risk tier allows. A separate worktree only for parallel work Mert asked for. Use whenever the user asks to implement, build, add, or fix something that touches code, e.g. '/implement', 'implement X', 'build X', 'add X', 'fix X', 'let's build it', 'ship it', 'drop this in', 'go code it up'. Skip for questions, explanations, research, and trivial one-line docs/config edits."
user-invocable: true
---

# Implement: one branch, one server per project, one PR per ship

A lean implementation flow. You've already discussed what to build in the conversation. This skill takes it from there: find the project's one working copy, implement there, commit small, show the one dev server link, and ship from that branch with one PR when it is time to go live. The PR is the merge path: merge it yourself for low and normal risk, ask first for high. `wt merge` is never used.

**The default:** each project has ONE working copy on ONE branch, served by ONE dev server. Every change for that project goes there. No new worktree, branch, PR or preview server per change. (Mert, 2026-11-10: "in local, every project just needs one branch, one server. all their work happens there".)

## When NOT to invoke this skill

- Questions, explanations, code reading, research
- Trivial one-line edits to config/docs in the current repo (just edit in place)
- User explicitly says "do it here" / "don't branch"
- Not in a git repo
- Change is genuinely multi-file with unclear scope and needs real architecture discussion: suggest the heavier `/worktree-dev:worktree-dev` flow instead

## Main-only repos

mertbuilds.com / mertduzgun.com, the Achelia app and the public skills repo work on main, no project branch and no PR. Use their own working copy, keep the same implement, review, proof and commit rules, and push to main after the batch review. Skip the PR and the merge gate in step 6.

## Workflow

### 1. Scope check (one paragraph, no questions unless truly ambiguous)

State in one sentence what you're about to build. Trust the conversation context. Don't open an AskUserQuestion loop.

- If the request is genuinely ambiguous (multiple valid interpretations, not just underspecified), ask one clarifying question inline and stop.
- If the change involves a **non-trivial design choice**, sketch 2 to 3 options with tradeoffs in a few lines and let the user pick before proceeding.
- If scope feels too big for this lean flow (multi-subsystem, needs real architecture work), recommend `/worktree-dev:worktree-dev` and stop.

### 2. Find (or make once) the project's working copy

The repo's main checkout (e.g. `~/code/vinena-studio/angaria`) is shared and hands-off: read-only there, never edit, checkout, reset or pull over dirty files in it. The project's one working copy is its own long-lived worktree, made once and kept.

**Look first, every time:**

```bash
git -C <main-checkout> worktree list          # existing worktrees and their branches
git -C <main-checkout> branch --list          # existing project branch
~/.claude/orchestrator/bin/servers            # running dev servers (https://<name>.localhost)
```

- **A working copy for this project exists** (e.g. `<repo>.<project-branch>` next to the main checkout, on its project branch): `cd` into it and work there. If you are already inside it, just implement.
- **Another agent owns it right now:** don't edit the same files in parallel. Send your change through that agent or take turns.
- **None exists:** create it once. Pick one long-lived branch name for the project's current line of work (repo prefix convention: `feat/`, `fix/`, `chore/`; check `git log --oneline -10`), e.g. `feat/llmond-v2`.

  ```bash
  wt switch --create <project-branch> --yes
  ```

  This makes the worktree and switches into it. worktrunk's `post-create` hook (`~/.config/worktrunk/config.toml`) runs `wt step copy-ignored`, which copies `.env.local`, `.env.*`, `node_modules` and other gitignored files. If the dev server later fails on missing `process.env.X`, run `wt step copy-ignored --from <source-branch>` by hand.

Do not make a new worktree, branch or preview server per change. That working copy and that branch carry all the project's work until it ships.

**Exception, parallel work Mert asked for:** only when Mert explicitly asked for work that must run at the same time on the same repo (two agents on separate tasks at once), make a separate worktree for that task (`wt switch --create <task-branch> --yes`). Merge it back into the project branch (or ship it with its own PR if Mert asked), then remove it right away: `wt remove`, delete the branch, stop any server it started. Never on your own initiative.

### 3. One dev server (if the repo has one)

The project has ONE dev server at `https://<name>.localhost` (portless, never bare `localhost:PORT`).

1. Check `~/.claude/orchestrator/bin/servers` for the project's route. If it runs from this working copy, reuse it: it hot-reloads your edits. Never start a second one.
2. If none runs (or it points at a stale directory), start it detached and registered:
   ```bash
   ~/.claude/orchestrator/bin/serve --owner <worker> --purpose "<project> dev" <name> <working-copy-dir> <pkg-manager> run dev
   ```
   Package manager: `bun.lockb` is bun, `pnpm-lock.yaml` is pnpm, `yarn.lock` is yarn, else npm. Use `--replace` only to move the one route to this working copy, never to add a second route.
3. No `package.json` `dev` script, or not a web project: skip this step.

No extra preview routes (`prefs.*`, `*-design.*`, `*-hero.*`). Mert always tests on the one link.

### 4. Implement (delegate, verify, repeat)

You orchestrate. You do not write code. Every code change goes to an `implementer` subagent (user-level agent at `~/.claude/agents/implementer.md`), one small chunk per agent.

- Split the work into the smallest chunks that each leave the repo building. Typical chunk: one module, one route, one migration, one test file. Never "implement the whole feature" in one agent.
- Spawn with the Agent tool, `subagent_type: "implementer"`, and a prompt that carries everything the agent needs: absolute path of the project's working copy, the exact files to touch, the conventions to follow, the verify commands, and what NOT to do. The agent has no conversation context. Tell it to work only in that working copy and never in the main checkout.
- After each chunk, verify yourself before the next: read the diff, run the typecheck/lint/tests the agent claims passed. Reject and re-spawn on anything that skips, casts to `any`, disables rules, or drifts from the spec.
- Follow the repo's CLAUDE.md / AGENTS.md rules and the user's memory feedback (minimalism, no premature abstractions, no unnecessary comments, no em dashes).
- Keep the diff focused. No unrelated cleanup.
- Ops, investigation, config, and one-line doc fixes stay with you. Code goes to the implementer.
- After each chunk: commit (step 5), let the one server reload, check it, and show Mert the one link.

**Ask for irrefutable proof.** Every chunk and the whole change must show it works, not claim it. Evidence: an end-to-end walkthrough of the real run, screenshots or a screen recording of the real UI (light and dark, mobile width where visible), before/after numbers, command output of the real run, a test that failed before the change and passes after. This is not evidence: "typecheck passes", "lint passes", "build succeeds" on their own, "should work", "I updated X", "tests pass" when no test covers the change, a reviewer agent saying it looks fine. Collect it as you go; it goes in the PR body under "Proof".

**Risk tier.** The change sets the tier, not the author. It goes in the PR body and decides the merge gate (step 6).
- High: billing, payments, paywalls or licensing; auth, sessions, keys or secrets; CI or GitHub workflow files; release, installer or auto-updater code; database migrations, schema or row-level security.
- Low: copy, docs, styles, UI layout, isolated components, additive behind a flag.
- Normal: everything else.

A batch takes the highest tier of any commit in it.

**Review batches, by blast radius.** Code review runs on a batch of commits (everything since the last review or the last ship), not on every small commit. It always runs before any push. Run the `code-reviewer` agent with the commit range, the risk tier, the review depth (fan-out or quick pass) with the risky area, and the proof collected so far (the draft Proof section).
- Full review with fan-out: high tier, plus env handling, deploy config, data writes or deletion, scheduled jobs, public API routes, diffs over ~400 lines or 10 files, anything the repo's AGENTS.md marks as central. These extras get the deep review but stay normal tier at merge. Tell the user explicitly which risky area changed.
- One quick pass, no fan-out: low and other normal changes. Naming, closure vs class, and small duplication are not findings.
- Every review still checks: does it work, was it tested end to end, can it be changed in a month.
- Max 3 review rounds per batch. Round 2+ reviews only the new diff. Still finding things after round 3: stop and rethink the approach.

### 5. Commit small

```bash
git commit -m "$(cat <<'EOF'
<short message, match recent commit style>
EOF
)"
```

Rules (same as `/commit`):
- Stage explicit paths, never `git add -A` or `git add .`.
- Match recent commit style (`git log --oneline -10`).
- Focus on the "why" for non-trivial commits. For small chores, the "what" is enough.
- No Co-Authored-By lines, no "Generated with Claude" signature, no other AI attribution trailer.
- If a pre-commit hook fails, fix the underlying issue, re-stage, and create a NEW commit. Never `--no-verify`. Never `--amend`.
- Before staging, scan the diff for obvious secrets (API keys, tokens, JWTs). Abort and warn the user if any appear.

While Mert iterates live, commit locally and push only when he says so or when shipping.

### 6. Ship: push and open ONE ready-for-review PR

Ship when the work is ready to go live or be released, or Mert says ship. One PR per ship from the project branch, not one per tweak. If the branch already has an open PR, push to it and update its body instead of opening another.

Review the batch first (step 4), then:

```bash
git push -u origin <project-branch>
```

Detect the base branch:
```bash
gh repo view --json defaultBranchRef -q '.defaultBranchRef.name'
```

Open the PR **ready for review** (never draft):
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
- No "Generated with Claude" line. User's preferred voice: lowercase, direct, no em dashes.

**Merge gate** (tier from step 4). Low and normal: merge yourself once CI is all-green (read the check results in their own step first), the reviewer pass is clean, and a visible change passed a test on the dev server. High: stop at "ready". Show the user the PR link, the Risk and How to revert sections and a two-line summary, and ask for their go on that PR's own card. A reviewer agent's pass never replaces it. New commits after the go need a fresh go.

**After merge:** keep the project's working copy and its one server. Bring the branch up to date with the default branch (`git fetch origin && git merge origin/<base>` in the working copy) and keep working there, or, if the line of work is finished, let the next work start a fresh project branch in that same worktree. Only parallel-work worktrees (step 2 exception) are removed after merge.

### 7. Report (tight, a few lines, not a wall)

Tell the user:
- Working copy path + branch, and the PR URL if shipped
- **The one dev server link**: `https://<name>.localhost`
- Files changed + commit hashes
- Typecheck/test result if you ran one
- Proof that it works (same as the PR's Proof section; for main-only repos this report is where it lives)
- Risk tier and review depth; for high tier or a fan-out review, which risky area changed
- Ship state: committed locally, pushed, merged (low/normal), or waiting for the user's go (high)
- Any known limitations or follow-ups

### 8. Clean up

- Parallel-work worktrees: `wt remove`, delete the branch and stop their server right after merging them back.
- Background tasks this skill started with `run_in_background: true` (not the registered project server): stop them at the end of the flow.
- The project's one dev server stays up while the project is in work. Stop it with `~/.claude/orchestrator/bin/serve --stop <name>` only when the project's work is done or Mert asks.

## What this skill does NOT do

- No new worktree, branch, PR or preview server per change. One working copy, one branch, one server per project.
- No edits in the shared main checkout.
- No `wt merge`: merging happens via the PR (see Merge gate).
- No parallel architect agents: that's `/worktree-dev:worktree-dev`. Review fan-out happens inside the `code-reviewer` agent.
- No draft PRs. Always open ready for review; if a PR ends up draft, mark it ready (`gh pr ready <number>`, or GraphQL `markPullRequestReadyForReview`).
- No force-push, no `--no-verify`, no amending existing commits.
