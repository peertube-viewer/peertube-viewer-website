---
title: Download
layout: download
type: page
---

Documentation
=============

This page contains information on installation and downloads for peertube-viewer-rs. To learn how to use it, go to [the documentation](https://docs.peertube-viewer.com).

Via package managers
====================

If available for your distribution, this is the recommended install process.

Currently, peertube-viewer is only available on the [AUR](https://wiki.archlinux.org/index.php/Arch_User_Repository) for Arch Linux:

- [peertube-viewer-rs](https://aur.archlinux.org/packages/peertube-viewer-rs-bin/) (Requires compiling)
- [peertube-viewer-rs-bin](https://aur.archlinux.org/packages/peertube-viewer-rs/)


Manual install
==============

If peertube-viewer-rs is is not available for your platform, don't hesitate to ask (or even better, create yourself the package and make a Merge Request).
Manuals installs are not recommended because you won't have access to new updates easily.

The binary releases contain the executable `peertube-viewer-rs` as well as the man page `peertube-viewer-rs.1` and the auto completion for various shells in the `completions` folder.

You can just run the binary from the command line.
For a complete install, `peertube-viewer-rs` should be accessible via the [`PATH`](https://en.wikipedia.org/wiki/PATH_(variable)), the completions can be added to their respective emplacements to have nice auto completion in the shell (`/etc/bash_completion.d/peertube-viewer-rs.bash` for bash on Arch Linux)
