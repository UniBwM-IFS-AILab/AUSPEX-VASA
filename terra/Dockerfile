FROM nvidia/cuda:12.8.1-cudnn-runtime-ubuntu22.04

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
    sudo \
    nano \
    wget \
    iproute2 \
    libzmq3-dev \
    pkg-config

RUN apt install -y ros-${ROS_VERSION}-desktop \
    ros-${ROS_VERSION}-geographic-msgs \
    ros-${ROS_VERSION}-tf-transformations \
    ros-${ROS_VERSION}-rosbridge-suite 

RUN apt install -y nlohmann-json3-dev \
    python3-colcon-common-extensions \
    libunwind-dev libstdc++-12-dev \
    jq

RUN apt install -y libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer-plugins-bad1.0-dev \
    libgstreamer-plugins-good1.0-dev \
    gir1.2-gst-rtsp-server-1.0 \
    libgstrtspserver-1.0-dev \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav

RUN pip3 install --upgrade pip

RUN pip3 install pandas
RUN pip3 install alns
RUN pip3 install scikit-learn
RUN pip3 install google-generativeai
RUN pip3 install anthropic
RUN pip3 install openai
RUN pip3 install "transformers==4.46.3"
RUN pip3 install unified-planning[engines]

RUN pip3 install ultralytics --ignore-installed sympy
RUN pip3 install webcolors
RUN pip3 install "scipy==1.15.1"
RUN pip3 install "numpy==1.24.0"
RUN pip3 install pyparsing

RUN pip3 install requests
RUN pip3 install oauthlib
RUN pip3 install requests-oauthlib
RUN pip3 install rasterio

RUN pip3 install kconfiglib
RUN pip3 install future
RUN pip3 install pyros-genmsg
RUN pip3 install --force-reinstall --ignore-installed "transforms3d==0.4.2"
RUN pip3 install geopy
RUN pip3 install jsonschema
RUN pip3 install valkey
RUN pip3 install shapely
RUN pip3 install "tornado==6.4.2"
RUN pip3 install nltk
RUN pip3 install ortools
RUN pip3 install pyproj

COPY copy_files/ibm_cplex copy_files/ibm_cplex
RUN if [ -f "copy_files/ibm_cplex/python/setup.py" ]; then python3 copy_files/ibm_cplex/python/setup.py install; fi


WORKDIR /root
RUN wget https://github.com/mavlink/MAVSDK/releases/download/v3.5.0/libmavsdk-dev_3.5.0_ubuntu22.04_amd64.deb
RUN dpkg -i libmavsdk-dev_3.5.0_ubuntu22.04_amd64.deb
RUN ldconfig
RUN rm libmavsdk-dev_3.5.0_ubuntu22.04_amd64.deb

WORKDIR /root
RUN git clone https://github.com/PX4/PX4-Autopilot.git
WORKDIR /root/PX4-Autopilot
RUN git checkout -f v1.15.4
RUN git submodule update --init --recursive
RUN make px4_sitl_default

WORKDIR /root

RUN git clone https://github.com/microsoft/AirSim.git
#RUN git clone https://github.com/CodexLabsLLC/Colosseum.git AirSim
WORKDIR /root/AirSim
# overwrite some AirSim files (see: https://github.com/microsoft/AirSim/issues/4892)
COPY copy_files/airsim/setup.sh .
COPY copy_files/airsim/build.sh .
COPY copy_files/airsim/cmake/cmake-modules/CommonSetup.cmake ./cmake/cmake-modules/
COPY copy_files/airsim/ros2/src/airsim_ros_pkgs/CMakeLists.txt ./ros2/src/airsim_ros_pkgs/
COPY copy_files/airsim/Unity/build.sh ./Unity/
RUN chmod +x setup.sh
RUN chmod +x build.sh
# BlocksV2
RUN chmod +x Unreal/Environments/Blocks/clean.sh 
RUN ./setup.sh
RUN ./build.sh

WORKDIR /root
RUN mkdir valkey
WORKDIR /root/valkey
RUN git clone https://github.com/valkey-io/valkey
WORKDIR /root/valkey/valkey
RUN make

WORKDIR /root/valkey
RUN git clone https://github.com/valkey-io/valkeyJSON
WORKDIR /root/valkey/valkeyJSON
RUN sed -i "s|"OVERRIDE_FIND_PACKAGE"|""|" ./tst/CMakeLists.txt
RUN mkdir build
WORKDIR /root/valkey/valkeyJSON/build
RUN cmake ..
RUN make

WORKDIR /root
RUN mkdir scripts
COPY copy_files/px4/sitl_multiple_run.sh /root/scripts
RUN chmod +x /root/scripts/sitl_multiple_run.sh

RUN echo 'source /opt/ros/humble/setup.bash' >> /root/.bashrc
RUN echo 'source /root/AUSPEX/utils/auspex_aliases.sh' >> /root/.bashrc
RUN echo 'source /root/AUSPEX/utils/auspex_exports.sh' >> /root/.bashrc

WORKDIR /root
