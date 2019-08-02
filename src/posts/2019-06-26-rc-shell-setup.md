---
title: 'Guide to Installing the *rc* Shell with Line Editing in Linux'
author: Gregory Chamberlain
date: 'Wednesday 26 June, 2019'
lang: en-GB
description: |
    How to compile and install Byron Rakitzis' reimplementation of the
    *rc* shell from Plan 9 — an expressive and thoughtfully designed
    alternative to the ubiquitous Bourne-compatible shells of today.
---

Introduction
------------

This article demonstrates how to download, compile and install Byron
Rakitzis' reimplementation of the *rc* shell, originally from the Plan
9 system. The first section is a brief history of *rc* and some of its
newer forms, but feel free to skip ahead to the actual guide.

History
-------

Around 10 years or so after creating Unix, the Computing Science
Research Center at AT&T Bell Labs developed the [Plan 9] operating
system, which further riffed on the Unix philosophy. It was only used
internally at Bell Labs until the early \'90s when they made it
available to universities and businesses. Eventually they released it
under an open-source license. Today it's only really used by hobbyists
and people learning about operating systems.

Anyway, *rc* (short for *"run commands"*) was the system's canonical
command-line interpreter, and it's ace. Its syntax is much simpler than
that of the established Bourne shell from which Bash and most other
contemporary shells derive; and *rc*\'s handling of strings and special
characters makes it less error-prone overall.

Many tools from Plan 9, including its fantastic *rc* shell, have been
ported to Unix-like systems under the name *[Plan 9 from User Space]*
(a.k.a. plan9port). A subset of these programs packaged as [9base] is
provided by Suckless. The two are probably available from your
distribution's package repository (but keep reading).

An independent project by Byron Rakitzis saw a reimplementation of the
*rc* shell for Unix-like systems. His implementation differs very
slightly from the *true* Plan 9 shell (as ported by plan9port), but
before compiling it can be linked with line-editing libraries such as
GNU readline, which is why I much prefer it for interactive use.

Install the *rc* shell
----------------------

I recommend installing [Byron Rakitzis' reimplementation of *rc*],
which provides such nice features as **line editing** and **tab
completions**.

### Compile from source

Clone the GitHub repository and run the bootstrap script:

```bash
git clone https://github.com/rakitzis/rc
cd rc
./bootstrap
```

This generates an `INSTALL` file with detailed instructions. Then
configure and build like so:

```bash
sh configure --with-edit=readline
make
sudo make install
```

You now have *rc* installed on your machine. To uninstall, use `sudo
make uninstall` in that same directory.

Start the *rc* shell
--------------------

You may need to log out and back in for it to work. Start the shell by
typing

```bash
rc
```

or, in order to have *rc* behave as a **login shell**, pass the `-l`
flag:

```bash
rc -l
```

As described in the manual (`man rc`), this tells *rc* to source
`$home/.rcrc` when it starts.[^1] Much like one's [`.bashrc`], you
might like to populate that file with commands that

-   change your `$prompt`
-   change your `$path`[^2]
-   define functions,
-   assign environment variables,
-   do whatever else.

The default prompt is a semicolon, which seems an odd choice. According
to the manual,

> \[t\]he reason for this is that it enables an *rc* user to grab
> commands from previous lines using a mouse, and to present them to
> *rc* for re-interpretation; the semicolon prompt is simply ignored by
> *rc*.

To quit the shell, press CTRL-D or type

```bash
exit
```

Make *rc* your login shell
--------------------------

When you open your terminal, the first program it runs is your **login
shell**. On most Linux machines, users' login shells are set to Bash by
default. Changing your login shell is easy to do.

Firstly, add *rc*'s full path to your machine's list of approved login
shells. This must be done as root, as so:

```bash
sudo su -c 'which rc >> /etc/shells'
```

Let's do this next step in an *rc* shell, demonstrating its backquote
substitution (analogous to the Bourne shell's command substitution).
And we'll use the built-in [`chsh`] utility:

```bash
rc
chsh $USER --shell `{ which rc }
```

That's it! Next time you log in as the same user, your tty and
terminals will start with the *rc* shell.[^3] This has had no effect on
other users; so if your *rc* executable breaks or disappears, you can
simply log in as root and change your shell back to Bash or what have
you.

Make use of run commands
------------------------

Many users like to use `la` as an alias to `ls -A`. To implement this
in our *rc*, let's define a function in **`$home/.rcrc`**.[^4]

```bash
fn la { ls -A $* }   
```

In short, `fn` is the keyword for creating functions, and the braces
contain the sequence of commands the function shall execute. Arguments
of the function are stored in `$1`, `$2`, etc., but `$*` stores the
list of *all* arguments given, which we humbly and helpfully pass
straight through to the `ls` program.

I found that I had to log out and back in for the updated `$home/.rcrc`
to be sourced automatically; starting a new instance of *rc* was not
enough. But we can source the new commands manually with the `.`
built-in, as so:

```bash
. $home/.rcrc
```

or, if we're already in the home directory, simply

```bash
. .rcrc
```

[^1]: In *rc*, the home directory is stored in both the lowercase
  variable `$home` and the usual uppercase environment variable
  `$HOME`.

[^2]: In *rc*, the built-in `$path` variable is a list of directories
  that is kept in sync with the usual `$PATH` environment variable, a
  colon-separated string of the same directories.

[^3]: I've tested this with [st] and [rxvt-unicode], which identify the
  user's shell by reading /etc/passwd (which is what `chsh` changes).
  Other terminals may need additional configuration.

[^4]: Unlike the Bourne shell, *rc* does not support aliases.  Use
  functions instead!  The `builtin` keyword should be used to avoid
  infinite recursion.

  [Plan 9]: https://9p.io/plan9
  [Plan 9 from User Space]: https://9fans.github.io/plan9port
  [9base]: http://tools.suckless.org/9base/
  [Byron Rakitzis' reimplementation of *rc*]: https://github.com/rakitzis/rc
    "rc shell -- independent re-implementation for Unix of the Plan 9 shell (from circa 1992)."
  [`.bashrc`]: https://wiki.archlinux.org/index.php/Bash#Configuration_files
  [`chsh`]: http://man7.org/linux/man-pages/man1/chsh.1.html
  [st]: https://st.suckless.org/
  [rxvt-unicode]: https://wiki.archlinux.org/index.php/Rxvt-unicode
