# gopigo3_ros1_docker

A demo package for running the navigation functionalities of a ROS1-based GoPiGo3 robot in a Docker container. (Tested only with simulated robot under ROS Noetic.)

A Dockerfile is provided for building a basic ROS1 docker image which contains ROS1 buildtools and the `gopigo3` and `gopigo3_nav_sim` packages that contain navigation launch files for the robot. No ROS desktop tools (RViz, Gazebo etc.) are added.

Note that the `gopigo3` and `gopigo3_nav_sim` packages are contained in this repo as Git submodules. In order to get the contents of the submodules, you should issue the following commands after cloning:

```
git submodule init
git submodule update
```

To build the Docker image, issue the following command from the main directory of this repository. Note that you must specify the IP address of the machine running the docker container (ROS_IP) and the IP address of the ROS master (ROS_MASTER_IP) as build arguments.
```
docker build -f Dockerfile \
  --build-arg ROS_IP=<IP.of.local.machine> \
  --build-arg ROS_MASTER_IP=<IP.of.ROS.master> \
  --target gopigo3 -t ros-noetic-nav:gopigo3 .
```

If you build the image more than once, some dangling (untagged) docker images may be present. You can remove them as follows:
```
docker rmi $(docker images -f "dangling=true" -q)
```

The Docker image is intended to be used along with another ROS instance having RViz to monitor the navigation tasks and Gazebo to be able to simulate the robot (if a real robot is not available). The navigation functionalities inside a Docker container can be started by the following command:
```
docker run -it --rm --net=host ros-noetic-nav:gopigo3 \
    bash -c "roslaunch gopigo3_navigation gopigo3_slam_navigation.launch"
``` 
Note that the `--rm` switch removes the created container right after exiting.
