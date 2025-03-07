#
#!/bin/bash
#

# 添加必要的软件源和仓库
sudo -E apt-get -qq install apt-utils

# 确保universe仓库并启用以及添加其他必要的软件源
sudo -E add-apt-repository universe
sudo -E add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe restricted multiverse"
sudo -E add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc)-updates main universe restricted multiverse"
sudo -E apt-get -qq update

# 安装OpenWrt编译所需的依赖包
sudo -E apt-get -qq install \
  build-essential \
  clang \
  flex \
  bison \
  g++ \
  gawk \
  gcc-multilib \
  gettext \
  git \
  libncurses5-dev \
  libssl-dev \
  python3-distutils \
  python3-pyelftools \
  python3-setuptools \
  rsync \
  unzip \
  zlib1g-dev \
  file \
  wget \
  curl \
  ccache \
  xsltproc \
  libxml-parser-perl \
  upx-ucl \
  libelf-dev \
  autoconf \
  automake \
  libtool \
  device-tree-compiler \
  fuse \
  libfuse-dev
