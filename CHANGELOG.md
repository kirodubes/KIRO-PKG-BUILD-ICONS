# Changelog

## 2026.06.23

### What Changed
- Split the monolithic `surfn-mint-y-icons-git` into **one package per colour**, and brought the
  Surfn Mint-X family up to full colour coverage — both sourced fresh from the LinuxMint upstreams
  (`linuxmint/mint-y-icons`, `linuxmint/mint-x-icons`) so newly-added upstream colours come along.
  - **Mint-Y (12):** aqua, blue, cyan, grey, navy, orange, pink, purple, red, sand, teal, yaru
    (matches upstream — drops the discontinued brown/yellow, adds the new cyan/navy/yaru).
  - **Mint-X (11):** aqua, blue, brown, grey, orange, pink, purple, red, sand, teal, yellow
    (all regenerated from upstream; the pre-existing `surfn-mint-x-grey` was refreshed in place).
- Added two meta packages: `surfn-mint-y-meta` (12 deps) and `surfn-mint-x-meta` (11 deps).
- Repointed `surfn-icons-meta` from `surfn-mint-y-icons-git` + `surfn-mint-x-grey-icons-git`
  to the two new metas.
- Wired all 23 colours + 2 metas into the flow tooling (manifest + regenerated `flow-surfn-mint-*`).
- New generator `~/.bin/scaffold-surfn-mint.sh` produces every EDU repo + PKG-BUILD recipe from the
  upstream clones (rerunnable; surfn-ifies each `index.theme`).
- **Licence corrected to GPL3** across all new repos (PKGBUILD `license=('GPL3')` + real GPL-3 LICENSE
  text) to match the LinuxMint upstream `debian/copyright` (`Files: * → GPL-3+`) and the old combined
  package — replacing the BY-NC-SA carried over from the grey template. The pre-existing
  `surfn-mint-x-grey` repo was also switched from BY-NC-SA to GPL3 for family consistency.
- **Clean upgrade swap:** each Mint-Y per-colour package declares `conflicts=('surfn-mint-y-icons-git')`
  (they take over the same `/usr/share/icons/Surfn-Mint-Y-*` dirs the combined package owns); the
  Mint-Y meta also carries `replaces`/`conflicts`/`provides=('surfn-mint-y-icons')` so `-Syu` swaps
  combined → meta + per-colour atomically. (Mint-X has no overlap, so no conflict metadata.)
- **ATT updated** to point its Surfn Mint-Y checkbox at `surfn-mint-y-meta` (was `surfn-mint-y-icons-git`).
- **Meta build.sh fixed to auto-bump pkgrel.** The meta dirs (`surfn-mint-y-meta`, `surfn-mint-x-meta`,
  `surfn-meta`) carried the old simple `build.sh` whose `main()` only calls `build_package` — no
  `bump_version` — so rebuilds shipped the *same* version and pacman wouldn't upgrade them (this is why
  `surfn-icons-meta` shipped twice at `26.06-02` and `-Syu` failed to swap the combined). Swapped in the
  modern bumping `build.sh` (identical to the colour packages); `bump_version` works for `source=()` metas.
  Also fixed `flow-template.sh` so meta flows skip the push step when there's no source repo.
- **Tela folder colours split out (15 packages).** Extended the per-colour model to Tela: regenerated
  `surfn-tela` (standard) and added 14 colour packages — black, blue, brown, dracula, green, grey,
  manjaro, nord, orange, pink, purple, red, ubuntu, yellow — from the installed `tela-icon-theme`
  (`/usr/share/icons/Tela[-<colour>]`), **folders (places) only**, inheriting Surfn. Added
  `surfn-tela-meta` (15 deps) and repointed `surfn-icons-meta` `surfn-tela-icons-git → surfn-tela-meta`.
  All 15 repos created/pushed under `github.com/erikdubois`; generator `~/.bin/scaffold-surfn-tela.sh`,
  publisher `~/.bin/publish-surfn-tela.sh`, flows wired (+16 lines). Tela's size-first layout preserved
  (`<size>/places` + @2x/@3x symlinks); cross-context symlinks dereferenced → 0 broken links.
  `surfn-tela` also relicensed BY-NC-SA → GPL3 to match the Tela upstream.
- **Family batch build scripts.** Added `~/.bin/flow-surfn-family <mint-y|mint-x|tela>` + thin wrappers
  `flow-surfn-mint-y-all`, `flow-surfn-mint-x-all`, `flow-surfn-tela-all`. Each pushes every source repo
  in the family, builds every package, then publishes the nemesis repo **once** (instead of re-signing /
  rebuilding the db per package) — collapsing ~80 individual builds into three commands. Metas are
  build-only (push skipped, no source repo).
