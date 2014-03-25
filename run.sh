env | grep _TCP= | sed 's/.*_PORT_\([0-9]*\)_TCP=tcp:\/\/\(.*\):\(.*\)/export LOCAL_PORT=\1\nexport REMOTE_HOST=\2\nexport REMOTE_PORT=\3/' > env

source env
export LOCAL_HOST=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`

tcp-proxy $LOCAL_PORT $REMOTE_HOST $REMOTE_PORT &

while true
do
	etcdctl -C "http://172.17.42.1:4001/" set \
		/services/${NAME:-$LISTEN_PORT} \
		"{ \"host\": \"$HOSTNAME\", \"ip\": \"$LOCAL_HOST\", \"port\": $LISTEN_PORT, \"version\": \"${VERSION:-1}\" }" --ttl 60
	sleep 45
done
