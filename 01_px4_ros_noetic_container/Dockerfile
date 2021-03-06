FROM px4io/px4-dev-ros-noetic

USER root

# Set the nvidia container runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

RUN apt-get remove modemmanager -y \
        && apt-get update \
        && apt-get install -y bash-completion \
        && apt-get install -y mesa-utils \ 
        && apt-get install -y iputils-ping \ 
        && apt-get install -y openssh-server python3-pip exuberant-ctags \
        && apt-get install -y gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl \
        && apt-get install -y fuse libfuse2 \
        && apt-get install -y libpulse-mainloop-glib0 \
        && apt-get install -y git vim tmux nano htop sudo curl wget gnupg2 \
        && apt-get install -y rviz  \
	    && pip3 install powerline-shell  \
        && rm -rf /var/lib/apt/lists/* \
        && usermod -a -G dialout user \
        && usermod -a -G video user \
        && echo "user:user" | chpasswd && adduser user sudo \
        && echo "user ALL=(ALL) NOPASSWD: ALL " >> /etc/sudoers

USER user
WORKDIR /home/user

RUN wget https://s3-us-west-2.amazonaws.com/qgroundcontrol/latest/QGroundControl.AppImage \
        && chmod +x QGroundControl.AppImage

RUN git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack  \
        && git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux-resurrect
COPY --chown=user:user ./.tmux.conf /home/user/.tmux.conf
COPY --chown=user:user ./.powerline.sh /home/user/.powerline.sh

RUN mkdir -p /home/user/.vim/bundle \
        && git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

COPY --chown=user:user ./.vimrc /home/user/.vimrc
 
RUN set -x \
     \    && vim -E -u NONE -S /home/user/.vimrc -C "+PluginInstall" -C "+qall";  exit 0
#
# Set some decent colors if the container needs to be accessed via /bin/bash.
RUN echo LS_COLORS=$LS_COLORS:\'di=1\;33:ln=36\' >> ~/.bashrc \
        && echo export LS_COLORS >> ~/.bashrc \
        && echo 'source ~/.powerline.sh' >> ~/.bashrc \
        && echo 'alias tmux="tmux -2"' >> ~/.bashrc \
        && echo 'PATH=~/bin:$PATH' >> ~/.bashrc \
        && touch ~/.sudo_as_admin_successful # To surpress the sudo message at run.

RUN rosdep update \
        && echo "source /opt/ros/noetic/setup.bash" >> /home/user/.bashrc

RUN mkdir -p Projects/catkin_ws/src 
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; cd /home/user/Projects/catkin_ws; catkin_make'
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; cd /home/user/Projects/catkin_ws; catkin_make'

RUN echo "source /home/user/Projects/catkin_ws/devel/setup.bash --extend" >> /home/user/.bashrc
STOPSIGNAL SIGTERM

CMD sudo service ssh start && /bin/bash
USER root
