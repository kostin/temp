#!/bin/bash

#rm -rf /usr/share/nginx/cache/fcgi/*

if [ ! -f /var/log/warmer.log ]; then
  touch /var/log/warmer.log
  echo $(date +'%Y-%m-%d %H:%S')" Warmer log created..." > /var/log/warmer.log
fi

echo $(date +'%Y-%m-%d %H:%S')" Warmer starting..." >> /var/log/warmer.log

/usr/bin/curl --silent  http://www.gssport.s08.yazato.ru/sitemap.xml | egrep -o "http://$URL[^<\"> ]+" > /var/log/sitemap.xml

echo $(date +'%Y-%m-%d %H:%S')" Warmer queue length is "$(cat /var/log/sitemap.xml | wc -l) >> /var/log/warmer.log

for LINE in $(cat /var/log/sitemap.xml);
do
  START=$(date +%s%N | cut -b1-13)
  URL="${LINE}"
  RES=$(/usr/bin/curl --silent --max-time 10 --header "cache-purge: 1" -IL "$URL")
  STOP=$(date +%s%N | cut -b1-13)
  CODE=$(echo "${RES}" | grep -e 'HTTP' | tr -d '\n\r')
  HIT=$(echo "${RES}" | grep -e 'X-Nginx-Cache' | tr -d '\n\r')
  TIME=$((STOP-START))
  echo $(date +'%Y-%m-%d %H:%S')" Warmed in ${TIME}ms url ${URL} with ${CODE} ${HIT}" >> /var/log/warmer.log
done

echo $(date +'%Y-%m-%d %H:%S')" Warmer finished..." >> /var/log/warmer.log
