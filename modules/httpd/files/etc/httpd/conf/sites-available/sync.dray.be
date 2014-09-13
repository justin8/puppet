<VirtualHost *:80>
	ServerAdmin justin@dray.be
	ServerName sync.dray.be
	ServerAlias sync.dray.be
	DocumentRoot /var/lib/btsync/sync
	ErrorLog "/var/log/httpd/sync-error_log"
	TransferLog "/var/log/httpd/sync-access_log"

	<Location />
		Options +Indexes +FollowSymLinks
		AllowOverride All
		Order allow,deny
		Allow from all
        AuthType Basic
        AuthName "sync.dray.be"
        AuthUserFile /srv/http/.htpasswd
        Require valid-user
	</Location>

    <Location /icons>
        Allow from all
        Satisfy Any
    </Location>

	<Location /public>
		Options -Indexes +FollowSymLinks
		AllowOverride All
		Order allow,deny
        Satisfy Any
		Allow from all
	</Location>
</VirtualHost>

<VirtualHost *:443>
	ServerAdmin justin@dray.be
	ServerName sync.dray.be
	ServerAlias sync.dray.be
	DocumentRoot /var/lib/btsync/sync
	<Location />
		Options +Indexes +FollowSymLinks
		AllowOverride All
		Order allow,deny
		Allow from all
	</Location>

    <Location /icons>
        Allow from all
        Satisfy Any
    </Location>

	<Location /public>
		Options -Indexes +FollowSymLinks
		AllowOverride All
		Order allow,deny
        Satisfy Any
		Allow from all
	</Location>
	
	SSLEngine on
	SSLCipherSuite HIGH:MEDIUM:!aNULL:!MD5
	SSLCertificateFile    /etc/ssl/certs/sync.dray.be.crt
	SSLCertificateKeyFile /etc/ssl/private/sync.dray.be.pem
	SSLCertificateChainFile /etc/ssl/certs/sub.class1.server.ca.pem
	SSLCACertificateFile /etc/ssl/certs/ca.pem

	<FilesMatch "\.(cgi|shtml|phtml|php)$">
		SSLOptions +StdEnvVars
	</FilesMatch>
	<Directory /usr/lib/cgi-bin>
		SSLOptions +StdEnvVars
	</Directory>
	BrowserMatch "MSIE [2-6]" \
		nokeepalive ssl-unclean-shutdown \
		downgrade-1.0 force-response-1.0
	BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown
</VirtualHost>
