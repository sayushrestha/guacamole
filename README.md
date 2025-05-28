# Apache Guacamole Docker Setup

Docker Compose setup for Apache Guacamole with MySQL database and guacd.

## Features
- Single container setup with Guacamole, MySQL, and guacd
- Automatic database initialization
- Persistent storage for MySQL data

## Prerequisites
- Docker
- Docker Compose

## Quick Start

1. Clone this repository:
```bash
git clone https://github.com/yourusername/guacamole-docker.git
cd guacamole-docker
```

2. Start the containers:
```bash
docker-compose up -d
```

3. Access Guacamole at: http://localhost:8080/guacamole

## Configuration

Edit `guacamole.properties` for basic settings.

## Default Credentials
- MySQL root password: (set in docker-compose.yml)
- Guacamole default login: guacadmin/guacadmin

## License
MIT