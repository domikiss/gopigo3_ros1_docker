ARG ROS_DISTRO=noetic

###########################################################
# Basic ROS1 development image containing Navigation Stack
###########################################################
FROM althack/ros:${ROS_DISTRO}-dev AS nav-dev

SHELL ["/bin/bash", "-c"]

RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
  && apt-get update -y \
  && apt-get install ros-${ROS_DISTRO}-navigation -y \
  && apt-get install ros-${ROS_DISTRO}-gmapping -y \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*


##################################################
# Overlay image containing GoPiGo3 ROS1 workspace
##################################################
FROM nav-dev AS gopigo3
SHELL ["/bin/bash", "-c"]

# Create a Catkin workspace, copy the gopigo3 related package contents and build it
RUN mkdir -p /gopigo_ws/src
COPY gopigo3 /gopigo_ws/src/gopigo3
COPY gopigo3_nav_sim /gopigo_ws/src/gopigo3_nav_sim
WORKDIR /gopigo_ws

# Install additional ROS packages used by the GoPiGo3 robot
RUN apt-get update \
  && rosdep update \
  && rosdep install --from-paths src --ignore-src --rosdistro ${ROS_DISTRO} -y \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

# Build workspace
RUN catkin_make

# Set ROS-related environment variables
#ARG ROS_MASTER_IP="10.9.0.42"
#ARG ROS_IP="10.9.0.1"

#ENV ROS_MASTER_URI=http://${ROS_MASTER_IP}:11311
#ENV ROS_IP=${ROS_IP}
#ENV ROS_HOSTNAME=${ROS_IP}

# Set up launcher shell script
COPY launch.sh /
RUN chmod 775 /launch.sh

# Set up the entrypoint
COPY gopigo3_ros1_entrypoint.sh /entrypoint.sh
RUN chmod 775 /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
