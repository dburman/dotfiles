# Dotfiles Review

Audit of `~/git/dotfiles` against the stated setup: multi-machine sync across Arch, Ubuntu,
PopOS, and macOS, with a preference for zsh, neovim, and Rust-based tooling.

Repo state at time of review: 24 files, last substantive commit `bad0fb3` (2024-12-13).
Findings marked **verified** were reproduced on this machine (macOS arm64, nvim 0.12.4).

---

## List 1 — Out of date / should be cleaned up

### Critical

1. **`sync2git.sh` will copy `~/.zsh/secret.zsh` into the repo, and there is no `.gitignore`.**
   `sync2git.sh:2` does `cp -R ~/.zsh ~/git/dotfiles/home`, which copies *everything* in
   `~/.zsh` — including `secret.zsh`. **Verified:** `~/.zsh/secret.zsh` exists (395 bytes) and
   the repo has no `.gitignore` at all. It is not yet tracked, but the next `sync2git.sh` run
   drops it in the working tree, where a `git add -A` commits it. Add a `.gitignore` with
   `secret.zsh` (and `**/plugged/`, `.antigen/`) before the next sync.

2. **`EDITOR` points at a binary that does not exist.** `home/.zshrc:17` hardcodes
   `/usr/local/bin/mvim` on macOS. **Verified:** that path is absent on this machine, and
   `/usr/local/bin` is the Intel Homebrew prefix — this box is arm64 with `/opt/homebrew`.
   Commit `bad0fb3` was titled "switch mac from vim to nvim" but `EDITOR` was never updated.
   `home/.zshrc:20` has the mirror problem: hardcoded `/usr/bin/nvim` breaks under Homebrew-on-Linux
   or nix. Use `export EDITOR=$(command -v nvim || command -v vi)` for both branches.

3. **The repo and the deployed files have silently diverged.** **Verified:** `~/.zshrc` was last
   edited 2026-07-29, but `home/.zshrc` was last committed **2024-03-25** — the local machine had
   three fixes (mvim removed, `neofetch`→`fastfetch`, `alias docker=podman`) that never made it
   back into git. Two are now ported; `alias docker=podman` is left out deliberately, since it
   would break any machine that has real docker — decide whether to guard it or keep it local.
   Running `sync2home.sh` before `sync2git.sh` would have destroyed all three without warning.
   This is the concrete argument for list 2, item 1.

   Note also that the local hand-fix replaced `/usr/local/bin/mvim` with a hardcoded
   `/usr/bin/nvim`, which **also does not exist on this machine** (nvim is at
   `/opt/homebrew/bin/nvim`) — so `$EDITOR` has been pointing at nothing either way. Now resolved
   at runtime.

4. **Alpine specifics worth checking.** Alpine is handled for `updateos` (`alias.zsh:30-32`), so
   there's no gap there — but two things are worth verifying on an actual Alpine box:
   - `dircolors.zsh` falls to the generic branch and aliases `ls -FqN --color=auto`. Alpine's `ls`
     is busybox, not GNU coreutils. Commit `64b819e` already had to strip `-N` for FreeBSD for
     exactly this reason; confirm busybox accepts `-FqN` or add an Alpine branch.
   - `updateos` hardcodes `sudo apk`. Alpine images frequently run as root with no `sudo`
     installed (and `doas` is the Alpine convention), so the alias may fail there.
   - `checks.zsh` defines `HAS_BREW`/`HAS_APT` but no `HAS_APK`, which is a loose end if anything
     later branches on it.

### Stale tooling

4. ~~**Antigen is dead upstream.**~~ — **RESOLVED**, migrated to antidote. The installed antigen
   was last committed **2019-12-22**; antidote's HEAD was five days old at migration time.
   `home/.zsh/antigen.zsh` was replaced by `antidote.zsh` + `zsh_plugins.txt`.

   Verified at parity: 251 aliases, `ll`/`gst`/`gpr` present, `gp` still `git pull` (not oh-my-zsh's
   `git push` — see item 13), theme's `git_prompt_info` intact, syntax highlighting 0.8.1, startup
   0.17s vs 0.19s before. Two non-obvious things the migration had to handle: oh-my-zsh's git plugin
   calls `compdef` ~10 times so `compinit` must precede the plugin block, and the theme needs
   `colors` initialized explicitly since we no longer load `oh-my-zsh.sh`.

   Remaining difference is upstream, not ours: `gup*` were renamed to `gpr*` in oh-my-zsh commit
   `207d29b7`, which the pinned Aug-2025 antigen clone had never picked up. See TODO.md §3.
   Moving off oh-my-zsh entirely (sheldon/starship) is deferred to TODO.md §2.

