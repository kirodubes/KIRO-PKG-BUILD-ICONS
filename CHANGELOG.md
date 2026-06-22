# Changelog

## 2026.06.20

### What Changed
- Added two missing Surfn icon-theme package recipes so every `surfn*` source folder in `~/EDU` now has a corresponding package in `nemesis_repo`:
  - `surfn-plasma-dark-breeze-icons-git`
  - `surfn-plasma-dark-qogir-icons-git`
- Wired both into the flow tooling (`~/.bin/flow-generator/flows.manifest` + regenerated `flow-surfn-plasma-dark-breeze` and `flow-surfn-plasma-dark-qogir`).
- Brought the two `~/EDU` source folders up to the standard template by adding `up.sh`/`setup.sh` (they previously shipped only the legacy `git-v1.sh`/`setup-git-v5.sh`), which the flow's push step requires.
- The `surfn-meta` folder was intentionally left out (deleted per Erik).

### Technical Details
- `PKGBUILD`s modeled exactly on `surfn-plasma-dark/PKGBUILD`: `pkgver=26.06 pkgrel=01`, `arch=any`, source `Surfn::git+https://github.com/erikdubois/<repo>.git`, `package()` copies `usr/share/icons/*` into the pkgdir. The `replaces=()` line from the template was dropped since these are new packages, not renames.
- Each recipe dir got the shared `build.sh` (byte-identical across all icon recipes).
- `up.sh`/`setup.sh` copied from `surfn-qogir` (generic templates, no package-specific content — verified identical by md5sum).

### Files Modified
- `surfn-plasma-dark-breeze/PKGBUILD` (new)
- `surfn-plasma-dark-breeze/build.sh` (new)
- `surfn-plasma-dark-qogir/PKGBUILD` (new)
- `surfn-plasma-dark-qogir/build.sh` (new)
- `~/.bin/flow-generator/flows.manifest` (+2 entries)
- `~/.bin/flow-surfn-plasma-dark-breeze`, `~/.bin/flow-surfn-plasma-dark-qogir` (regenerated)
- `~/EDU/surfn-plasma-dark-breeze/{up.sh,setup.sh}`, `~/EDU/surfn-plasma-dark-qogir/{up.sh,setup.sh}` (new)
