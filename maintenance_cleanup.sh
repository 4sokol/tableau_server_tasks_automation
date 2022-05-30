#!/bin/bash

#created by Vladimir Sokolenko https://linkedin.com/in/sokolenko
#Tableau Services Restart and Maintenance Cleanup every Last Sunday of the Month

#Stop Tableau Server
echo "`date +%Y-%m-%d_%H:%M:%S`: Stopping Tableau Server"
tsm stop
echo "`date +%Y-%m-%d_%H:%M:%S`: Tableau Server Stopped"
#Cleanup old temporary files and logs files
echo "`date +%Y-%m-%d_%H:%M:%S`: Starting Tableau Server Cleanup"
tsm maintenance cleanup -a
echo "`date +%Y-%m-%d_%H:%M:%S`: Tableau Server Cleanup Finished"
#Start Tableau Server
echo "`date +%Y-%m-%d_%H:%M:%S`: Starting Tableau Server"
tsm start
echo "`date +%Y-%m-%d_%H:%M:%S`: Tableau Server Started"
#Tableau Server status checkup
echo "`date +%Y-%m-%d_%H:%M:%S`: Tableau Server status checkup"
tsm status -v