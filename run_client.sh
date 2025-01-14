if [ -z "${SERVER_IP+x}" ]; then
    echo "You must define server ip as env SERVER_IP"
    exit -1
fi

if [ -z "${SERVER_PORT+x}" ]; then
    echo "You must define server port as env SERVER_PORT"
    exit -1
fi

./udp2raw -c -l0.0.0.0:8888  -r$SERVER_IP:$SERVER_PORT  -k "passwd" --raw-mode faketcp -a --fix-gro &
cat extra.yaml >> config.yaml
./hysteria
