# set version label
ARG BASE_VERSION

FROM pihole/pihole:"${BASE_VERSION}"
RUN apk add --no-cache \
    unbound

COPY unbound-pihole.conf /etc/unbound/unbound.conf.d/pi-hole.conf
COPY 99-edns.conf /etc/dnsmasq.d/99-edns.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]
