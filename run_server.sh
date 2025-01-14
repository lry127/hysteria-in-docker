./udp2raw -s -l0.0.0.0:8090 -r127.0.0.1:443 -k "passwd" --raw-mode faketcp -a --fix-gro &
./hysteria server
