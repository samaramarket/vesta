<VirtualHost %ip%:%web_port%>
  ServerName  %domain_idn%
	ServerAlias %alias_string%
  ServerAdmin %email%
	DocumentRoot  %sdocroot%
  ScriptAlias /cgi-bin/ %home%/%user%/web/%domain%/cgi-bin/
  Alias /vstats/ %home%/%user%/web/%domain%/stats/
  Alias /error/ %home%/%user%/web/%domain%/document_errors/

  #SuexecUserGroup %user% %group%
  CustomLog /var/log/%web_system%/domains/%domain%.bytes bytes
  CustomLog /var/log/%web_system%/domains/%domain%.log combined
  ErrorLog /var/log/%web_system%/domains/%domain%.error.log

	<IfModule mod_rewrite.c>
		#Nginx should have "proxy_set_header HTTPS YES;" in location
		RewriteEngine On
		RewriteCond %{HTTP:HTTPS} =YES
		RewriteRule .* - [E=HTTPS:on,L]
	</IfModule>

	<FilesMatch "\.php$">
		#	AddType application/x-httpd-php .php
		SetHandler "proxy:unix:%backend_lsnr%"
	</FilesMatch>

	<Directory />
		Options FollowSymLinks
		AllowOverride None
	</Directory>

	<DirectoryMatch .*\.svn/.*>
        Require all denied
	</DirectoryMatch>

	<DirectoryMatch .*\.git/.*>
		 Require all denied
	</DirectoryMatch>

	<DirectoryMatch .*\.hg/.*>
		 Require all denied
	</DirectoryMatch>

  <Directory %sdocroot%>
    AllowOverride All
    SSLRequireSSL
    DirectoryIndex index.php index.html index.htm
    Require all granted
    Options +Includes -Indexes +ExecCGI +FollowSymLinks +MultiViews
    php_admin_value sendmail_path "/usr/sbin/sendmail -t -i -f noreply@%domain_idn%"
    php_admin_value open_basedir %sdocroot%:%home%/%user%/tmp:/bin:/usr/bin:/usr/local/bin:/var/www/html:/tmp:/usr/share:/etc/phpMyAdmin:/etc/phpmyadmin:/var/lib/phpmyadmin:/etc/roundcubemail:/etc/roundcube:/var/lib/roundcube
    php_admin_value upload_tmp_dir %home%/%user%/tmp
    php_admin_value session.save_path %home%/%user%/tmp
  </Directory>

	<Directory %sdocroot%/bitrix/cache>
		AllowOverride none
    Require all denied
	</Directory>

	<Directory %sdocroot%/bitrix/managed_cache>
		AllowOverride none
    Require all denied
	</Directory>

	<Directory %sdocroot%/bitrix/local_cache>
		AllowOverride none
    Require all denied
	</Directory>

	<Directory %sdocroot%/bitrix/stack_cache>
		AllowOverride none
    Require all denied
	</Directory>

	<Directory %sdocroot%/upload>
		AllowOverride none
		AddType text/plain php,php3,php4,php5,php6,phtml,pl,asp,aspx,cgi,dll,exe,ico,shtm,shtml,fcg,fcgi,fpl,asmx,pht
		php_value engine off
	</Directory>

	<Directory %sdocroot%/upload/support/not_image>
		AllowOverride none
    Require all denied
	</Directory>

	<Directory %sdocroot%/bitrix/images>
		AllowOverride none
		AddType text/plain php,php3,php4,php5,php6,phtml,pl,asp,aspx,cgi,dll,exe,ico,shtm,shtml,fcg,fcgi,fpl,asmx,pht
		php_value engine off
	</Directory>

	<Directory %sdocroot%/bitrix/tmp>
		AllowOverride none
		AddType text/plain php,php3,php4,php5,php6,phtml,pl,asp,aspx,cgi,dll,exe,ico,shtm,shtml,fcg,fcgi,fpl,asmx,pht
		php_value engine off
	</Directory>

    <Directory %home%/%user%/web/%domain%/stats>
      AllowOverride All
    </Directory>


  <IfModule mod_ruid2.c>
    RMode config
    RUidGid %user% %group%
    RGroups apache
  </IfModule>
  <IfModule itk.c>
    AssignUserID %user% %group%
  </IfModule>

  IncludeOptional %home%/%user%/conf/web/s%web_system%.%domain%.conf*
</VirtualHost>