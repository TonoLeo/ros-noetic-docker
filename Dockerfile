FROM osrf/ros:noetic-desktop-full

WORKDIR /root/

ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

RUN apt-get update

RUN apt-get install -y vim
RUN apt-get install -y git
RUN apt-get install -y python3-catkin-tools

RUN echo "source /opt/ros/noetic/setup.sh" >> .bashrc
RUN echo "export ROS_MASTER_URI=http://localhost:11311" >> .bashrc
RUN echo "export ROS_HOSTNAME=localhost" >> .bashrc
