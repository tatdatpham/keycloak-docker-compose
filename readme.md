# Keycloak with Let's Encrypt Using Docker Compose


❗ Change variables in the `.env` to meet your requirements.

💡 Note that the `.env` file should be in the same directory as `docker-compose.yml`.

Create networks for your services before deploying the configuration using the commands:

`docker network create traefik-network`

`docker network create keycloak-network`

Deploy Keycloak using Docker Compose:

`docker compose -f docker-compose.yml -p keycloak up -d`

# Backups

The `backups` container in the configuration is responsible for the following:

1. **Database Backup**: Creates compressed backups of the PostgreSQL database using pg_dump.
Customizable backup path, filename pattern, and schedule through variables like `POSTGRES_BACKUPS_PATH`, `POSTGRES_BACKUP_NAME`, and `BACKUP_INTERVAL`.

2. **Backup Pruning**: Periodically removes backups exceeding a specified age to manage storage. Customizable pruning schedule and age threshold with `POSTGRES_BACKUP_PRUNE_DAYS` and `DATA_BACKUP_PRUNE_DAYS`.

By utilizing this container, consistent and automated backups of the essential components of your instance are ensured. Moreover, efficient management of backup storage and tailored backup routines can be achieved through easy and flexible configuration using environment variables.

# keycloak-restore-database.sh Description

This script facilitates the restoration of a database backup:

1. **Identify Containers**: It first identifies the service and backups containers by name, finding the appropriate container IDs.

2. **List Backups**: Displays all available database backups located at the specified backup path.

3. **Select Backup**: Prompts the user to copy and paste the desired backup name from the list to restore the database.

4. **Stop Service**: Temporarily stops the service to ensure data consistency during restoration.

5. **Restore Database**: Executes a sequence of commands to drop the current database, create a new one, and restore it from the selected compressed backup file.

6. **Start Service**: Restarts the service after the restoration is completed.

To make the `keycloak-restore-database.shh` script executable, run the following command:

`chmod +x keycloak-restore-database.sh`

Usage of this script ensures a controlled and guided process to restore the database from an existing backup.


# Build docker image
I shipped the `dockerfile` for Jenkins agent build for **Maven** and **NodeJS**
Run command below to build the docker iamge for multiple platform. 
```
# Create and use a new builder instance
docker buildx create --use

# Inspect the builder to ensure it supports multiple platforms
docker buildx inspect --bootstrap

# Build and push the Docker image for multiple platforms
docker buildx build --platform linux/amd64,linux/arm64 -t your-dockerhub-username/jenkins-agent-python3:latest --push .
```

# Author - Rewrite code
Tat Dat Pham
