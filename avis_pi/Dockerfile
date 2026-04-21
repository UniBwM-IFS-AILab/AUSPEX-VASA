FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1
ENV PYTHONPATH=/usr/local/lib/python3/dist-packages
ENV ROS_VERSION="humble"
ENV TZ=Europe/Berlin

SHELL ["/bin/bash", "-c"]

RUN apt update -y && apt upgrade -y
RUN apt install -y locales
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8

RUN apt install -y software-properties-common
RUN add-apt-repository universe
RUN apt update && apt install curl -y

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    tzdata \
    net-tools \
    iputils-ping \
    git \
    wget \
    iproute2 \
    ca-certificates \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    build-essential \
    pkg-config \
    cmake \
    ninja-build \
    libboost-dev \
    libgnutls28-dev \
    openssl \
    libyaml-dev \
    python3-yaml \
    python3-ply \
    python3-jinja2 \
    libpython3-dev \
    pybind11-dev \
    libevent-dev \
    libdrm-dev \
    libcap-dev \
    libudev-dev \
    libtiff-dev \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null
RUN apt update -y

RUN apt install -y ros-${ROS_VERSION}-desktop \
    ros-${ROS_VERSION}-geographic-msgs \
    ros-${ROS_VERSION}-tf-transformations \
    ros-${ROS_VERSION}-rosbridge-suite 

RUN apt install -y python3-colcon-common-extensions \
    libunwind-dev libstdc++-12-dev

RUN apt install -y qtbase5-dev libqt5core5a libqt5widgets5
RUN apt install -y  libglib2.0-dev \
                    libgstreamer-plugins-base1.0-dev \
                    libgstreamer1.0-dev \
                    gstreamer1.0-tools \
                    gstreamer1.0-plugins-base \
                    gstreamer1.0-plugins-good \
                    libgstreamer-plugins-bad1.0-dev \
                    libgstreamer-plugins-good1.0-dev \
                    gir1.2-gst-rtsp-server-1.0 \
                    libgstrtspserver-1.0-dev \
                    gstreamer1.0-plugins-ugly

RUN python3 -m pip install mavsdk pymap3d
RUN python3 -m pip install --upgrade pip setuptools wheel meson ninja
RUN python3 -m pip install --no-cache-dir picamera2 pillow

WORKDIR /opt
RUN git clone https://github.com/raspberrypi/libcamera.git

WORKDIR /opt/libcamera
RUN meson setup build \
    --buildtype=release \
    -Dgstreamer=disabled \
    -Dpycamera=enabled
RUN ninja -C build
RUN ninja -C build install
RUN ldconfig

# Headless Picamera2 patch: replace DRM/Qt previews with NullPreview-based stubs
RUN python3 - <<'PY'
from pathlib import Path

base = Path("/usr/local/lib/python3.10/dist-packages/picamera2")
previews_init = base / "previews" / "__init__.py"

previews_init.write_text(
"""from .null_preview import NullPreview

class DrmPreview(NullPreview):
    pass

class QtPreview(NullPreview):
    pass

class QtGlPreview(NullPreview):
    pass
"""
)
print("Patched picamera2 previews for headless use")
PY

# Sanity check
RUN pkg-config --modversion libcamera

WORKDIR /root

RUN echo 'source /opt/ros/humble/setup.bash' >> /root/.bashrc
RUN echo 'source /root/AUSPEX/utils/auspex_aliases.sh' >> /root/.bashrc
RUN echo 'source /root/AUSPEX/utils/auspex_exports.sh' >> /root/.bashrc