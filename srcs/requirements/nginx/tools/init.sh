#!/bin/bash

# Lire domaine et chemin des certificats
domain_name_file="/secrets/domain.txt"
cert_path="/etc/ssl/certs/nginx-selfsigned.crt"
key_path="/etc/ssl/private/nginx-selfsigned.key"

if [ -f "$domain_name_file" ]
then
    DOMAIN_NAME=$(cat "$domain_name_file")
fi

# Générer certificat TLS auto-signé
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$key_path" \
    -out "$cert_path" \
    -subj "/C=BE/L=Brussels/O=42/OU=Students/CN=$DOMAIN_NAME"

# Créer fichier de conf nginx dynamique
echo "server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name $DOMAIN_NAME;

    ssl_certificate $cert_path;
    ssl_certificate_key $key_path;
    ssl_protocols TLSv1.3;

    index index.php;
    root /var/www/html;

    location ~ [^/]\.php(/|$) {
        try_files \$uri =404;
        fastcgi_pass wordpress:9000;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }
}" > /etc/nginx/sites-available/default

# Démarrer nginx
exec nginx -g "daemon off;"

