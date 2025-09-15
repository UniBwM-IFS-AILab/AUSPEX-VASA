FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
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
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null
RUN apt update -y

RUN apt install -y python3-pip \
    tzdata \
    net-tools \
    iputils-ping \
    git \
    wget \
    iproute2

RUN apt install -y ros-${ROS_VERSION}-desktop \
    ros-${ROS_VERSION}-geographic-msgs \
    ros-${ROS_VERSION}-tf-transformations \
    ros-${ROS_VERSION}-rosbridge-suite

RUN apt install -y nlohmann-json3-dev \
    python3-colcon-common-extensions \
    libunwind-dev libstdc++-12-dev \
    jq

RUN apt install -y python3-jinja2
RUN apt install -y libboost-dev
RUN apt install -y libgnutls28-dev openssl libtiff-dev pybind11-dev
RUN apt install -y qtbase5-dev libqt5core5a libqt5widgets5

RUN apt install -y python3-yaml python3-ply
RUN apt install -y libglib2.0-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev \
    gstreamer1.0-tools gstreamer1.0-plugins-base gstreamer1.0-plugins-good

RUN pip install mavsdk

WORKDIR /root
RUN apt -y install wget
RUN wget https://github.com/mavlink/MAVSDK/releases/download/v3.5.0/libmavsdk-dev_3.5.0_debian12_arm64.deb
RUN dpkg -i libmavsdk-dev_3.5.0_debian12_arm64.deb
RUN ldconfig
RUN rm libmavsdk-dev_3.5.0_debian12_arm64.deb

WORKDIR /root
RUN pip install meson
RUN apt install -y ninja-build
RUN ninja --version
RUN git clone https://github.com/raspberrypi/libcamera.git
WORKDIR /root/libcamera
RUN meson setup build
RUN ninja -C build install
RUN ldconfig

WORKDIR /root

RUN echo 'source /opt/ros/humble/setup.bash' >> /root/.bashrc
RUN echo 'source /root/MENTHON-WS/install/setup.bash' >> /root/.bashrc
RUN echo 'source /root/AUSPEX/utils/auspex_aliases.sh' >> /root/.bashrc
RUN echo 'source /root/AUSPEX/utils/auspex_exports.sh' >> /root/.bashrc
