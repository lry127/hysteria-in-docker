FROM ubuntu:24.04

RUN apt update && apt install -y iptables

WORKDIR /client

COPY bin/hysteria .
COPY bin/udp2raw_amd64 udp2raw

RUN chmod +x *

COPY client_extra.yaml extra.yaml

COPY run_client.sh .
COPY build-tmp/client.yaml config.yaml

ENTRYPOINT [ "bash", "run_client.sh" ]
