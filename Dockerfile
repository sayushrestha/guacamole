FROM guacamole/guacamole:latest

USER root

# Install MySQL server and client
RUN microdnf install -y mariadb-server mariadb-connector-java && \
    microdnf clean all

# Create necessary directories
RUN mkdir -p /var/run/mysqld && \
    chown mysql:mysql /var/run/mysqld && \
    mkdir -p /var/lib/mysql && \
    chown mysql:mysql /var/lib/mysql

# Copy our scripts
COPY start.sh /start.sh
COPY init-guacamole-db.sh /init-guacamole-db.sh

# Set permissions
RUN chmod +x /start.sh && \
    chmod +x /init-guacamole-db.sh

# Set entrypoint
ENTRYPOINT ["/start.sh"]
CMD ["guacamole"]

USER guacamole
