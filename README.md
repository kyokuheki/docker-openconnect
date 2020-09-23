# docker-openconnect
Dockernized openconnect 

## run

Connect AnyConnect VPN with host's networking namespace.

```shell
docker run -dit --name=openconnect --net=host --cap-add=NET_ADMIN kyokuheki/openconnect --config=CONFIGFILE --script wrapper-vpnc-script vpnocserv.example.com
```

Connect AnyConnect VPN in a container.

```shell
docker run -dit --name=openconnect --cap-add=NET_ADMIN kyokuheki/openconnect --config=CONFIGFILE --script wrapper-vpnc-script vpnocserv.example.com
# and connect another container into openconnect container
docker run -it --name=anothercontainer --net=container:openconnect alpine
```

With the `--cap-add=NET_ADMIN` option enabled, the device option (`--device /dev/net/tun:/dev/net/tun`) is no longer needed.

## config file

config file example

```
user=USERNAME
passwd-on-stdin
no-dtls
verbose
# timestamp
# proxy=URL
# libproxy
# servercert=FINGERPRINT
# cafile=FILE
```

```shell
docker run -it --rm --name=openconnect kyokuheki/openconnect --config=CONFIGFILE vpnocserv.example.com 
```

## wrapper vpnc-script

add routes (10.0.0.0/8 and 100.83.24.0/21) instead of default route

```shell
cat >>wrapper-vpnc-script <<_EOT_
#!/usr/bin/env sh
CISCO_SPLIT_INC=2
CISCO_SPLIT_INC_0_ADDR=10.0.0.0
CISCO_SPLIT_INC_0_MASK=255.0.0.0
CISCO_SPLIT_INC_0_MASKLEN=8
CISCO_SPLIT_INC_0_PROTOCOL=0
CISCO_SPLIT_INC_0_SPORT=0
CISCO_SPLIT_INC_0_DPORT=0

CISCO_SPLIT_INC_1_ADDR=100.83.24.0
CISCO_SPLIT_INC_1_MASK=255.255.248.0
CISCO_SPLIT_INC_1_MASKLEN=21
CISCO_SPLIT_INC_1_PROTOCOL=0
CISCO_SPLIT_INC_1_SPORT=0
CISCO_SPLIT_INC_1_DPORT=0

. /etc/vpnc/vpnc-script
_EOT_
chmod +x wrapper-vpnc-script

docker run -it --rm --name=openconnect kyokuheki/openconnect --script wrapper-vpnc-script vpnocserv.example.com 
```

see https://gitlab.com/openconnect/vpnc-scripts/-/blob/master/vpnc-script

