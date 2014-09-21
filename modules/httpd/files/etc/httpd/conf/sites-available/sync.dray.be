#
# Distributed authoring and versioning (WebDAV)
#
# Required modules: mod_alias, mod_auth_digest, mod_authn_core, mod_authn_file,
#                   mod_authz_core, mod_authz_user, mod_dav, mod_dav_fs,
#                   mod_setenvif

# The following example gives DAV write access to a directory called
# "uploads" under the ServerRoot directory.
#
# The User/Group specified in httpd.conf needs to have write permissions
# on the directory where the DavLockDB is placed and on any directory where
# "Dav On" is specified.

LoadModule dav_module modules/mod_dav.so
LoadModule dav_fs_module modules/mod_dav_fs.so
LoadModule dav_lock_module modules/mod_dav_lock.so

DavLockDB "/var/lib/btsync/DavLock"

#
# The following directives disable redirects on non-GET requests for
# a directory that does not include the trailing slash.  This fixes a 
# problem with several clients that do not appropriately handle 
# redirects for folders with DAV methods.
#
BrowserMatch "Microsoft Data Access Internet Publishing Provider" redirect-carefully
BrowserMatch "MS FrontPage" redirect-carefully
BrowserMatch "^WebDrive" redirect-carefully
BrowserMatch "^WebDAVFS/1.[01234]" redirect-carefully
BrowserMatch "^gnome-vfs/1.0" redirect-carefully
BrowserMatch "^XML Spy" redirect-carefully
BrowserMatch "^Dreamweaver-WebDAV-SCM1" redirect-carefully
BrowserMatch " Konqueror/4" redirect-carefully

<VirtualHost *:80>
    ServerAdmin justin@dray.be
    ServerName sync.dray.be
    ServerAlias sync.dray.be
    DocumentRoot /srv/sync
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
    DocumentRoot /srv/sync
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

    Alias /uploads "/srv/sync"
    <Location /uploads>
        Dav On
        AuthType Basic
        AuthName "sync.dray.be"
        AuthUserFile /srv/http/.htpasswd
        Require valid-user
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
