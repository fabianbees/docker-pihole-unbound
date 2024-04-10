#!/command/with-contenv bash

# set num-threads for unbound matching the running machine
sed -i "s/num-threads: 1/num-threads: $(nproc)/" /etc/unbound/unbound.conf.d/pi-hole.conf
if [ "$USE_IPV6" == "true" ]; then
    sed -i "s/do-ip6: no/do-ip6: yes/" /etc/unbound/unbound.conf.d/pi-hole.conf
fi


s6-echo "Starting unbound"

NAME="unbound"
DESC="DNS server"
DAEMON="/usr/sbin/unbound"
PIDFILE="/run/unbound.pid"

HELPER="/usr/lib/unbound/package-helper"

test -x $DAEMON || exit 0

# Override this variable by editing or creating /etc/default/unbound.
DAEMON_OPTS=""

if [ -f /etc/default/unbound ]; then
    . /etc/default/unbound
fi

$HELPER chroot_setup
$HELPER root_trust_anchor_update 2>&1 | logger -p daemon.info -t unbound-anchor

$DAEMON -d $DAEMON_OPTS
