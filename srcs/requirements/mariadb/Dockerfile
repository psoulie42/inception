FROM debian:bookworm

RUN	apt-get update && apt-get upgrade -y && apt-get install -y mariadb-server && \
	rm -rf /var/lib/apt/lists/*

RUN	mkdir /var/run/mysqld && \
	chown -R mysql:mysql /var/run/mysqld && \
	chmod 777 /var/run/mysqld

COPY	./tools/init.sh /usr/local/bin/init.sh
COPY	./conf/mariadb.cnf /etc/mysql/mariadb.conf.d/mariadb.cnf

RUN chmod +x /usr/local/bin/init.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/init.sh"]
