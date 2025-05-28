# Start from the official Guacamole image
FROM guacamole/guacamole:latest

# Install MySQL server and dependencies
USER root
RUN microdnf install -y mariadb-server mariadb-connector-java && \
    microdnf clean all

# Configure MySQL
RUN mkdir -p /var/run/mysqld && \
    chown mysql:mysql /var/run/mysqld && \
    mkdir -p /var/lib/mysql && \
    chown mysql:mysql /var/lib/mysql

# Copy initialization scripts
COPY initdb.sql /docker-entrypoint-initdb.d/
COPY init-guacamole-db.sh /docker-entrypoint-initdb.d/

# Copy modified entrypoint
COPY docker-entrypoint.sh /opt/guacamole/bin/

# Ensure proper permissions
RUN chmod +x /opt/guacamole/bin/docker-entrypoint.sh && \
    chmod +x /docker-entrypoint-initdb.d/init-guacamole-db.sh

USER guacamole