#!/bin/bash

#created by Vladimir Sokolenko https://linkedin.com/in/sokolenko
#Backup of Tableau Server configuration and Logs

#specify the path for tsm command
#Directory path SHOULD BE CHANGED after every Tableau Server upgrade which changes package directory path
PATH="$PATH"':/opt/tableau/tableau_server/packages/customer-bin.20214.22.0420.0834'

#preparing variables
ERRFILE="$HOME/`date +%Y-%m-%d_%H:%M:%S`_tsm_backup.error"
BCKNAME="ts_backup-`date +%Y-%m-%d_%H:%M:%S`"
LOGSNAME="ts_logs-`date +%Y-%m-%d_%H:%M:%S`"

#Gets Server backup path from the System
backup_path=$(tsm configuration get -k basefilepath.backuprestore)
#Gets Server Log backup path from the System
log_path=$(tsm configuration get -k basefilepath.log_archive)
#How many days you want to keep old backup files, this parameter could be modified
backup_days="10"

#Create Tableau Server backup
echo "`date +%Y-%m-%d_%H:%M:%S`: Starting Tableau Server Backup"
tsm maintenance backup -f $BCKNAME 2>>$ERRFILE
#Create Tableau Server Ziplogs - Includes msinfo, netstat, and latest dump. Does not include PostgreSQL data.
echo "`date +%Y-%m-%d_%H:%M:%S`: Starting Tableau Logs Backup"
tsm maintenance ziplogs --all -f $LOGSNAME 2>>$ERRFILE
#Create Server topology and configuration data backup
echo "`date +%Y-%m-%d_%H:%M:%S`: Server topology and configuration data backup"
tsm settings export -f $HOME/repo_backup_`date +%Y-%m-%d_%H:%M:%S`.json 2>>$ERRFILE

#Copy backup files to Google Cloud storage
echo "`date +%Y-%m-%d_%H:%M:%S`: Copying Backup Files to Google Cloud storage"
/snap/bin/gsutil -m cp -r $backup_path/*.tsbak gs://public_sources_ls/tableau_server_backup/ 2>>$ERRFILE
/snap/bin/gsutil -m cp -r $log_path/*.zip gs://public_sources_ls/tableau_server_backup/ 2>>$ERRFILE
/snap/bin/gsutil -m cp -r $HOME/repo_backup_*.json gs://public_sources_ls/tableau_server_backup/ 2>>$ERRFILE

#Remove backup files from original path
echo "`date +%Y-%m-%d_%H:%M:%S`: Removing original Backup files"
rm $backup_path/*.tsbak 2>>$ERRFILE
rm $log_path/*.zip 2>>$ERRFILE
rm $HOME/repo_backup_*.json 2>>$ERRFILE

#Remove files older than $backup_days days from Google Cloud Storage
echo "`date +%Y-%m-%d_%H:%M:%S`: Removing Backup files older than $backup_days days from Google Cloud Storage"
/snap/bin/gsutil ls -l gs://public_sources_ls/tableau_server_backup/ | head -n -$backup_days | /snap/bin/gsutil -m rm -I

echo "`date +%Y-%m-%d_%H:%M:%S`: Backup Script finished"
