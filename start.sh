#!/bin/bash
set -e

# Start MySQL
echo "🚀 Starting MySQL..."
mysqld_safe --datadir='/var/lib/mysql' --nowatch

# Wait for MySQL to be ready
echo "⏳ Waiting for MySQL to be ready..."
for i in {1..30}; do
    if mysqladmin ping --silent; then
        echo "✅ MySQL is ready!"
        break
    fi
    sleep 1
done

# Initialize Guacamole database
echo "🛠 Initializing Guacamole database..."
/init-guacamole-db.sh

# Start guacd in background
echo "🔌 Starting guacd..."
guacd -b 0.0.0.0 -f &

# Start Guacamole webapp
echo "🌐 Starting Guacamole web application..."
exec /opt/guacamole/bin/start.sh "$@"
