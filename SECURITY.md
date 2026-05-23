# Security policy

This repository contains *advice and example configuration*, not running software, so the usual "vulnerability" model doesn't quite fit. But security feedback is exactly what this project wants.

## Reporting a problem

- **A guardrail here is wrong, unsafe, or could backfire?** That is the most valuable report we can get. [Open a private security advisory](https://github.com/jordankrueger/backup-first-ai/security/advisories/new) if it's sensitive, or a normal issue if it isn't.
- **A general "is this safe?" question?** Use [Discussions](https://github.com/jordankrueger/backup-first-ai/discussions).

## Scope and honesty

These defaults reduce risk; they do not eliminate it. Prompt injection in particular has no complete technical fix today. Treat this pack as one layer, keep real backups out of the agent's reach, and keep a human in the loop for anything you can't undo. See the README's honest-limits section for the full picture.
