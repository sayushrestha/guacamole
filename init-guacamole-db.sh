#!/bin/bash

# Initialize MySQL database
mysql_install_db --user=mysql --ldata=/var/lib/mysql

# Start MySQL temporarily to create Guacamole database
/usr/bin/mysqld_safe --datadir='/var/lib/mysql' &
MYSQL_PID=$!

# Wait for MySQL to start
for i in {1..30}; do
    if mysqladmin ping --silent; then
        break
    fi
    sleep 1
done

# Create database and user
mysql -uroot <<-EOF
CREATE DATABASE guacamole_db;
CREATE USER 'guacamole_user'@'localhost' IDENTIFIED BY 'guacamole_password';
GRANT ALL PRIVILEGES ON guacamole_db.* TO 'guacamole_user'@'localhost';
FLUSH PRIVILEGES;
EOF

# Load schema
cat /opt/guacamole/mysql/schema/*.sql | mysql -uroot guacamole_db

# Stop MySQL
kill $MYSQL_PID
wait $MYSQL_PID