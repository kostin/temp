#!/bin/bash

rm -rf /usr/share/nginx/cache/fcgi/*

if [ ! -f /var/log/warmer.log ]; then
  touch /var/log/warmer.log
  echo $(date +'%Y-%m-%d %H:%S')" Warmer log created..." > /var/log/warmer.log
fi

echo $(date +'%Y-%m-%d %H:%S')" Warmer starting..." >> /var/log/warmer.log

/usr/bin/curl --silent  http://www.gssportng.s05.yazato.ru/sitemap.xml?cache=purge | egrep -o "http://$URL[^<\"> ]+" > /var/log/sitemap.xml

for line in $(cat /var/log/sitemap.xml);
do
  url="${line}"
  res=$(/usr/bin/curl -IL "$url")
  code=$(echo "$res" | grep -e 'HTTP')
  hit=$(echo "$res" | grep -e 'X-Nginx-Cache')
  echo $(date +'%Y-%m-%d %H:%S')" Warming $url $hit" >> /var/log/warmer.log
done

echo $(date +'%Y-%m-%d %H:%S')" Warmer finished..." >> /var/log/warmer.log