- **neo-candy folder catalogue (full mirror, 58 + 4 metas).** Mirrored the entire Surfn folder catalogue
  onto the `neo-candy-icons` base: 58 `neo-candy-<set>` packages (mint-x 11, mint-y 12, tela 15, + 20
  curated singles) reusing the surfn payloads with `Inherits=neo-candy-icons,hicolor`,
  `depends=('neo-candy-icons-git')`, licence reused per-set from the surfn counterpart. Added family
  metas `neo-candy-mint-y-meta` (12), `neo-candy-mint-x-meta` (11), `neo-candy-tela-meta` (15) and the
  overall `neo-candy-icons-meta` (base + 3 family metas + 20 singles). All 58 repos created/pushed under
  `github.com/erikdubois` (icons are personal, not kirodubes). Tooling: `~/.bin/scaffold-neo-candy.sh`,
  `publish-neo-candy.sh`, flows wired (+63), per-group batchers (core `flow-neo-candy-family <group>`):
  `flow-neo-candy-mint-y-all` (12), `-mint-x-all` (11), `-tela-all` (15), `-singles-all` (20),
  `-metas-all` (4), and `flow-neo-candy-all` (62). Variant groups exclude metas so they can be built
  first; build `metas` last.
- **Papirus folder colours — any-colour script + full build (both families).** New reusable generator
  `~/.bin/make-papirus-colour <surfn|neo-candy> <colour>` recolours the real Papirus folder icons the
  way `papirus-folders` does (generic `folder*.svg` ← `folder-<colour>-*` variants, symlinks
  dereferenced → 0 broken), folders-only, inheriting the base. `~/.bin/make-papirus-all` builds all 25
  canonical Papirus colours × {surfn, neo-candy} = 50 packages; the **old bespoke `surfn-papirus-blue/grey`
  were replaced** with fresh real-Papirus recolours; the **custom `casablanca`** (not a Papirus colour)
  was backed up to `~/EDU/_backups/papirus-2026.06.23/` and kept untouched. Added `surfn-papirus-meta`
  and `neo-candy-papirus-meta` (26 deps each, incl. casablanca); repointed `surfn-icons-meta` /
  `neo-candy-icons-meta` from the three papirus singles to the papirus metas. Promoted papirus to a
  family in the batchers (`flow-surfn-papirus-all`, `flow-neo-candy-papirus-all`; excluded from
  neo-candy `singles`, now 17). All 52 repos created/pushed under `github.com/erikdubois`;
  publisher `~/.bin/publish-papirus.sh`, flows wired (+54). Papirus is GPL-3.0. All variants are **folders-only**: colour families were so by
  construction; the 20 singles started as full surfn mirrors then were trimmed (deref cross-context
  symlinks → drop non-places contexts → rewrite each index.theme to places-only) and re-pushed.
  0 broken symlinks across all 58.

### Technical Details
- Per colour: theme dir renamed `Mint-{X,Y}-<Colour>` → `Surfn-Mint-{X,Y}-<Colour>`; `index.theme`
  patched to `Name=Surfn Mint-{X,Y}-<Colour>` and `Inherits=Surfn,Adwaita,gnome,hicolor`
  (so it inherits the base Surfn set → `depends=('surfn-icons-git')`). Only the sparse `places/`
  folder-colour icons ship; `icon-theme.cache` is dropped (pacman hook rebuilds it). Mint-X variants
  carry many relative folder symlinks — preserved verbatim by `cp -r` (351 in each, none broken).
- PKGBUILDs modelled on `surfn-mint-x-grey/PKGBUILD`; `build.sh` copied byte-identical.
- All 23 colour repos created + pushed under `github.com/erikdubois` via `~/.bin/publish-surfn-mint.sh`
  (gh authed as erikdubois; pushes go over the default `github.com` SSH key). The combined recipe was
  moved to `~/KIRO-PKG-BUILD-ICONS-RETIRED/surfn-mint-y-icons-git` so the batch builder won't rebuild it.
- REMAINING (Erik's build/publish): run `2-build-all-packages.sh` (builds the 23 colours + 2 metas
  into nemesis), then retire the old combined from nemesis:
  `repo-remove ~/EDU/nemesis_repo/x86_64/nemesis_repo.db.tar.gz surfn-mint-y-icons-git` +
  delete its `.pkg.tar.zst(.sig)`. ATT (`archlinux-tweak-tool`) also needs a rebuild for the icons change.

### Files Modified
- `~/.bin/scaffold-surfn-mint.sh` + `~/.bin/publish-surfn-mint.sh` (new); `~/.bin/flow-generator/flows.manifest` (+25 lines) and 25 regenerated `flow-surfn-mint-*`.
- 23 new `surfn-mint-{y,x}-<colour>/` recipe dirs; `surfn-mint-y-meta/`, `surfn-mint-x-meta/` (new); `surfn-meta/PKGBUILD` (deps repointed).
- 23 `~/EDU/surfn-mint-{y,x}-<colour>/` source repos (grey refreshed + relicensed GPL3 in place).
- ATT: `icons.py`, `icons_gui.py`, `data/nemesis_packages.txt` (Mint-Y checkbox → `surfn-mint-y-meta`).

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
