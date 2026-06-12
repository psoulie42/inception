FROM debian:bookworm

RUN	apt-get update && apt-get upgrade -y && apt-get install -y mariadb-server && \
	rm -rf /var/lib/apt/lists/*

RUN	mkdir /var/run/mysqld && \
	chown -R mysql:mysql /var/run/mysqld && \
	chmod 644 /var/run/mysqld

COPY	./tools/maria_init.sh /usr/local/bin/maria_init.sh
COPY	./conf/0-maria.cnf /etc/mysql/mariadb.conf.d/0-maria.cnf

RUN chmod +x /usr/local/bin/maria_init.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/maria_init.sh"]
