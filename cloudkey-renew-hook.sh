#!/bin/bash
# Renew-hook for ACME / Let's encrypt
echo "** Configuring new Let's Encrypt certs"
cd /etc/ssl/private
rm -f /etc/ssl/private/cert.tar /etc/ssl/private/unifi.keystore.jks /etc/ssl/private/ssl-cert-snakeoil.key /etc/ssl/private/fullchain.pem

openssl pkcs12 -export -in /etc/ssl/private/cloudkey.crt -inkey /etc/ssl/private/cloudkey.key -out /etc/ssl/private/cloudkey.p12 -name unifi -password pass:aircontrolenterprise

keytool -importkeystore -deststorepass aircontrolenterprise -destkeypass aircontrolenterprise -destkeystore /usr/lib/unifi/data/keystore -srckeystore /etc/ssl/private/cloudkey.p12 -srcstoretype PKCS12 -srcstorepass aircontrolenterprise -alias unifi

rm -f /etc/ssl/private/cloudkey.p12
tar -cvf cert.tar *
chown root:ssl-cert /etc/ssl/private/*
chmod 640 /etc/ssl/private/*


echo "** Backup of current certificates in /data/unifi-core/config"
mv /data/unifi-core/config/unifi-core.key /data/unifi-core/config/unifi-core.key_`date +%y-%m-%y_%H-%M`.bkp
mv /data/unifi-core/config/unifi-core.crt /data/unifi-core/config/unifi-core.crt_`date +%y-%m-%y_%H-%M`.bkp

echo "** Moving the certificates in the data directory"
cp /root/.acme.sh/$1/$1.key /data/unifi-core/config/unifi-core.key
cp /root/.acme.sh/$1/$1.cer /data/unifi-core/config/unifi-core.crt

echo "** Restarting Unifi Core"
service unifi-core restart
