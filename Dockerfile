FROM wordpress:cli-2.4.0-php7.4
LABEL maintainer="Paapa Abdullah Morgan <paapaabdullahm@gmail.com>"

VOLUME /etc/nginx/html
WORKDIR /etc/nginx/html

USER www-data
CMD ["wp", "shell"]
