#!/bin/bash

version="v2.6.0"
server_image_output="lry127/hysteria_server"
client_image_output="lry127/hysteria_client"

[ -d build-tmp ] && rm -rfv build-tmp
mkdir build-tmp
mkdir certs bin

wget -O bin/hysteria "https://github.com/apernet/hysteria/releases/download/app%2F$version/hysteria-linux-amd64-avx"
wget -O bin/udp2raw.tar.gz https://github.com/wangyu-/udp2raw/releases/download/20230206.0/udp2raw_binaries.tar.gz
tar xfv bin/udp2raw.tar.gz -C bin

openssl req -x509 -newkey rsa:2048 -keyout certs/key.pem -out certs/cert.pem -days 365 -nodes -subj "/C=US/CN=server"
fingerprint=$(openssl x509 -noout -fingerprint -sha256 -in certs/cert.pem | sed 's/^.*Fingerprint=//')

password=$(pwgen 16 1 -s)
cp server-template.yaml build-tmp/server.yaml
sed -i "s/__password_placeholder__/$password/g" build-tmp/server.yaml
cp client-template.yaml build-tmp/client.yaml
sed -i "s/__password_placeholder__/$password/g" build-tmp/client.yaml
sed -i "s/__certificate_sha256_placeholder__/$fingerprint/g" build-tmp/client.yaml

echo "Building server image: $server_image_output"
docker build . -f server.Dockerfile -t $server_image_output

echo "Building client image: $client_image_output"
docker build . -f client.Dockerfile -t $client_image_output

docker image save -o build-tmp/server.img $server_image_output
docker image save -o build-tmp/client.img $client_image_output

