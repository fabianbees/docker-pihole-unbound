#!/bin/bash -e

# set num-threads for unbound matching the running machine
sed -i "s/num-threads: 1/num-threads: $(nproc --all)/" /etc/unbound/unbound.conf.d/pi-hole.conf

/etc/init.d/unbound start
/s6-init