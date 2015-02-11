<IfModule mod_alias.c>
    Alias /owncloud /usr/share/webapps/owncloud/
</IfModule>

<VirtualHost *:80>
    ServerAdmin justin@dray.be
    ServerName cloud.dray.be
    ServerAlias cloud.dray.be
    Redirect / https://cloud.dray.be/
</VirtualHost>

<VirtualHost *:443>
    ServerAdmin justin@dray.be
    ServerName cloud.dray.be
    ErrorLog /var/log/httpd/cloud-error_log
    TransferLog /var/log/httpd/cloud-access_log

    SSLEngine On
    SSLCertificateFile    /etc/ssl/certs/cloud.dray.be.crt
    SSLCertificateKeyFile /etc/ssl/private/cloud.dray.be.pem
    SSLCertificateChainFile /etc/ssl/certs/sub.class1.server.ca.pem
    SSLCACertificateFile /etc/ssl/certs/ca.pem

    DocumentRoot /usr/share/webapps/owncloud
    <Directory /usr/share/webapps/owncloud/>
        Options FollowSymlinks
        AllowOverride all
        Require all granted
    </Directory>
</VirtualHost>
