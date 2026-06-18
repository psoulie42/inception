#!/bin/sh

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/${SQL_DATABASE}" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
    mysqld_safe --skip-networking &

    until mysqladmin ping --silent 2>/dev/null; do
        echo "Waiting for MariaDB..."
        sleep 1
    done

    mysql -u root <<-EOF
        FLUSH PRIVILEGES;
        CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
        FLUSH PRIVILEGES;
EOF

    mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown

    echo "MariaDB initialized."
fi

exec mysqld_safe
