# cloudkey-letsencrypt
Guide to implement Letsencrypt on Unifi Cloud Key Gen2 (on Firmware v.2.0.24)

# Steps
1. Follow the detailed procedure written by James Ridgway here https://www.jamesridgway.co.uk/auto-renewing-ssl-certificate-unifi-cloud-key-lets-encrypt-cloudflare-dns-validation/

2. Make sure to use the adapted script in this repository (original from Gerd Naschenweng https://www.naschenweng.info/2017/01/06/securing-ubiquiti-unifi-cloud-key-encrypt-automatic-dns-01-challenge/)

3. Use this command instead of his one (substitute YOUR.DOMAIN.COM with your actual domain): 
```bash
acme.sh --force --issue --dns dns_cf -d YOUR.DOMAIN.COM --pre-hook "touch /etc/ssl/private/cert.tar; tar -zcvf /root/.acme.sh/CloudKeySSL_`date +%Y-%m-%d_%H.%M.%S`.tgz /etc/ssl/private/*" --fullchainpath /etc/ssl/private/cloudkey.crt --keypath /etc/ssl/private/cloudkey.key --reloadcmd "sh /root/.acme.sh/cloudkey-renew-hook.sh YOUR.DOMAIN.COM"
```

4. Add to crontab (substitute YOUR.DOMAIN.COM with your actual domain):
```bash
0 0 * * * /root/.acme.sh/acme.sh --renew --apache --renew-hook "/root/.acme.sh/cloudkey-renew-hook.sh YOUR.DOMAIN.COM" -d YOUR.DOMAIN.COM
```
