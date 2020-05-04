server {
    listen      %ip%:%web_port%;
    server_name %domain_idn% %alias_idn%;
    root        %docroot%;
    index       index.php index.html index.htm;
    access_log  /var/log/nginx/domains/%domain%.log combined;
    access_log  /var/log/nginx/domains/%domain%.bytes bytes;
    error_log   /var/log/nginx/domains/%domain%.error.log error;

    server_name_in_redirect off;

    proxy_set_header	X-Real-IP $remote_addr;
    proxy_set_header	X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header	Host $host:80;

    set $proxyserver    "http://127.0.0.1:8888";
    set $imcontenttype	"text/html; charset=utf-8";
    set $docroot		"%docroot%";
    proxy_ignore_client_abort off;

    # Redirect to ssl if need
    if (-f %docroot%/.htsecure) { rewrite ^(.*)$ https://$host$1 permanent; }

    # Include parameters common to all websites
    include bx/conf//etc/nginx/bx/conf/bitrix.conf

    location /vstats/ {
        alias   %home%/%user%/web/%domain%/stats/;
        include %home%/%user%/conf/web/%domain%.auth*;
    }

    include     /etc/nginx/conf.d/phpmyadmin.inc*;
    include     /etc/nginx/conf.d/phppgadmin.inc*;
    include     /etc/nginx/conf.d/webmail.inc*;

    include     %home%/%user%/conf/web/nginx.%domain%.conf*;
}
