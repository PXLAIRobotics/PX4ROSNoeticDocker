#!/bin/bash

if ! command -v glxinfo &> /dev/null
then
    echo "glxinfo command  not found! Execute \'sudo apt install mesa-utils\' to install it."
    exit
fi


vendor=`glxinfo | grep vendor | grep OpenGL | awk '{ print $4 }'`

if [ $vendor == "NVIDIA" ]; then
    docker run -it --rm \
        --name px4-ros-noetic \
        --hostname px4-ros-noetic \
        -w /home/user/ \
        --cap-add SYS_ADMIN \
        -v `pwd`/../Commands:/home/user/bin \
        -v `pwd`/../PX4-Autopilot/:/home/user/Firmware:rw \
        -v `pwd`/../Projects/catkin_ws_src:/home/user/Projects/catkin_ws/src \
        -v /tmp/.X11-unix/:/tmp/.X11-unix:ro \
        -env="XAUTHORITY=$XAUTH" \
        --gpus all \
        --device /dev/fuse \
        -e DISPLAY="${DISPLAY}"  -e LOCAL_USER_ID="$(id -u)" \
        pxl_ra_px4_ros_noetic_groundcontrol \
        /bin/bash
else
    docker run --privileged -it --rm \
        --name px4-ros-noetic \
        --hostname px4-ros-noetic \
        -w /home/user/ \
        --cap-add SYS_ADMIN \
        -v `pwd`/../Commands:/home/user/bin \
        -v `pwd`/../PX4-Autopilot/:/home/user/Firmware:rw \
        -v `pwd`/../Projects/catkin_ws_src:/home/user/Projects/catkin_ws/src \
        -v /tmp/.X11-unix/:/tmp/.X11-unix:ro \
        --device=/dev/dri:/dev/dri \
        --device /dev/fuse \
        -e DISPLAY="${DISPLAY}"  -e LOCAL_USER_ID="$(id -u)" \
        pxl_ra_px4_ros_noetic_groundcontrol \
        /bin/bash
fi
