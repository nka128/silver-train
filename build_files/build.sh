#!/bin/bash

set -ouex pipefail

# Co-located assets (e.g. .repo files): path is independent of WORKDIR and Containerfile mount target.
BUILD_FILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"



### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
#dnf5 install -y tmux 

# add Nordvpn repo and install nordvpn
dnf5 config-manager addrepo --from-repofile="${BUILD_FILES_DIR}/nordvpn.repo"
dnf5 install -y nordvpn-gui
# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File
#systemctl enable podman.socket

# Copy system files to the image
rsync -a /ctx/system_files/ /
# Enable NordVPN daemon and group service
systemctl enable nordvpn-group.service
systemctl enable nordvpnd.socket
systemctl enable nordvpnd.service