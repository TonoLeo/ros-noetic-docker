FROM osrf/ros:noetic-desktop-full

SHELL ["/bin/bash", "-c"]

ARG USERNAME="root"

ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics
ENV USER=$USERNAME
ENV USERNAME=$USERNAME
ENV GIT_PS1="${debian_chroot:+($debian_chroot)}\[\033[01;37m\]\u@\h\[\033[01;34m\] \w\[\033[01;31m\]$(__git_ps1 "[%s]")\[\033[00m\]\$\[\033[00m\] "
ENV NO_GIT_PS1="${debian_chroot:+($debian_chroot)}\u@\h:\w \$ "

ENV DEBIAN_FRONTEND noninteractive

RUN groupadd -g 1000 $USERNAME && \
    useradd -m -s /bin/bash -u 1000 -g 1000 -d /home/$USERNAME $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME

RUN apt update -y && apt upgrade -y && \
    apt install -y \
    git \
    vim \
    terminator \
    bash-completion \
    eog \
    xterm \
    python3-catkin-tools \
    curl \
    python3-vcstool

USER $USERNAME
RUN mkdir -p $HOME/raspicat_ws/src && \
    cd $HOME/raspicat_ws/src && \
    git clone https://github.com/CIT-Autonomous-Robot-Lab/value_iteration.git && \
    git clone https://github.com/ryuichiueda/emcl2.git

WORKDIR /home/$USERNAME/raspicat_ws/
RUN rosdep update && \
    rosdep install -r -y --from-paths --ignore-src ./ && \
    source /opt/ros/noetic/setup.bash && \
    catkin build

RUN echo "source /opt/ros/noetic/setup.sh" >> $HOME/.bashrc && \
    echo "source /home/$USERNAME/raspicat_ws/devel/setup.bash" >> $HOME/.bashrc && \
    echo "export ROS_MASTER_URI=http://localhost:11311" >> $HOME/.bashrc && \
    echo "export ROS_HOSTNAME=localhost" >> $HOME/.bashrc && \
    echo "source /etc/bash_completion" >> $HOME/.bashrc && \
    echo "if [ -f /etc/bash_completion.d/git-prompt ]; then" >> $HOME/.bashrc && \
    echo "    export PS1='${GIT_PS1}'" >> $HOME/.bashrc && \
    echo "else" >> $HOME/.bashrc && \
    echo "    export PS1='${NO_GIT_PS1}'" >> $HOME/.bashrc && \
    echo "fi" >> $HOME/.bashrc 

WORKDIR /home/$USERNAME/
CMD ["/bin/bash"]

