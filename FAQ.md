# Arch Linux Dev Container FAQ

You have probably more questions regarding the setup, so here's a short FAQ explaining
the most important bits and pieces.

## Why Arch Linux?

See README.

## Isn't Arch Linux unstable?

No, Arch Linux is, in fact, very stable. I'm using Arch on my desktop, laptop, homeserver, server in datacenter -
basically everywhere. In >10 years the only issues I had were things where I actually did something wrong, not
Arch failing on me. Plus, we are working in a container, if the container fails, so what?

## Why mise?

[mise](https://mise.jdx.dev/) is a great tool for managing toolchains, and even though Arch Linux has a package for
basically everything (and everything missing in AUR), you sometimes need certain versions of tools, that are not
available in the repository anymore, like older python versions. Managing such toolchains with mise is a breeze,
disconnecting the toolchain from the distro if necessary.

Additionally, mise works outside of dev containers as well, like in CI or for people on other (operating-)systems,
so if you have a development team with a heterogen development environment (like an open source project or a diverse
development team) managing the exact toolchain with something else than your distro is a good way to go. And for
everything not manageable with mise, we got Arch.

## Why is claude-code included?

The dev container contains a cache directory for claude-code state and installs the claude extension for VSCode if
you use it. This is just to demonstrate how to integrate a tool such as claude-code in the setup. As mentioned in
the README, I use dev container to limit the blast-radius for AI tools (like claude-code) as well, so having a simple
example at hand just helps with adaption.

It's not important for the general dev container setup, so you can remove it, if you don't use claude-code.

## Why are you using a custom startup.sh script?

In some projects it's necessary to run some more logic at project startup. The current script has just one line
(or, if you want to remove root-access, two), but you might want to add some stuff at some point, like seeding of
environment, triggering a webhook or generating some temporary access-token and storing them in the environment.

To simplify adding that stuff, the startup.sh is already available.

## Why are you using a docker-compose.yml for one container?

This has the same reason as the startup.sh: So it's prepared for your project. Dev Containers often need additional
services, like a database or similar. Adding those to an existing docker-compose.yml is quicker/simpler than setting
this up in every project again.

Additionally, creating volumes for persisting data is a lot simpler that way - like already done for mise and
claude-code.

## Why split the two installs?

In the Dockerfile are two different `pacman -S` calls, installing different packages. The first one is for installing
packages that are important for the dev container itself, not your project. This line will basically never change,
regardless of your project. The second line installs tools needed for the corresponding project, your compiler, linter,
whatever you need. And that's basically the reason why the two install lines are split: to manage different lists for
different purpose.

Thinking ahead, the dependencies for the dev container might change, something new gets added, like `curl` or similar,
then you can add it to the first line, and just exchange that line. It's easy to grasp the purpose, and see that it's
independent from the project itself.

## Why drop root-permissions?

In my experience, you don't need root permissions for development work. There are some usecases, where you can simply
not drop sudo-permissions (see *startup.sh* and scroll down to the bottom), but for development an unprivileged user
like "dev" is usually fine.

And yes, even if you enable sudo for "dev", it's limited to the container, so the blast radius stays small, but the
principal of least privilege demands removing everything we don't need.

## Is root actually not reachable?

Well, if you remove the sudoers entry (like at the bottom of *startup.sh*) reaching root should be impossible. If you
want to execute `sudo` you have to enter a password that... isn't set. It's not empty, it's actually not set, so you
can't enter one. If you use `passwd` to set one you need to enter your current password, which doesn't work, because -
again - it is not set. `su` doesn't work as well, because root has no password set as well, soooo... well it's hard.

In theory you can try stuff with SUID (you can use your favorite search engine to learn about "privesc suid", short
for "privilege escalation suid"), but I think it shouldn't be doable in this scenario.

## How to change the default shell?

Because people like using other shells than bash, I've prepared this as good as possible already:

- first, install the shell you want. You can add this to the list of dev container specific dependencies, like
[zsh](https://archlinux.org/packages/extra/x86_64/zsh/) or [fish](https://archlinux.org/packages/extra/x86_64/fish/).
- The `useradd` command gets called explicitly with `-s /usr/bin/bash` to make this obvious: Just change the default shell
here, like `-s /usr/bin/zsh` or `-s /usr/bin/fish`.
- finally, everything that gets written to `.bashrc` needs adjustment to work for your shell.

## How to use dev container features?

Dev Containers provide their own so called "features", which are basically scripts preparing your dev container. Most
of them are created with Debian in mind, some even for RHEL, but none of them are available for Arch Linux - but
this is fine. Arch Linux provides a lot of packages out of the box, and most features basically just install different
software inside your container, so they are usually not important.

Additionally, dev container features can be considered bad practice, because most of them basically download some
external shell script and execute it - not that trustworthy to be honest.

## How to use docker-in-docker?

Simple: Don't. docker-in-docker requires the dev container to run "privileged", which defeats the purpose of isolation.
I think [Trend Micro](https://www.trendmicro.com/en_us/research/19/l/why-running-a-privileged-container-in-docker-is-a-bad-idea.html) has a nice explanation of the details (even though a
bit lengthy).