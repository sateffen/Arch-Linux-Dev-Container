FROM docker.io/archlinux:base


# Update the container and install all packages we need for devcontainer in general
# This is seperated from the actual project specific packages for readability
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm sudo git less && \

# Then we install the project-specific packages, so the ones we need want for development
# Independent of the devcontainer. Finally we clear the pacman cache
    pacman -S --noconfirm mise usage && \
    pacman -Sc --noconfirm && \

# Finally we can prepare the "dev" user with everything we want/need
    useradd -m -s /usr/bin/bash dev && \
    echo "dev ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/dev && \
    mkdir /home/dev/.mise && \
    echo "$(/usr/bin/mise activate --shims)" >> /home/dev/.bashrc && \
    echo "export PS1='\u:\w\$ '" >> /home/dev/.bashrc

# And before we exit, we configure the environment for our development-tools
ENV MISE_CONFIG_DIR /home/dev/.mise
ENV MISE_STATE_DIR /home/dev/.mise
ENV MISE_DATA_DIR /home/dev/.mise

# And copy our startup script that needs to run after the container got started
COPY --chown=root:root --chmod=755 ./startup.sh /startup.sh

# And last but not least: We switch to the dev user, so the devcontainer start with our user.
USER dev
