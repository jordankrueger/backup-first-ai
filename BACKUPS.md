# Setting up backups

The README says everything the AI touches should be backed up in a way it can't delete. This page shows how to do that for the things people usually forget: your computer, a client's website, your cloud office account, and the databases and servers behind them.

Prices and features were checked against each vendor's own pages on 15 October 2026. They change often, so check again before you buy.

## The rule to aim for

CISA's version of the 3-2-1 rule: keep **3 copies** of important files, on **2 different types of storage** (say, a hard drive and the cloud), with **1 copy off-site**. ([CISA](https://www.cisa.gov/audiences/small-and-medium-businesses/secure-your-business/back-up-business-data))

With AI agents in the picture, add one more condition: **at least one copy has to sit where the agent's logins can't delete it.** If the agent can reach your backup, a bad command can wipe the original and the backup together.

## Your computer

Use two layers: a local copy for quick restores and a cloud copy for when the laptop is lost or stolen.

- **Mac:** Time Machine is part of macOS. It backs up to an external drive or a disk on your network. ([Apple](https://support.apple.com/guide/mac-help/back-up-your-mac-with-time-machine-mh35860/mac))
- **Windows:** File History backs up your files to an external drive or a network location. ([Microsoft](https://support.microsoft.com/en-us/windows/backup-and-restore-with-file-history-7bf065bf-f1ea-0a78-c1cf-7dcf51cc8bfc)) The separate Windows Backup app saves to OneDrive and only works with a personal Microsoft account, not a work or school one. ([Microsoft](https://support.microsoft.com/en-us/windows/backup-and-restore-in-windows-352091d2-bb9d-3ea3-ed18-52ef2b88cbef))
- **Cloud copy:** Backblaze Computer Backup is $99 per computer per year. It keeps 30 days of old and deleted versions by default. One year of history is free to turn on, and keeping versions forever costs extra. ([pricing](https://www.backblaze.com/cloud-backup/pricing), [version history](https://www.backblaze.com/cloud-backup/features/extended-version-history))

Turn on the one-year history. Thirty days is shorter than it sounds when nobody notices a missing file for six weeks.

## A client's website

Most hosts back up your site, but those backups live with the host and are tied to your hosting account. On SiteGround, deleting the site deletes its backups too. ([SiteGround](https://www.siteground.com/kb/backup-service)) WP Engine has no automatic way to export its own backups, and it says your own backups should never be stored on the same server as the site. ([WP Engine](https://wpengine.com/support/restore/)) Keep the host's backups, and keep a second copy somewhere else.

- **WordPress:** the free UpdraftPlus plugin can send scheduled backups to Google Drive, Dropbox or S3-compatible storage. Sending them to Backblaze B2 takes Premium, which starts at $70 a year. ([plugin](https://wordpress.org/plugins/updraftplus/), [pricing](https://teamupdraft.com/updraftplus/pricing/)) Jetpack VaultPress Backup is the hands-off option at $9.95 a month regular price, with a cheaper first year. ([Jetpack](https://jetpack.com/upgrade/backup/))
- **Static sites:** if the site is built from a git repository, the repository is most of your backup. Keep a copy that doesn't depend on a single GitHub login, and export the domain's DNS records once a year.
- **Anything with a database:** dump the database nightly and send the dump off the server, using the storage described below.

## Google Workspace and Microsoft 365

These services keep your data available. Getting back what someone deleted months ago is your job. Google says outright that Vault "isn't designed to be a backup or archive tool." ([Google](https://knowledge.workspace.google.com/vault/getting-started/google-vault-faq))

CubeBackup is a self-hosted backup for both Google Workspace and Microsoft 365. It costs $5 per user per year, or $2 for nonprofits and schools. ([CubeBackup](https://www.cubebackup.com/pricing))

## Putting a copy out of reach

This is the step that turns a disaster into an inconvenience. Two ways to do it, and you can use both:

1. **Storage that refuses deletes.** Backblaze B2 (from $6.95 per TB per month) and Amazon S3 both offer Object Lock, which stops anyone from deleting or overwriting a file until a date you choose. In compliance mode, nobody can remove the lock, not even the account owner. ([B2 pricing](https://www.backblaze.com/cloud-storage/pricing), [B2 Object Lock](https://www.backblaze.com/docs/cloud-storage-object-lock), [S3 Object Lock](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock.html))
2. **A key that can add files but not delete them.** B2 lets you create application keys with only the permissions you pick, so the machine doing the backup can write new files and still has no delete permission. ([B2 keys](https://www.backblaze.com/docs/cloud-storage-application-keys))

For servers and databases, [restic](https://restic.readthedocs.io/en/stable/) is a free, open-source tool that encrypts backups and sends them to B2 or S3. Store its password somewhere other than the server. Without the password, the backup can't be read, by you or anyone else.

Never give the AI agent the login for your backup storage. If the agent's environment can run the backup, give it the write-only key and nothing more.

## Test the restore

A backup you've never restored from is a guess. Once a quarter, pick one file, one site or one database table and actually bring it back. Time it, and write down the steps. On the bad day, you'll be glad you didn't have to work them out.

## Have Claude help you set it up

Paste this into Claude Code (or any Claude chat) and answer its questions:

```text
Help me set up backups using the "3-2-1, with one copy out of reach" approach.

1. Interview me first. Ask what I need to protect: computers (Mac or Windows),
   websites (which host and platform), Google Workspace or Microsoft 365,
   databases or servers, and anything else. Ask what backups I already have.
2. Make a table: each thing, its current backup, where that backup lives, and
   whether a mistake or a compromised login on my machine could delete it.
3. Recommend the simplest fix for each gap, with the official setup docs for
   each tool. Check current prices on the vendors' own pages; don't quote them
   from memory.
4. Walk me through one item at a time. Explain each step before I do it.

Rules: Don't delete, overwrite or move any existing files or backups. Don't
create or ask me for storage credentials that can delete backups; use
write-only keys or Object Lock where possible. Never ask me to paste a
password or key into the chat. End with a restore test for each item.
```

## What this page doesn't cover

Phones, email archives you're legally required to keep, and full-disk images for rebuilding a machine from scratch. Each of those needs its own plan.
