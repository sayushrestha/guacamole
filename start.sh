#!/bin/bash
set -e

# Function to start MySQL safely
start_mysql() {
    echo "Starting MySQL..."
    mysqld_safe --datadir='/var/lib/mysql' --nowatch
    sleep 5  # Give MySQL time to start
    
    # Wait for MySQL to be ready
    for i in {1..30}; do
        if mysqladmin ping --silent; then
            echo "MySQL is ready!"
            return 0
        fi
        sleep 1
    done
    echo "MySQL failed to start"
    return 1
}

# Function to initialize Guacamole database
init_guacamole_db() {
    if [ ! -f /var/lib/mysql/guacamole_initialized ]; then
        echo "Initializing Guacamole database..."
        
        # Create database and user
        mysql -uroot <<-EOF
        CREATE DATABASE IF NOT EXISTS guacamole_db;
        CREATE USER IF NOT EXISTS 'guacamole_user'@'localhost' IDENTIFIED BY 'guacamole_password';
        GRANT ALL PRIVILEGES ON guacamole_db.* TO 'guacamole_user'@'localhost';
        FLUSH PRIVILEGES;
        EOF
        
        # Load schema
        cat /opt/guacamole/mysql/schema/*.sql | mysql -uroot guacamole_db
        
        # Create initialization marker
        touch /var/lib/mysql/guacamole_initialized
        echo "Guacamole database initialized"
    else
        echo "Guacamole database already initialized"
    fi
}

# Function to start guacd
start_guacd() {
    echo "Starting guacd..."
    guacd -b 0.0.0.0 -L $GUACD_LOG_LEVEL -f
}

# Function to start Tomcat with Guacamole
start_guacamole() {
    echo "Starting Guacamole..."
    catalina.sh run
}

# Main execution
if [ "$1" = 'guacamole' ]; then
    # Start all services
    start_mysql
    init_guacamole_db
    
    # Start guacd in background
    start_guacd &
    
    # Start Guacamole in foreground
    start_guacamole
else
    # Just run the command if not starting guacamole
    exec "$@"
fi