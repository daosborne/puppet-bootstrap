#!/usr/bin/env bash
# This bootstraps Puppet on CentOS 7.x
# It has been tested on CentOS 7.0 64bit

set -e

REPO_URL="http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm"

if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

if which puppet > /dev/null 2>&1; then
  echo "Puppet is already installed."
  exit 0
fi

# Install puppet labs repo
echo "Configuring PuppetLabs repo..."
repo_path=$(mktemp --suffix=.rpm)

# Use either wget or curl to fetch repo rpm,
# or just use rpm if neither can be found
if which wget >/dev/null 2>&1; then
    wget --output-document="${repo_path}" "${REPO_URL}" 2>/dev/null
    rpm -i "${repo_path}" >/dev/null
elif which curl >/dev/null 2>&1; then
    curl -o "${repo_path}" "${REPO_URL}" 2>/dev/null
    rpm -i "${repo_path}"
else
    rpm -i "${REPO_URL}"
fi

rm -f "${repo_path}"

# Install Puppet...
echo "Installing puppet"
yum install -y puppet > /dev/null

echo "Puppet installed!"
