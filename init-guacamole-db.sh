#!/bin/bash

# Only initialize if not already done
if [ ! -f /var/lib/mysql/guacamole_initialized ]; then
    echo "Initializing Guacamole database for the first time..."
    
    # Create database and user
    mysql -uroot <<-EOF
    CREATE DATABASE IF NOT EXISTS guacamole_db;
    CREATE USER IF NOT EXISTS 'guacamole_user'@'localhost' IDENTIFIED BY 'guacamole_password';
    GRANT ALL PRIVILEGES ON guacamole_db.* TO 'guacamole_user'@'localhost';
    FLUSH PRIVILEGES;
    EOF
    
    # Load schema
    echo "Loading Guacamole schema..."
    cat /opt/guacamole/mysql/schema/*.sql | mysql -uroot guacamole_db
    
    # Create marker file
    touch /var/lib/mysql/guacamole_initialized
    echo "✅ Guacamole database initialized!"
else
    echo "Guacamole database already initialized, skipping..."
fi
