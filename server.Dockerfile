FROM ubuntu:24.04

RUN apt update && apt install -y iptables

WORKDIR /server

COPY bin/hysteria .
COPY bin/udp2raw_amd64 udp2raw

RUN chmod +x *
COPY run_server.sh .

COPY certs /certs
COPY build-tmp/server.yaml config.yaml

ENTRYPOINT [ "bash", "run_server.sh" ]