5. **`neofetch` was archived by its author in 2024.** `home/.zshrc:41` still runs it.
   **Verified:** `neofetch` is not installed on this machine but `fastfetch` is — so that line is
   already dead code here. Swap to `fastfetch`, or `macchina` for the Rust option.

6. **Fugitive command names were removed in fugitive 3.x.** `:Gstatus`, `:Gcommit`, `:Gblame`,
   `:Glog`, and `:Gremove` are all gone. They appear in **both** configs:
   `home/.vimrc:63-70` and `home/.config/nvim/vim-plug/pluggins.vim:18-25`.
   Current equivalents: `:Git`, `:Git commit`, `:Git blame`, `:Gclog`, `:GDelete`,
   and `:Gdiffsplit` for `:Gdiff`.

7. **Dead or renamed vim plugin repos** in `home/.vimrc`:
   - `kballard/vim-swift` (:48) — author renamed; now `keith/swift.vim`.
   - `altercation/vim-colors-solarized` (:51, and pluggins.vim:13) — last commit 2011.
   - `bling/vim-airline` (:52, and pluggins.vim:14) — handed off years ago to `vim-airline/vim-airline`.
   - `vim-scripts/scons.vim` (:74) — vim-scripts mirrors are long unmaintained.
   - `scrooloose/syntastic` (:53-60) — commented out, and the org renamed to `vim-syntastic`.
     Delete the block; ALE or nvim's built-in LSP diagnostics replaced it.

8. **Stale Vundle gitlink.** **Verified:** `home/.vim/bundle/vundle` is tracked as mode `160000`
   (a submodule pointer) but there is **no `.gitmodules`**. It's leftover from the pre-2017 Vundle
   era and clones as an empty directory. Benign, but it's cruft — `git rm --cached` it.

9. **`solarized.vim` is checked in twice over.** `home/.vim/colors/solarized.vim` exists as a file
   *and* is declared as a `Plug` in both `.vimrc` and `pluggins.vim`. Pick one source of truth —
   and note the colorscheme actually in use is `phylite` (`.vimrc`), so the solarized plugin lines
   may be droppable entirely.

10. **The nvim plugin directory is in the wrong place.** `pluggins.vim:1` uses
    `plug#begin('~/.config/nvim/autoload/plugged')` — installing plugins *inside* vim-plug's own
    autoload dir. That's why `sync2git.sh:7` needs an explicit `rm -Rf` to keep it out of the repo.
    The conventional location is `~/.local/share/nvim/plugged`; the `rm -Rf` workaround then goes away.

### Shell hygiene

11. **The Linux `vi` alias prefers vim over neovim** — backwards given the stated preference.
    `home/.zsh/alias.zsh:34` and `:42` both read `if vim; then alias vi=vim; elif nvim; then alias vi=nvim`.
    macOS (`:16`) correctly uses nvim. Flip the Linux/BSD branches to check nvim first.

12. ~~**`compinit` runs twice per shell.**~~ — **RESOLVED.** It was running in `completion.zsh` and
    again in oh-my-zsh (`oh-my-zsh.sh:127`), leaving two identical 49,215-byte compdumps.
    `completion.zsh` now guards on `$_comps`, so it runs exactly once. Only `~/.zcompdump`
    regenerates now; the pair under `~/.antigen` are stale leftovers.

    Note the ordering conclusion inverted during the antidote migration: the original advice here
    was to move `compinit` *after* the plugin manager. That's wrong now — we no longer load
    `oh-my-zsh.sh`, so nothing else defines `compdef`, and the git plugin needs it at load time.
    `compinit` must come **first**. Checked that none of the five bundles ship `fpath` completion
    files, so nothing is lost by that ordering.

