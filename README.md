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
  -e 'FTLCONF_webserver_api_password'='******' \
  -v "$PWD/pihole/pihole/":'/etc/pihole/':'rw' \
  -v "$PWD/pihole/dnsmasq.d/":'/etc/dnsmasq.d/':'rw' \
  --cap-add=NET_ADMIN \
  --hostname=pihole \
  'fabianbees/pihole-unbound:development-v6'
```


### Required environment variables

> Vars and descriptions replicated from the [official pihole container](https://github.com/pi-hole/docker-pi-hole/):

| Docker Environment Var | Description|
| --- | --- |
| `TZ: <Timezone>`<br/> | Set your [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) to make sure logs rotate at local midnight instead of at UTC midnight.
| `FTLCONF_webserver_api_password: <Admin password>`<br/> | http://pi.hole/admin password. Run `docker logs pihole \| grep random` to find your random pass.
| `FTLCONF_dns_revServers: <enabled>,<ip-address>[/<prefix-len>],<server>[#<port>],<domain>`<br/> | Enable Reverse server (former also called "conditional forwarding") feature
| `USE_IPV6: <"true"\|"false">`<br/>| Set to `true` if ipv6 is needed for unbound (not required in most use-cases)

Example `.env` file in the same directory as your `docker-compose.yaml` file:

```
TZ=America/Los_Angeles
FTLCONF_webserver_api_password=QWERTY123456asdfASDF
FTLCONF_dns_revServers=true,192.168.0.0/16,192.168.1.1,local
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
