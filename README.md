# Claude Code guardrails

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Built for Claude Code](https://img.shields.io/badge/built%20for-Claude%20Code-d97757.svg)](https://code.claude.com/docs)
[![PRs welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Questions? Discussions](https://img.shields.io/badge/questions-discussions-8957e5.svg)](https://github.com/jordankrueger/backup-first-ai/discussions)

A starter set of safety defaults for [Claude Code](https://code.claude.com/docs), built for people who are not security engineers.

Copy a file, flip on one setting, do a short checklist. It is a strong starting point you can put in place in a few minutes — not a complete shield, and the honest limits are spelled out below.

## The one idea

> **Everything the AI touches should be backed up in a way it can't delete.**

You cannot fully stop an AI coding agent from making a mistake or being tricked into one. The agent reads files, runs commands, and installs software on its own, and there is no setting that guarantees it always behaves. So do not bet your safety on perfect behavior.

Bet it on this instead: assume the worst day happens, and make that day survivable. If the thing the agent can destroy is also backed up somewhere the agent cannot reach, a disaster becomes an inconvenience.

That single move matters more than every other tip in this repo combined.

## Why this exists

Modern AI coding agents are not autocomplete. They open files, run shell commands, install dependencies, and take actions without a human approving each step. That is exactly why they are useful, and also why they occasionally cause real damage. Documented incidents include agents deleting live databases, leaking credentials into logs, installing malicious packages they invented, and following hidden instructions planted in a file.

You do not need to understand any of that deeply to be safe. You need a few sensible defaults in the right places. That is all this is.

## What's here

- **`CLAUDE.md`** — drop-in rules you paste into your project. These are *instructions* the agent reads and generally follows.
- **`settings.example.json`** — example *limits* that Claude Code and your operating system enforce, so they hold even when the agent is confused or tricked. (These are two different layers — explained below.)
- **`hooks/`** — an optional script that refuses a short list of disastrous commands before they run. Setup is under "Optional: block the worst commands" below.
- **`BACKUPS.md`** — how to back up your computer, a client's website, Google Workspace or Microsoft 365, and your servers, with one copy the agent can't delete. Includes a prompt to have Claude walk you through it.
- **`sources.md`** — the research these defaults are drawn from, so you can check the reasoning yourself.

## Quick start

1. **Copy `CLAUDE.md`** into the top folder of your project. Claude Code reads it automatically.
2. **Turn on the sandbox.** In Claude Code, run `/sandbox`. On the Mode tab, pick **Regular permissions** if you still want to approve each command before it runs. The other choice, auto-allow, runs every sandboxed command without asking, including ones that change or delete files in your project. On a Mac there is nothing to install. On Windows, run Claude Code inside WSL2: **native Windows has no sandbox at all**, so commands run unprotected there. (See the [sandbox docs](https://code.claude.com/docs/en/sandboxing) for Linux and WSL2 setup.)
3. **Borrow from `settings.example.json`.** Open it, read the sections below that explain each part (JSON files can't hold comments, so the explanations live here), and copy the parts that fit into your own `.claude/settings.json`. Adapt before using — do not paste blindly.
4. **Do the "out of its reach" checklist** below. This is the part that actually saves you.

## Soft guardrails vs. hard guardrails

This is the most important thing to understand, and most guides skip it.

- **`CLAUDE.md` rules are soft.** The agent reads them and almost always follows them. But a cleverly worded file or web page can sometimes talk it out of them. Think of these as a good employee handbook: followed in good faith, not physically enforced.
- **Permission rules and the sandbox are harder.** These are two different mechanisms, and it helps to know which is which:
  - *Permission rules* (the `permissions` block in settings) are enforced by Claude Code itself, before it uses one of its own tools. A `deny` rule stops Claude from reading or editing what you've blocked.
  - *The sandbox* is enforced by your operating system, on the shell commands the agent runs and anything those commands start. It is the stronger of the two, because it holds regardless of what the model decided to do. It covers shell commands only: MCP servers, hooks, and Claude's own file tools run outside it.
  - They cover different things, so use both. One consequence worth knowing: a permission rule blocks Claude's own reader and simple commands that name the file, like `cat secrets.txt`. It does not stop a command that reads without naming the file (`grep -r password .`) or a script that opens it. Only the sandbox catches those. That's exactly why the credential note further down matters.
- **The backup is the hardest guardrail of all**, because it lives somewhere the agent has no access to at all.

None of these is perfect. The soft rules prevent everyday mistakes; the permission and sandbox limits contain a bad day; the backup makes the worst day recoverable. Layer all of them.

## The "out of its reach" checklist

The whole thesis, made concrete. None of these are things you tell the AI. They are things you put beyond it.

- [ ] **A backup the agent cannot delete.** Versioned and offsite or append-only — somewhere the credentials on this machine cannot reach. If your "backup" uses the same login the agent can use, it is not a backup from the agent's point of view. [`BACKUPS.md`](BACKUPS.md) walks through setting one up.
- [ ] **Least-privilege credentials.** Give the agent's environment the narrowest access that still gets the job done. Don't hand it a key that can wipe production when it only needs to read one folder.
- [ ] **Sandbox on.** Filesystem and network isolation enforced by the OS, for the commands the agent runs. See `settings.example.json`. Note: if the sandbox can't start, Claude Code runs commands *without* it unless you tell it to fail closed (see below).
- [ ] **Spending caps.** Put a hard cap on any API key the agent can use, so a runaway loop costs you a coffee, not a mortgage payment.
- [ ] **GitHub push protection on.** GitHub can refuse a push that contains a recognizable API key or password. "Push protection for yourself" is on by default and covers public repositories; check it under Settings → Code security. Private repositories need GitHub's paid Secret Protection for the same check. See [GitHub's docs](https://docs.github.com/en/code-security/how-tos/secure-your-secrets/prevent-future-leaks/push-protection-for-users).

## Block the agent from reading your credentials

One specific gotcha worth calling out: even with the sandbox on, Claude Code's *default* still lets commands **read** sensitive files like `~/.ssh` and `~/.aws/credentials`. It only blocks *writes* outside your project by default. If you keep cloud or SSH keys in the usual places, add them to `denyRead` (see `settings.example.json`) so a tricked agent can't read them and send them somewhere.

**Tradeoff to know:** blocking `~/.ssh` and `~/.aws` can also break legitimate tools that need those keys — the AWS or Google Cloud command-line tools, some deploy scripts. That is the point (those are exactly the keys you don't want a tricked agent reading), but if a normal command suddenly fails, this is the first place to look. Unblock the specific path you need and leave the rest closed.

**Secrets in environment variables are a separate gap.** Commands inside the sandbox inherit Claude Code's environment, so an API key you've exported in your shell (`GITHUB_TOKEN`, `OPENAI_API_KEY` and so on) is readable by them even with the files above blocked. On Claude Code v2.1.187 or later you can strip named variables from sandboxed commands with a `credentials` block inside `sandbox`:

```json
"credentials": {
  "envVars": [
    { "name": "GITHUB_TOKEN", "mode": "deny" }
  ]
}
```

List each variable by name; there's no built-in list. A tool that needs one of them will stop working inside the sandbox, the same tradeoff as above. See [Protect credentials](https://code.claude.com/docs/en/sandboxing#protect-credentials).

**Git over SSH on a Mac is a separate problem.** `git fetch`, `git pull`, and `git push` to an SSH remote fail inside the sandbox on macOS whether or not `~/.ssh` is blocked, so unblocking it won't help. Switch the remote to HTTPS, or add `"excludedCommands": ["git fetch *", "git pull *", "git push *"]` inside the `sandbox` block. Excluded commands run completely outside the sandbox and can reach any host, so HTTPS is the safer of the two. See [the docs](https://code.claude.com/docs/en/sandboxing#git-over-ssh-fails-with-the-sandbox-on).

**Say no to any prompt that says "unsandboxed."** When the sandbox blocks a command, Claude can ask to retry it outside the sandbox. That retry is how a blocked read of your keys could get through, and if you once clicked "don't ask again" on a similar command, it may go through without asking at all. The setting below turns the retry off.

**Want it to fail closed?** By default, if the sandbox can't start, Claude Code runs commands *without* it. To make that a hard stop instead, add `"failIfUnavailable": true` inside the `sandbox` block, and `"allowUnsandboxedCommands": false` to remove the agent's ability to retry a blocked command outside the sandbox (the `/sandbox` Overrides tab calls this **Strict sandbox mode**). These are stricter and safer, but they can also get in your way — turn them on once the basics feel comfortable.

## Optional: block the worst commands

A *hook* is a small script Claude Code runs before each command. `hooks/block-dangerous-commands.sh` refuses a short list of commands that are almost never intended: deleting your whole disk or home folder, force-pushing over `main`, erasing a drive, and SQL that drops or empties a table. Everything else runs as normal.

1. Copy `hooks/block-dangerous-commands.sh` into your project at `.claude/hooks/`, and make it runnable: `chmod +x .claude/hooks/block-dangerous-commands.sh`
2. Add this to your `.claude/settings.json`, next to the other settings:

   ```json
   "hooks": {
     "PreToolUse": [
       {
         "matcher": "Bash",
         "hooks": [
           { "type": "command", "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/block-dangerous-commands.sh" }
         ]
       }
     ]
   }
   ```

3. Check it works: from this repo, run `bash hooks/test.sh`. It needs `jq`, which comes with macOS 15 and later (on Linux or WSL2, `sudo apt install jq`). **Without `jq` the hook quietly lets everything through**, which is why the test checks for it.

**Where this sits.** A hook reads the text of a command, so a reworded version (`/bin/rm` instead of `rm`) can get past it. That makes it stronger than `CLAUDE.md`, because the agent can't be talked out of it, but weaker than the sandbox, which the operating system enforces. It catches the everyday slip. It is not a wall. See the [hooks docs](https://code.claude.com/docs/en/hooks).

## The companion notebook

All of the research behind these defaults is loaded into a public NotebookLM you can ask plain-language questions of — *"why does this rule exist?"*, *"is what I'm about to do risky?"* — instead of reading every source yourself.

**[Open the companion notebook →](https://notebooklm.google.com/notebook/221cbc78-1703-4dab-ae80-f9141a8c1a5f)** (a free Google account is needed to view it.)

Prefer your own copy, or don't use Google? `sources.md` has the full reading list, organized by topic, and you can rebuild the notebook from it in a couple of minutes.

## An honest word

No setup is bulletproof. Prompt injection in particular has no complete technical fix today — the people who study it hardest say so plainly. This repo lowers your risk a lot and makes the failures you can't prevent survivable. It does not make you invincible, and anyone who tells you a config file does is selling something. When in doubt, slow down and keep a human in the loop for anything you can't undo.

## License

[MIT](LICENSE). The written material (this README, `CLAUDE.md`, `sources.md`) is also available under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). Use it, fork it, adapt it for your team.
