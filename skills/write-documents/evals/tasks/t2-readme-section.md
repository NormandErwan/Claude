Our repo `shared-config` gets a new mechanism, and its README needs a section for it. Write only that section, in English, to `outputs/readme-section.md`. The design note below will live in the repo at `docs/design/2026-11-20-config-sync.md`. Readers of the README are developers in the consumer repositories who want to turn the feature on.

The design note:

---

# Config sync - design note (2026-11-20)

## Problem

Twelve consumer repositories copy `lint/`, `ci/` and `editor/` from `shared-config` by hand. Copies drift: an audit on 2026-11-18 found 9 of the 12 behind by at least one release, and 3 with local edits nobody remembered making.

## Mechanism

A consumer adds a `.shared-config.toml` file at its root:

```toml
version = "v4"          # a tag of shared-config, or "latest"
paths = ["lint", "ci"]   # which folders to sync; default: all three
```

On every `make setup` and in CI, `scripts/sync.sh` from the consumer's vendored copy of shared-config runs these steps:

1. It reads `.shared-config.toml`. A missing file means the repo has not opted in: the script exits 0 and does nothing.
2. It resolves `version`: a tag is used as is; `latest` resolves to the newest tag through `git ls-remote --tags`.
3. It downloads the tarball for that tag from the internal Git server, checks its SHA-256 against `checksums.txt` signed by the platform team's key, and refuses to continue on a mismatch.
4. For each folder in `paths`, it compares every file with the consumer's copy. A file the consumer changed locally (detected against the hash recorded in `.shared-config.lock` at the previous sync) is not overwritten: the script prints its path and exits 3, so CI fails visibly instead of silently discarding the change.
5. Otherwise it overwrites the folder and writes the new hashes to `.shared-config.lock`, which the consumer commits.

## Alternatives rejected

- Git submodules: half the consumers already had submodule pain with the `proto` repo; reviewers could not see the pulled changes in a PR.
- A package registry: `editor/` and `ci/` are not code packages, and the registry needs a publish step the platform team does not want to own.

## Rollout

Pilot on `billing-api` and `search-ui` in week 48, then the other ten repos. Pinning a tag is recommended; `latest` is for the pilot only.

## Open questions

- Should exit code 3 offer an `--accept-local` flag that keeps the local file and records it in the lock?

---

For the README section: the repo's convention is that a README says what a mechanism does and how to turn it on, and links to the design notes for how it works.
