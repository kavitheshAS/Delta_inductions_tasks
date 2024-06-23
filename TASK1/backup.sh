#!/bin/bash

BACKUP_DIR="/backup"
TIMESTAMP=$(date +"%F-%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/db_backup_$TIMESTAMP.sql"
mkdir -p $BACKUP_DIR

mysqldump -u root -p${root_password} --all-databases > $BACKUP_FILE