13. **`` [[ -x `which foo` ]] `` is used ~15 times** across `checks.zsh` and `alias.zsh`. Backticks
    are deprecated, and zsh's `which` builtin prints "not found" noise. Prefer
    `(( $+commands[foo] ))` — it's a hash lookup, no subshell.

14. **`bindkey -v` (`.zshrc:27`) and `set -o vi` (`.zshrc:31`) are the same thing.** Drop one.

15. **`path.zsh:1` hardcodes `/usr/local/bin` with no `/opt/homebrew`.** Apple Silicon paths are
    working on this machine only because something else (`/etc/paths` or a `.zprofile`) supplies
    them — not this repo. A fresh Apple Silicon machine set up from these dotfiles alone would be
    missing the Homebrew prefix. Use `brew shellenv` or add the prefix conditionally.
    Line 2's commented-out `microchip/xc32/v1.31` path is dead and can go.

16. **`sync2home.sh:6` — quoted tilde never expands.** `[ ! -f "~/.zsh/secret.zsh" ]` tests for a
    file literally named `~/.zsh/secret.zsh`, so it is **always true** (verified) and `touch` runs
    on every invocation. `touch` doesn't clobber contents, so this is harmless in practice — but
    the guard does nothing. Unquote it.

17. **The sync scripts are a one-way `cp -R` with no safety.** No deletions propagate, no dry run,
    no conflict detection, no backup — running `sync2home.sh` silently overwrites local edits, and
    a file deleted in the repo lingers forever on every machine. See list 2, item 1.

18. **`HISTSIZE=10000` / `SAVEHIST=9000`** (`history.zsh`) is small for a multi-machine setup, and
    history never syncs between the four machines. See list 2, item 4.

19. **`transfer()` (`alias.zsh:65`)** depends on `xfer.muteink.com` staying up, and there's a stray
    `,` typo in the directory branch (`file_name="$file_name.zip" ,`). Worth confirming that host is
    still yours and still running.

20. **`setopt correctall` (`setopt.zsh`)** second-guesses every argument, not just commands. Widely
    regarded as more disruptive than helpful; `setopt correct` alone is the common compromise.

21. **`README.md` is one line: `# dotfiles`.** For a repo whose entire purpose is bootstrapping four
    OSes, there are no install instructions, no prerequisite list, and no note that
    `~/.zsh/secret.zsh` must exist or the shell errors on `.zshrc:35`.

---

## List 2 — Things worth adding

### Sync and bootstrap

1. **Replace the `cp -R` scripts with a real dotfile manager.** This is the highest-leverage change
   in either list. `chezmoi` (Go, single binary, all four OSes) is the strongest fit — it has
   built-in templating for the per-OS branching that `alias.zsh` currently does by hand, plus
   encrypted-secret support that would solve the `secret.zsh` problem properly. `GNU stow` is the
   lighter-weight symlink-based alternative if you want to stay closer to the current model.

2. **A `.gitignore`** — `secret.zsh`, `**/plugged/`, `**/.netrwhist`, `.DS_Store`.

3. **A bootstrap script** that installs the package set per OS (pacman/apt/brew) so a new machine is
   one command rather than "clone, run sync2home, then manually install everything."

4. **`atuin`** (Rust) — SQLite-backed shell history with optional end-to-end-encrypted sync across
   machines. Directly addresses item 18 above and fits the multi-machine use case exactly.

### Rust CLI tools

**Verified:** none of these are currently installed on this machine — only `rg` is present.

5. **`eza`** — `ls` replacement with git status, tree mode, icons. Would replace the entire
   `dircolors.zsh` per-OS `gls`/`ls` dance with one consistent alias across all four OSes.
6. **`bat`** — `cat` with syntax highlighting and paging; also makes a good `MANPAGER`.
7. **`fd`** — `find` replacement, sane defaults, respects `.gitignore`.
8. **`zoxide`** — smarter `cd`. Note `antigen.zsh` has `rupa/z` commented out; zoxide is its Rust successor.
9. **`delta`** — side-by-side git diffs with syntax highlighting. Better answer than the current
   `alias diff=vimdiff` fallback in `alias.zsh`.
