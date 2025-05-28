FROM guacamole/guacamole:latest

USER root

# Install MySQL server and client
RUN microdnf install -y mariadb-server mariadb-connector-java && \
    microdnf clean all

# Create necessary directories and set permissions
RUN mkdir -p /var/run/mysqld && \
    chown mysql:mysql /var/run/mysqld && \
    mkdir -p /var/lib/mysql && \
    chown mysql:mysql /var/lib/mysql

# Copy our custom scripts
COPY start.sh /start.sh
COPY init-guacamole-db.sh /docker-entrypoint-initdb.d/

# Set permissions
RUN chmod +x /start.sh && \
    chmod +x /docker-entrypoint-initdb.d/init-guacamole-db.sh

# Set the entrypoint
ENTRYPOINT ["/start.sh"]
CMD ["guacamole"]

USER guacamole
