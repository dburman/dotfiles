# TODO — open decisions

Companion to [MODERNIZATION.md](MODERNIZATION.md), which is the full audit. This file holds only
what still needs a decision from you.

**Done and not revisited here:** `.gitignore` for `secret.zsh`, runtime `EDITOR` resolution,
the duplicate-`compinit` fix, and the antigen → antidote migration.

---

## 1. Rust CLI utilities — pick which to adopt

None of these are installed today except `ripgrep`. Everything below is a single static binary with
no runtime, which is the property that matters for you: identical behavior across macOS, Alpine,
Ubuntu, and PopOS. Most of the per-OS branching in `home/.zsh/alias.zsh` and
`home/.zsh/dircolors.zsh` exists purely to paper over GNU vs BSD vs busybox differences that these
tools don't have.

Ordered by how much they'd actually clean up in *this* repo, not by general popularity.

| Tool | Replaces | Concrete payoff here |
|---|---|---|
| **sd** | `sed -i` | Highest-value one. Your `replace()` function is written out **three times** in `alias.zsh` — once each for Darwin, Linux, FreeBSD — solely because BSD/macOS `sed -i` needs a backup-suffix argument (`-i ''`) and GNU doesn't. `sd` is identical everywhere: three copies collapse to one. |
| **eza** | `ls` | Collapses most of `dircolors.zsh`, whose entire `gls` / `ls -FqN` / `ls -GF` dance exists because GNU, BSD, and busybox `ls` differ. Also fixes the bug in §3 below. Adds git-status columns and `--tree`. |
| **bat** | `cat` | Syntax highlighting and paging. Doubles as `MANPAGER`, which would let you drop the `colored-man-pages` oh-my-zsh plugin. |
| **fd** | `find` | One syntax instead of GNU vs BSD `find`, respects `.gitignore`. |
| **zoxide** | `cd` | `z proj` jumps to frequently-used dirs. Your old `antigen.zsh` had `rupa/z` commented out; zoxide is its successor. |
| **delta** | diff pager | Syntax-highlighted git diffs. Would replace the current `alias diff=vimdiff` fallback in `alias.zsh`, which is actively harmful — see §3. |
| **btop** | `top` | Already installed on the Mac, but `alias.zsh` only checks `glances` then `htop`, neither of which is present, so the alias never fires and you get system `top`. |
| **atuin** | history | The one that's genuinely about multi-machine: your four boxes currently keep four disconnected 10k-line histories. Optional end-to-end-encrypted sync between them. |
| **yazi** | ranger | Your nvim config uses `francoiscabrol/ranger.vim`, which shells out to Python ranger with noticeable startup lag. |
| **dust / duf / procs / hyperfine / tokei** | du / df / ps / — / — | Nice-to-haves, no cleanup value in this repo. Adopt only if you want them. |

Install, roughly:

```bash
brew install sd eza bat fd zoxide git-delta btop atuin yazi
```

```bash
sudo apt install bat fd-find    # Ubuntu/PopOS: binaries are batcat/fdfind, needs aliasing
```

```bash
sudo apk add sd eza bat fd zoxide delta btop    # Alpine: most are in community/
```

Alpine and older Ubuntu lag on some of these; `cargo install` is the fallback. Note the Debian
naming trap: `bat`→`batcat`, `fd`→`fdfind`, which needs its own alias branch — mildly ironic given
the goal is removing per-OS branching.

**Decide:** which subset to adopt. My suggestion is `sd` + `eza` + `bat` + `fd` + `delta` first,
since those four are the ones that actually delete code from this repo.

---

## 2. Future consideration — moving off oh-my-zsh

Antidote solved the maintenance problem (antigen was abandoned in 2019; antidote is current). These
two options are about shedding **oh-my-zsh itself**, which is a separate question and not urgent.

Read the tradeoff honestly: neither buys you much beyond a lighter, more predictable startup. The
cost is real and lands on daily muscle memory.

### Option 2 — sheldon + starship (drop oh-my-zsh entirely)

- **sheldon** (Rust, TOML config) replaces antidote as the plugin loader.
- **starship** (Rust) replaces the `doitchbig` theme.
- oh-my-zsh goes away completely — no more ~18 MB clone per machine.

What you'd lose and have to replace by hand:

- **197 git aliases + 18 functions** (`gst`, `gco`, `gcm`, `gd`, `gcb`, …). Your own `alias.zsh`
  defines only ~23 aliases; the rest come from oh-my-zsh's git plugin. This is the part people
  underestimate — you'd notice it on day one.
