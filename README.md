# Claude Code guardrails

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
- **`sources.md`** — the research these defaults are drawn from, so you can check the reasoning yourself.

## Quick start

1. **Copy `CLAUDE.md`** into the top folder of your project. Claude Code reads it automatically.
2. **Turn on the sandbox.** In Claude Code, run `/sandbox` and choose a mode. On a Mac there is nothing to install. (See the [sandbox docs](https://code.claude.com/docs/en/sandboxing) for Linux/WSL setup.)
3. **Borrow from `settings.example.json`.** Open it, read the comments in this README below, and copy the parts that fit into your own `.claude/settings.json`. Adapt before using — do not paste blindly.
4. **Do the "out of its reach" checklist** below. This is the part that actually saves you.

## Soft guardrails vs. hard guardrails

This is the most important thing to understand, and most guides skip it.

- **`CLAUDE.md` rules are soft.** The agent reads them and almost always follows them. But a cleverly worded file or web page can sometimes talk it out of them. Think of these as a good employee handbook: followed in good faith, not physically enforced.
- **Permission rules and the sandbox are harder.** These are two different mechanisms, and it helps to know which is which:
  - *Permission rules* (the `permissions` block in settings) are enforced by Claude Code itself, before it uses one of its own tools. A `deny` rule stops Claude from reading or editing what you've blocked.
  - *The sandbox* is enforced by your operating system, on the shell commands the agent runs and anything those commands start. It is the stronger of the two, because it holds regardless of what the model decided to do.
  - They cover different things, so use both. One consequence worth knowing: blocking a file with a permission rule stops Claude's *own* reader, but a shell command like `cat secrets.txt` is governed by the *sandbox* instead. That's exactly why the credential note further down matters.
- **The backup is the hardest guardrail of all**, because it lives somewhere the agent has no access to at all.

None of these is perfect. The soft rules prevent everyday mistakes; the permission and sandbox limits contain a bad day; the backup makes the worst day recoverable. Layer all of them.

## The "out of its reach" checklist

The whole thesis, made concrete. None of these are things you tell the AI. They are things you put beyond it.

- [ ] **A backup the agent cannot delete.** Versioned and offsite or append-only — somewhere the credentials on this machine cannot reach. If your "backup" uses the same login the agent can use, it is not a backup from the agent's point of view.
- [ ] **Least-privilege credentials.** Give the agent's environment the narrowest access that still gets the job done. Don't hand it a key that can wipe production when it only needs to read one folder.
- [ ] **Sandbox on.** Filesystem and network isolation enforced by the OS, for the commands the agent runs. See `settings.example.json`. Note: if the sandbox can't start, Claude Code warns you and runs *without* it unless you tell it to fail closed (see below).
- [ ] **Spending caps.** Put a hard cap on any API key the agent can use, so a runaway loop costs you a coffee, not a mortgage payment.

## Block the agent from reading your credentials

One specific gotcha worth calling out: even with the sandbox on, Claude Code's *default* still lets commands **read** sensitive files like `~/.ssh` and `~/.aws/credentials`. It only blocks *writes* outside your project by default. If you keep cloud or SSH keys in the usual places, add them to `denyRead` (see `settings.example.json`) so a tricked agent can't read them and send them somewhere.

**Tradeoff to know:** blocking `~/.ssh` and `~/.aws` can also break legitimate tools that need those keys — pushing to git over SSH, the AWS or Google Cloud command-line tools, some deploy scripts. That is the point (those are exactly the keys you don't want a tricked agent reading), but if a normal command suddenly fails, this is the first place to look. Unblock the specific path you need and leave the rest closed.

**Want it to fail closed?** By default, if the sandbox can't start, Claude Code warns you and runs commands *without* it. To make that a hard stop instead, add `"failIfUnavailable": true` inside the `sandbox` block, and `"allowUnsandboxedCommands": false` to remove the agent's ability to retry a blocked command outside the sandbox. These are stricter and safer, but they can also get in your way — turn them on once the basics feel comfortable.

## The companion notebook

All of the research behind these defaults is loaded into a public NotebookLM you can ask plain-language questions of — *"why does this rule exist?"*, *"is what I'm about to do risky?"* — instead of reading every source yourself.

**[Open the companion notebook →](https://notebooklm.google.com/notebook/221cbc78-1703-4dab-ae80-f9141a8c1a5f)** (a free Google account is needed to view it.)

Prefer your own copy, or don't use Google? `sources.md` has the full reading list, organized by topic, and you can rebuild the notebook from it in a couple of minutes.

## An honest word

No setup is bulletproof. Prompt injection in particular has no complete technical fix today — the people who study it hardest say so plainly. This repo lowers your risk a lot and makes the failures you can't prevent survivable. It does not make you invincible, and anyone who tells you a config file does is selling something. When in doubt, slow down and keep a human in the loop for anything you can't undo.

## License

[MIT](LICENSE). Use it, fork it, adapt it for your team.
