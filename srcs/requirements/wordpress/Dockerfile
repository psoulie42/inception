FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && apt-get install -y curl php8.2-fpm php8.2-mysql mariadb-client && \
	rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

COPY ./tools/wp-entrypoint.sh /usr/local/bin/wp-entrypoint.sh

RUN chmod +x /usr/local/bin/wp-entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wp-entrypoint.sh"]