env | grep _TCP= | sed 's/.*_PORT_\([0-9]*\)_TCP=tcp:\/\/\(.*\):\(.*\)/export LISTEN_PORT=\1\nexport REMOTE_HOST=\2\nexport REMOTE_PORT=\3/' > env

source env

tcp-proxy $LISTEN_PORT $REMOTE_HOST $REMOTE_PORT &

while true
do
	etcdctl -C "http://172.17.42.1:4001/" set \
		/services/${NAME:-$LISTEN_PORT} \
		"{ \"host\": \"%H\", \"port\": $LISTEN_PORT, \"version\": \"${VERSION:-1}\" }" --ttl 60
	sleep 45
done
