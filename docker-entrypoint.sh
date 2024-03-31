#!/bin/bash


SERVICESD=$(ls /etc/services.d/)
for SERVICED in ${SERVICESD}; do
	echo starting $SERVICED service
	/etc/services.d/$SERVICED/run &
done

echo starting pihole
/usr/bin/start.sh

exec "$@"
