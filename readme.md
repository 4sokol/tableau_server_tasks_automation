# tableau_server_tasks_automation

Tableau Server maintenance tasks automation:
- Tableau Server backup
- Tableau Server Ziplogs - Including msinfo, netstat, and latest dump
- Tableau Server topology and configuration data backup
- Cleanup of old temporary files and logs
      
In this example we configured Google Cloud Storage as an external storage for Tableau Server backups. The full External Storage path looks like this:  gs://public_sources_ls/tableau_server_backup/

It is important to clarify that the version of Tableau Server in this example is: 2021.4.6, build number: 20214.22.0420.0834

Agenda:
- Automation process deployed through BASH scripts
- Automate the process of Tableau Server backup, Ziplogs, topology and configuration data backup
- Automate the process of Tableau Server logs cleanup
- Host OS: Linux Ubuntu Server 18.04. Script has been tested on both .RPM and .DEB Linux Environments
- As a storage for all backups we will use Google Cloud Storage
- In this case Tableau Server has been deployed as 1 node, without High-Availability
- In this case Tableau Server version is: 2021.4.6, build number: 20214.22.0420.0834
- To automate these tasks there were deployed 2 scripts, which are going to run automatically through CRON jobs:
“tsm_backup.sh” – Tableau Server backup configuration and logs
“maintenance_cleanup.sh” - Tableau Server maintenance cleanup