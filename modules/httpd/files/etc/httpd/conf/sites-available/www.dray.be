<VirtualHost _default_:80>
        ServerAdmin justin@dray.be
        Redirect / https://www.dray.be/
</VirtualHost>

AddType application/x-x509-ca-cert .crt
AddType application/x-pkcs7-crl    .crl

SSLPassPhraseDialog  builtin
SSLSessionCache        "shmcb:/var/run/httpd/ssl_scache(512000)"
SSLSessionCacheTimeout  300
SSLMutex  "file:/var/run/httpd/ssl_mutex"

<VirtualHost _default_:443>

	ServerAdmin justin@dray.be
	DocumentRoot /srv/http
	ErrorLog "/var/log/httpd/www-error_log"
	TransferLog "/var/log/httpd/www-access_log"

	<Directory />
		Options Indexes FollowSymLinks
		AllowOverride All
		Order allow,deny
		Allow from all
		php_admin_value open_basedir "/srv/:/tmp/:/usr/share/webapps/:/etc/webapps:$"
	</Directory>

	SSLEngine on
	SSLCipherSuite ALL:!ADH:!EXPORT:!SSLv2:RC4+RSA:+HIGH:+MEDIUM

	SSLCertificateFile    /etc/ssl/certs/www.dray.be.crt
	SSLCertificateKeyFile /etc/ssl/private/www.dray.be.pem
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
	# MSIE 7 and newer should be able to use keepalive
	BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown

</VirtualHost>
