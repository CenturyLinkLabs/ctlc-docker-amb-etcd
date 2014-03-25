env | grep _TCP= | sed 's/.*_PORT_\([0-9]*\)_TCP=tcp:\/\/\(.*\):\(.*\)/socat TCP4-LISTEN:\1,fork,reuseaddr TCP4:\2:\3 \&/'  | sh 

env | grep _TCP= | sed 's/.*_PORT_\([0-9]*\)_TCP=tcp:\/\/\(.*\):\(.*\)/export PORT=\1/' | sh 

while true; do etcdctl -C "http://172.17.42.1:4001/" set /services/${NAME:-$PORT} "{ \"host\": \"%H\", \"port\": $PORT, \"version\": \"${VERSION:-1}\" }" --ttl 60;sleep 45;done