- `colored-man-pages` → replaced by setting `bat` as `MANPAGER`.
- `command-not-found` → needs a replacement (the Homebrew handler is present on the Mac and does
  work today).
- `ll`, `la`, `l`, `..`/`...`, `1`–`9`, `md`, `rd`, colored `grep`/`egrep`/`fgrep`, `history` —
  all from oh-my-zsh's `lib/`.

The prompt itself ports cleanly. `doitchbig` maps onto starship one-for-one:

| doitchbig element | starship module |
|---|---|
| green `user@host`, red as root | `username` + `hostname`, `show_always = true` |
| green 12-hour `[HH:MM:SS]` | `time`, `disabled = false` |
| cyan 3-component path | `directory`, `truncation_length = 3` |
| yellow `[branch]`, `!` dirty / `✓` clean | `git_branch` + `git_status` |
| `➜` green, red on failure | `character` — this is starship's default |
| two-line layout | starship's default |

### Option 3 — sheldon, keep oh-my-zsh for the theme

Swap the loader to sheldon but keep loading oh-my-zsh for `git_prompt_info` and the git plugin, so
`doitchbig` and all 197 aliases survive untouched.

Rust loader, no prompt rewrite, nothing visibly changes. But you keep carrying the oh-my-zsh
dependency, so it's a middle ground rather than a clean break. Honestly: if you're not bothered by
oh-my-zsh, this buys close to nothing over the antidote setup you now have — antidote is
maintained, and swapping one healthy loader for another is churn.

**Decide:** whether shedding oh-my-zsh is a goal at all. If it isn't, close this section; the
current setup is fine and has no known problems.

---

## 3. Small fixes found along the way

Each is independent and low-risk.

- ~~**`ls` loses its `-F` flag.**~~ — **FIXED.** `dircolors.zsh` was sourced at `.zshrc:5`, before
  the plugin block, so oh-my-zsh's `lib/theme-and-appearance.zsh` overrode its `ls` alias. Now
  sourced after the plugin block, so the file's intent wins. This affected **all four machines**,
  not just macOS: omz set `ls -G` on Darwin (`:65`) and `ls --color=tty` on Linux (`:73`), so
  Linux was also losing `-q` and `-N`.

  Verified on macOS: `ls='ls -GF'`, directories/symlinks/executables classify again, and omz's
  `LSCOLORS` palette is preserved. Not verified on Linux from here — worth a glance next time
  you're on Alpine/Ubuntu that `ls` is `ls -FqN --color=auto`.

  Note for future edits: `DISABLE_LS_COLORS=true` is *not* the right knob. omz's early return is
  at `:24` but `export LSCOLORS` happens at `:27`, so setting it restores `-F` at the cost of the
  color palette.
- **`alias diff=vimdiff`** (`alias.zsh`) fires whenever `colordiff` is absent, which is every
  machine right now. It breaks any non-interactive diff by launching a full-screen editor —
  this bit us during this session. Replace with `delta`, or drop the fallback.
- **`gup*` aliases are gone.** Upstream oh-my-zsh renamed them in commit `207d29b7`
  (*"fix(git)!: standardize `git pull --rebase` aliases"*, a deliberate breaking change). Your
  antigen copy was pinned to Aug 2025 and never saw it. Mapping: `gup`→`gpr`, `gupv`→`gprv`,
  `gupa`→`gpra`, `gupav`→`gprav`, `gupom`→`gprom`, `gupomi`→`gpromi`.
- **`~/.antigen` is orphaned**, 18 MB, nothing references it. Left in place deliberately as the
  rollback path for the antidote migration. Delete once you're satisfied things work.
- **Unverified: does the git branch actually show in your prompt?** oh-my-zsh wraps
  `git_prompt_info` in `lib/async_prompt.zsh`, so it reads from `_OMZ_ASYNC_OUTPUT`, populated by a
  background job on `precmd`. That never fires in a scripted shell, so every harness I tried
  returned empty — including a pty. Confirmed the **old antigen config returns the same empty
  value**, so this is pre-existing and unchanged by the migration, but glance at your prompt in a
  real terminal: you should see `[master] !` when dirty, `[master] ✓` when clean. If it's blank,
  it's been blank for a while and is worth a separate look.
- **Broken submodule gitlink.** `home/.vim/bundle/vundle` is committed as a gitlink (mode 160000)
  with **no `.gitmodules`**, so `git submodule update --init` — which your own `gp` alias runs —
  has nothing to resolve it against. Leftover from Vundle, long since replaced by vim-plug.
