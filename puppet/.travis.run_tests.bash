# check apache is running the mirror
[[ -z $(curl 'http://localhost/' | grep 'Index of') ]] || exit 1
# check jenkins is setup
[[ -f /etc/default/jenkins-slave ]] || exit 1
# check aptly mirror exits
aptly mirror show ros_stable
