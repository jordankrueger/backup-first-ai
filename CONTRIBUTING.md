# Contributing

Thanks for helping make AI coding agents safer to adopt. This project is small on purpose, and contributions that keep it small, accurate, and readable are very welcome.

## Ways to help

- **Found a rule that's wrong or out of date?** Open an issue using the "Incorrect or outdated guardrail" template. Claude Code changes fast, and a stale instruction is worth fixing quickly.
- **Have a guardrail to suggest?** Open an issue using the "Suggest a guardrail" template, or open a pull request.
- **Just have a question?** Use [Discussions](https://github.com/CampaignHelp/backup-first-ai/discussions) rather than an issue.

## The bar for changes

This pack is aimed at people who are *not* security engineers. So:

- **Plain language.** If a sentence needs a security background to parse, rewrite it.
- **Accurate over impressive.** Don't oversell what a config can do. Cite a source for any security or product claim (see `sources.md` for the style).
- **Don't break beginners.** Settings that could lock someone out of their own tools by default belong behind a clearly labeled "stricter" note, not in the base example.
- **No telemetry, no dependencies.** This stays a handful of plain files anyone can read top to bottom.

## Pull requests

Keep them focused and small. Explain what changed and why in the description. There's no build step and no test suite — just clear, correct prose and config.
