# Pi-Hole + Unbound - 1 Container

## Description

This Docker deployment runs both Pi-Hole and Unbound in a single container. 

The base image for the container is the [official Pi-Hole container](https://hub.docker.com/r/pihole/pihole), with an extra build step added to install the Unbound resolver directly into to the container based on [instructions provided directly by the Pi-Hole team](https://docs.pi-hole.net/guides/unbound/).

## Usage

First create a `.env` file to substitute variables for your deployment. 

## Docker run

```bash
docker run -d \
  --name='pihole' \
  -e TZ="Europe/Berlin" \
  -e 'TCP_PORT_53'='53' -e 'UDP_PORT_53'='53' -e 'UDP_PORT_67'='67' -e 'TCP_PORT_80'='80' -e 'TCP_PORT_443'='443' \
  -e 'TZ'='Europe/Berlin' \
  -e 'WEBPASSWORD'='******' \
  -v "$PWD/pihole/pihole/":'/etc/pihole/':'rw' \
  -v "$PWD/pihole/dnsmasq.d/":'/etc/dnsmasq.d/':'rw' \
  -v "$PWD/pihole/external.conf":'/etc/lighttpd/external.conf':'rw' \
  --cap-add=NET_ADMIN \
  --hostname=pihole \
  'fabianbees/pihole-unbound:latest'
```


### Required environment variables

> Vars and descriptions replicated from the [official pihole container](https://github.com/pi-hole/docker-pi-hole/):

| Docker Environment Var | Description|
| --- | --- |
| `FTLCONF_LOCAL_IPV4: <Host's IP>`<br/> | **--net=host mode requires** Set to your server's LAN IP, used by web block modes and lighttpd bind address
| `TZ: <Timezone>`<br/> | Set your [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) to make sure logs rotate at local midnight instead of at UTC midnight.
| `WEBPASSWORD: <Admin password>`<br/> | http://pi.hole/admin password. Run `docker logs pihole \| grep random` to find your random pass.
| `REV_SERVER: <"true"\|"false">`<br/> | Enable DNS conditional forwarding for device name resolution
| `REV_SERVER_DOMAIN: <Network Domain>`<br/> | If conditional forwarding is enabled, set the domain of the local network router
| `REV_SERVER_TARGET: <Router's IP>`<br/> | If conditional forwarding is enabled, set the IP of the local network router
| `REV_SERVER_CIDR: <Reverse DNS>`<br/>| If conditional forwarding is enabled, set the reverse DNS zone (e.g. `192.168.0.0/24`)
| `USE_IPV6: <"true"\|"false">`<br/>| Set to `true` if ipv6 is needed for unbound (not required in most use-cases)

Example `.env` file in the same directory as your `docker-compose.yaml` file:

```
FTLCONF_LOCAL_IPV4=192.168.1.10
TZ=America/Los_Angeles
WEBPASSWORD=QWERTY123456asdfASDF
REV_SERVER=true
REV_SERVER_DOMAIN=local
REV_SERVER_TARGET=192.168.1.1
REV_SERVER_CIDR=192.168.0.0/16
HOSTNAME=pihole
DOMAIN_NAME=pihole.local
```

### Using Portainer stacks?

Portainer stacks are a little weird and don't want you to declare your named volumes, so remove this block from the top of the `docker-compose.yaml` file before copy/pasting into Portainer's stack editor:

```yaml
volumes:
  etc_pihole-unbound:
  etc_pihole_dnsmasq-unbound:
```

### Running the stack

```bash
docker-compose up -d
```

> If using Portainer, just paste the `docker-compose.yaml` contents into the stack config and add your *environment variables* directly in the UI.
