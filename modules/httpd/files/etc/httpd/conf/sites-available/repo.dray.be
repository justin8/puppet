<VirtualHost *:80>
	ServerAdmin justin@dray.be
	ServerName repo.dray.be
	ServerAlias repo.dray.be
	DocumentRoot /srv/repo
	ErrorLog "/var/log/httpd/repo-error_log"
	TransferLog "/var/log/httpd/repo-access_log"

	<Directory />
		Options Indexes FollowSymLinks
		AllowOverride All
		Order allow,deny
		Allow from all
	</Directory>
</VirtualHost>

<VirtualHost *:443>
	ServerAdmin justin@dray.be
	ServerName repo.dray.be
	ServerAlias repo.dray.be
	DocumentRoot /srv/repo
	<Directory />
		Options Indexes FollowSymLinks
		AllowOverride All
		Order allow,deny
		Allow from all
	</Directory>
	
	SSLEngine on
	SSLCipherSuite HIGH:MEDIUM:!aNULL:!MD5
	SSLCertificateFile    /etc/ssl/certs/repo.dray.be.crt
	SSLCertificateKeyFile /etc/ssl/private/repo.dray.be.pem
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
