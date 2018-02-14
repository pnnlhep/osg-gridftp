#!/bin/bash -e

if [ "x$SKIP_ENV" = "x" ]; then
. /etc/setup.sh
fi #end "x$SKIP_ENV" = "x" ]

(
if [ "x$START_WAIT_FILE" != "x" ]; then
	while true; do
		[ -f "$START_WAIT_FILE" ] && break
		sleep 1
	done
fi
if [ -f /etc/start.extra.sh ]; then
  . /etc/start.extra.sh
fi
cd /tmp
exec /usr/sbin/globus-gridftp-server -c /etc/gridftp.conf -C /etc/gridftp.d -pidfile /var/run/globus-gridftp-server.pid
) & pid=$!

trap "kill $pid" TERM
echo $pid > /var/run/gridftp.pid
if [ "x$START_WAIT_DONE_FILE" != "x" ]; then
	touch "$START_WAIT_DONE_FILE"
fi
wait $pid
[ -f /etc/shutdown.sh ] && bash /etc/shutdown.sh
