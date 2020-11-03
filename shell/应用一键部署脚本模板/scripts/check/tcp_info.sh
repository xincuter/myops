HOST_IP=$(ifconfig | grep inet | grep -v "127.0.0.1" | awk -F'[ :]+' '{print $4}')
HOST_NAME=$(hostname)

ss | awk 'BEGIN{print "'"$HOST_IP($HOST_NAME)"' tcp connection as follow: "} $1!~/State/{count[$1]++} END{for(i in count) print i,count[i]}'
