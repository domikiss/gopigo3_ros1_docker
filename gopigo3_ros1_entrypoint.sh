#!/bin/bash
# Basic entrypoint for ROS / Catkin Docker containers
 
# Source ROS
source /opt/ros/${ROS_DISTRO}/setup.bash
 
# Source workspace, if built
if [ -f /gopigo_ws/devel/setup.bash ]
then
  source /gopigo_ws/devel/setup.bash
fi

# Execute the command passed into this entrypoint
exec "$@"
