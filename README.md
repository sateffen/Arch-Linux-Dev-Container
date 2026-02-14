# Arch Linux Dev Container

A minimal, security-focused dev container setup based on Arch Linux – no (devserver-)
features, no bloat, just (mostly) pacman.

Dev Containers are an approach to create an isolated environment, in which I can
run tools and develop my software. The isolation provides security, limiting the
blast radius of supply-chain attacks and allow me to run AI agents or similar
without fear of them deleting my OS - if they do, I just restart the container.

So, even though dev containers provide a lot more goodies and features, for me it's
all about isolation and security aspects - you can read about that down below.

## How to Use

Basically:

- Make sure you have docker + docker-compose available.
  - Either install native packages on your system, like `pacman -S docker docker-compose`
    on Arch Linux.
- Copy the `.devcontainer/` folder to your project. Keep the folder name as-is – dev container
  tooling expects exactly this name.
- Change the `name` in the `devcontainer.json`.
- Change the packages you want to install in the container (Dockerfile). The Dockerfile
  has comments explaining the different lines, you don't need to change any other lines.
- Optional: Extend the `docker-compose.yml` with additional services you need or
  additional volumes as persistent storage.

Then you can use your favorite tool supporting dev containers, like VSCode with the
[dev container plugin](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).
Opening a folder containing the `.devcontainer/` folder will make VSCode ask you to
open it in the dev containers. If not, click the blue status bar icon in the bottom
left, and choose "Reopen in Container".

## Why Arch Linux?

As written above: For me dev containers are a tool for isolating my project, providing
an additional layer of security. If I just want to manage my toolchain I could use
tools like [mise](https://github.com/jdx/mise) and done, but nowadays supply-chain
attacks are everywhere. And it's not only supply-chain attacks, even tools like AI-
Agents sometimes go on a rampage, deleting or breaking stuff they shouldn't.

Dev Containers have useful stuff to extend them, like "features", which are basically
install-scripts provided by someone on the internet, which you download and then execute...
which is... not the safest thing to do. And, to be honest: Most features simply install
a certain tool or software in your container.

With Arch Linux I don't need those features, because I can use the vast ecosystem of
packages provided in the arch-repository, maintained by the same maintainers I trust
with my daily-driving OS. Arch Linux has packages for all relevant tooling, just one
pacman command away, in a recent version, making it the perfect choice for my
working environment.

Additionally, I know Arch Linux pretty well, can build my own packages if necessary,
and with the arch-wiki I have the best documentation right for my dev container.

And... I can use mise inside my dev container anyway, managing weird toolchains with
that, still having strong isolation.

## Why not Arch Linux

But, using Arch Linux has some downsides as well: First of all, basically no dev container
"feature" (like, the features in terms of addons) works with Arch Linux, so, even if
you want to, it won't help. This means, that stuff like git or docker are not easily
working... but...

I don't mind the container reading the git-history, maybe even an AI bot, but I don't want
such tools committing in my name. I am responsible for everything committed, so I do this
by myself outside the dev container.

And for docker... That's why we use the docker-compose file. If I use the "docker-outside-
of-docker" feature, I give my tools access to a daemon with root access to my host-system,
basically breaking every isolation. If I use "docker-inside-docker", I have to run my
system privileged, which means my container can access all devices (everything in /dev),
meaning it can mount my host-systems filesystem aaaaand... break the isolation. That's
one reason we use the docker-compose file: If we need additional services, like postgres
for development, I can simply add that to my dev container setup and everything is up and
running.

Last but not least: For me this setup works, because I know Arch Linux well. If you don't
know Arch Linux, or don't like to work with the arch-wiki, normal dev containers are better,
because you'll find a lot more documentation about it.
