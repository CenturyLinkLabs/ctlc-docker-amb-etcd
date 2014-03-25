env | grep _TCP= | sed 's/.*_PORT_\([0-9]*\)_TCP=tcp:\/\/\(.*\):\(.*\)/socat TCP4-LISTEN:\1,fork,reuseaddr TCP4:\2:\3 \&/' | sh

env | grep _TCP= | sed 's/.*_PORT_\([0-9]*\)_TCP=tcp:\/\/\(.*\):\(.*\)/export LOCAL_PORT=\1\nexport REMOTE_HOST=\2\nexport REMOTE_PORT=\3/' > /tmp/env

echo "export LOCAL_HOST=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`" >> /tmp/env

source /tmp/env

while true
do
	etcdctl -C "http://172.17.42.1:4001/" set \
		/services/${NAME:-$LOCAL_PORT} \
		"{ \"container_id\": \"$HOSTNAME\", \"local_ip\": \"$LOCAL_HOST\", \"port\": $LOCAL_PORT, \"version\": \"${VERSION:-1}\" }" --ttl 60
	sleep 45
done
