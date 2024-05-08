#!/bin/bash -e

UNBOUND_CONF="/etc/unbound/unbound.conf.d/pi-hole.conf"

DAEMON="/usr/sbin/unbound"
DAEMON_OPTS=""

ANCHOR="/usr/sbin/unbound-anchor"

PIHOLE="/usr/bin/start.sh"

# ----------------------------------------------------------------

# set num-threads for unbound matching the running machine
sed -i "s/num-threads: 1/num-threads: $(nproc)/" $UNBOUND_CONF
if [ "$USE_IPV6" == "true" ]; then
    sed -i "s/do-ip6: no/do-ip6: yes/" $UNBOUND_CONF
fi


echo starting unbound
$ANCHOR -v
$DAEMON -d $DAEMON_OPTS -c $UNBOUND_CONF &


echo starting pihole
$PIHOLE


exec "$@"
