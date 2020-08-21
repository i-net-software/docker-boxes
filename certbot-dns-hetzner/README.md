# Certbot with Hetzner DNS verification

Allows to run DNS-01 challanges against the Hetzner DNS service.

    certbot certonly -n --agree-tos --email <EMAIL> --authenticator dns-hetzner --dns-hetzner-credentials /etc/letsencrypt/credentials.ini --dns-hetzner-propagation-seconds=<TIME> -d '*.mydomain.com'

Please check https://github.com/certbot/certbot and https://github.com/ctrlaltcoop/certbot-dns-hetzner for further information.

This repository merely reates the Docker Container with the given plugin.