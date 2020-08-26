# Certbot with Hetzner DNS verification

Allows to run DNS-01 challanges against the Hetzner DNS service.

    certbot certonly -n --agree-tos --email <EMAIL> --authenticator dns-hetzner --dns-hetzner-credentials /etc/letsencrypt/credentials.ini --dns-hetzner-propagation-seconds=<TIME> -d '*.mydomain.com'

Please check https://github.com/certbot/certbot and https://github.com/ctrlaltcoop/certbot-dns-hetzner for further information.

This repository merely creates the Docker Container with the given plugin.

## Using this container with crontab

Services should usually directly be accessible by the certbot so the specific plugin can be used. However, it should very well be possible to use the container AND have foreign process restarted using the new certificate.

Here is an example for reloading an Apache after the certificate was issued:

    DOMAIN="your-domain.com"
    EMAIL="you@your-domain.com"
    (crontab -l 2>/dev/null; printf "\n# Renewal of the Letsencrypt Certificates\n0 6 * * 1 : Renewal of the Letsencrypt Certificates ; [ \$(date +%%d) -le 07 ] && docker pull inetsoftware/certbot-dns-hetzner && docker run --rm -v /etc/letsencrypt:/etc/letsencrypt -v /var/lib/letsencrypt:/var/lib/letsencrypt inetsoftware/certbot-dns-hetzner certonly --email "${EMAIL}" --agree-tos --authenticator dns-hetzner --dns-hetzner-credentials /etc/letsencrypt/credentials.ini --dns-hetzner-propagation-seconds=10 -q -d \"*.${DOMAIN}\" && [ \$(( \$(date +%%s) - \$(stat -Lc %%Y "/etc/letsencrypt/live/${DOMAIN}/fullchain.pem") )) -lt 60 ] && service apache2 reload && echo \"Reloaded Apache Certificate\"\n\n") | crontab -

The important bits:

    # your domain
    DOMAIN="your-domain.com"
   
    # Add the following printf statement at the end of the crontab o the current user
    (crontab -l 2>/dev/null; printf " ... ") | crontab -

    # on every monday at 6 am
    ... 0 6 * * 1 ...

    # but only run on every FIRST monday of the month
    ... [ $(date +%d) -le 07 ] && ...

    # Fetch the new container
    ... docker pull inetsoftware/certbot-dns-hetzner ...

    # Docker run command, including removal at the end
    ... docker run --rm -v /etc/letsencrypt:/etc/letsencrypt -v /var/lib/letsencrypt:/var/lib/letsencrypt inetsoftware/certbot-dns-hetzner certonly --email "${EMAIL}" --agree-tos --authenticator dns-hetzner --dns-hetzner-credentials /etc/letsencrypt/credentials.ini --dns-hetzner-propagation-seconds=10 -q -d "*.${DOMAIN}" ...

    # if successfull, check if the certificate has in deed been updated (within the last minute)
    ... && [ $(( $(date +%s) - $(stat -Lc %Y "/etc/letsencrypt/live/${DOMAIN}/fullchain.pem") )) -lt 60 ]

    # reload the apache config if successfull
    ... && service apache2 reload
