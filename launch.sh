# Default values for package and file input parameters
package="gopigo3_navigation"
file="gopigo3_slam_navigation.launch"

OPTIND=1         # Reset in case getopts has been used previously in the shell.

while getopts p:f:m:l: flag
do
    case "${flag}" in
        p)  package=${OPTARG};;
        f)  file=${OPTARG};;
        m)  
            rosmaster_ip=${OPTARG}
            export ROS_MASTER_URI=http://$rosmaster_ip:11311
            echo "ROS master: $rosmaster_ip"
            ;;
        l)  
            local_ip=${OPTARG}
            export ROS_IP=$local_ip
            export ROS_HOSTNAME=$local_ip
            echo "Local IP: $local_ip"
            ;;
    esac
done


shift $((OPTIND-1))
[ "${1:-}" = "--" ] && shift

echo "roslaunch $package $file $@"

roslaunch $package $file $@