10. **`fzf`** — not Rust (Go), but it's the connective tissue for history search, file pickers, and
    completion. `fzf-tab` for zsh is a large quality-of-life win over the current `menu select`.
11. **`btop`** — **Verified:** already installed here, but `alias.zsh:10` only checks for `glances`
    (Python, not installed) then `htop` (not installed), so `top` currently falls through to system
    `top`. Add btop to that chain.
12. **`sd`** — the `replace()` function in `alias.zsh` is written three times, once per OS, purely
    because BSD and GNU `sed -i` differ on the backup-suffix argument. `sd` behaves identically
    everywhere and collapses all three into one definition.
13. **`ripgrep-all`, `dust`, `duf`, `procs`, `hyperfine`, `tokei`** — optional, same family.

### Prompt and shell

14. **`starship`** (Rust) — cross-shell prompt, one TOML config, works identically on all four OSes.
    Would replace `themes/doitchbig.zsh-theme`, which depends on oh-my-zsh's `git_prompt_info` and
    therefore locks you into the oh-my-zsh/antigen stack you'd otherwise be shedding.
15. **`zsh-autosuggestions`** — conspicuously absent; you already load `zsh-syntax-highlighting`.
16. **`direnv`** — per-project environment variables.

### Neovim

17. **Migrate to Lua + `lazy.nvim`.** The current config is vimscript + vim-plug and is essentially
    a vim config that happens to run in nvim. On nvim 0.12 you're leaving behind: built-in LSP,
    treesitter highlighting, and lazy-loading. Concretely — `telescope.nvim` is declared in
    `pluggins.vim:8` but never `require`d and configured, so it's running on defaults with no
    `fzf-native` sorter.
18. **`nvim-lspconfig` + `mason.nvim`** — real completion and diagnostics for Rust, Swift, Go.
19. **`rustaceanvim`** — replaces `rust-lang/rust.vim` (which is syntax-only) with full rust-analyzer
    integration, inlay hints, and debugging.
20. **`oil.nvim` or `yazi`** — `nerdtree` (2009-era) and `ranger.vim` (Python, slow to start) are both
    dated; `yazi` is the Rust file manager and has a first-class nvim integration.
21. **A modern colorscheme with treesitter support** — `tokyonight`, `catppuccin`, or `gruvbox-material`.
    Solarized predates treesitter and won't highlight correctly under it.

### Configs the repo doesn't cover yet

22. **`.gitconfig`** — aliases, `delta` as pager, `pull.rebase`, per-OS credential helper. Currently
    every machine's git config is set up by hand.
23. **`.tmux.conf` or `zellij`** — **Verified:** tmux is installed on this machine but unconfigured
    by this repo. `zellij` is the Rust alternative.
24. **`.ssh/config`** — you already manage ssh agent state via `keychain` (`alias.zsh:9`); the host
    config is the natural companion. Keep keys out of the repo.
25. **Terminal emulator config** — `ghostty`, `wezterm`, or `alacritty`, all cross-platform and
    file-configured, so all four machines look and behave the same.
26. **A `.zshenv` / `.zprofile` split** — login-shell-only setup (PATH, `brew shellenv`) belongs
    there rather than in the interactive `.zshrc`, which is where item 15 above actually originates.

---

## Suggested order

1. ~~`.gitignore` + confirm `secret.zsh` never lands in git~~ — **done**; history verified clean
2. ~~Fix the broken `EDITOR` path~~ — **done**; now resolves at runtime, neovim → vim → vi
3. ~~Reconcile the repo/deployed drift and decide on `alias docker=podman`~~ — **done**; the alias
   is now in `alias.zsh`, guarded so machines with real docker are unaffected
4. ~~Antigen → maintained loader~~ — **done** via antidote (item 4). Going further, to
   sheldon/starship, is now optional: see TODO.md §2
5. Move to chezmoi or stow (list 2, item 1) — the remaining structural change, and what stops the
   drift in item 3 from recurring
6. Add the Rust CLI set and fold it into the aliases — see TODO.md §1 for the decision
7. Rewrite the nvim config in Lua (list 2, items 17–21)
