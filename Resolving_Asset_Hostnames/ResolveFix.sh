#!/bin/sh
hostentries=`sshpass -p $PASS mysql --default-character-set=utf8 -A -u $USER -h $HOST $DB -p -N -e "select hostname from host where hostname like 'Host-%';"`

for hostentry in $hostentries
do
  addr=`echo $hostentry | sed -r 's/Host-//g;s/-/./g'`
  fqdn=`dig -x $addr +short |sed s/.$//`
  if [ -n "$fqdn" ]; then
    hostname=`echo $fqdn | cut -d"." -f1`
    echo $hostentry \($addr\) is going to be replaced for $fqdn \($hostname\)
    sshpass -p $PASS mysql --default-character-set=utf8 -A -u $USER -h $HOST $DB -p -e "update host set hostname='$hostname',fqdns='$fqdn' where hostname='$hostentry';"
  fi
done
