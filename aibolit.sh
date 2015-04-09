wget http://www.revisium.com/ai/index.php?q=422472677150110458654037366666150 -O /root/ai-bolit.zip
unzip /root/ai-bolit.zip
cd /root/ai-bolit
nohup /usr/bin/php /root/ai-bolit/ai-bolit.php -p /var/www -m 256M -r /root/ai-bolit -l /root/ai-bolit &
