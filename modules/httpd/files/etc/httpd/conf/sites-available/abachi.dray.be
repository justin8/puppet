<VirtualHost _default_:80>
	ServerName abachi.dray.be
	ServerAlias abachi.dray.be
	ServerAdmin justin@dray.be
	Redirect / https://abachi.dray.be/
</VirtualHost>

<VirtualHost _default_:443>

	ServerAdmin justin@dray.be
	DocumentRoot /srv/http
	ErrorLog "/var/log/httpd/abachi-error_log"
	TransferLog "/var/log/httpd/abachi-access_log"

	<Directory />
		Options Indexes FollowSymLinks
		AllowOverride All
		Order allow,deny
		Allow from all
		AuthType Basic
		AuthName "abachi.dray.be"
		AuthUserFile /srv/http/.htpasswd
		Require valid-user
	</Directory>

	SSLEngine on

	SSLCertificateFile    /etc/ssl/certs/abachi.dray.be.crt
	SSLCertificateKeyFile /etc/ssl/private/abachi.dray.be.pem
	SSLCertificateChainFile /etc/ssl/certs/sub.class1.server.ca.pem
	SSLCACertificateFile /etc/ssl/certs/ca.pem
    ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://127.0.0.1:9000/srv/http/$1
	
	<FilesMatch "\.(cgi|shtml|phtml|php)$">
		SSLOptions +StdEnvVars
	</FilesMatch>
	<Directory /usr/lib/cgi-bin>
		SSLOptions +StdEnvVars
	</Directory>

	<Directory /srv/http/bonnie2gchart>
		Satisfy Any
	</Directory>

	<Directory /srv/http/arch>
		Satisfy Any
	</Directory>

</VirtualHost>
