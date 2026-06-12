FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && apt-get install -y nginx openssl && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl && openssl req -x509 -nodes \
	-newkey rsa:2048 -keyout /etc/nginx/ssl/priv.key \
	-out /etc/nginx/ssl/cert.crt \
	-subj "/C=CH/ST=VD/L=Lausanne/O=42/OU=42/CN=squement.42.fr/UID=squement"

COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]