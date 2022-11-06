# idrive
**IDrive Backup Docker image**

IDrive services persist, so no need to relogin after each restart of the container.\
It also works in TrueNAS SCALE. Configuration exapmple is below.

## Requirements
* Docker installed
* IDrive account

## docker-compose example
````
services:
  idrive:
    container_name: idrive
    image: renofischa/idrive:latest
    restart: unless-stopped
    volumes:
      - config:/work/IDriveForLinux/idriveIt
      - dependencies:/work/IDriveForLinux/scripts/Idrivelib/dependencies
      - files:/mnt/files
      - $BACKUPDIR:/mnt/backup:ro
    environment:
      - TZ=$TZ
      
volumes:
  config:
  dependencies:
  files:
````
* volumes config, dependencies and files are necessary for persisting account settings and IDrive services.
* $BACKUPDIR points to the local path you need to backup
* Optional timezone environment variable, default is set to Europe/Vienna in dockerfile

## TrueNAS SCALE example
click on Apps -> Launch Docker image
* Image repository: ````renofischa/idrive````
  ![image](https://user-images.githubusercontent.com/32832850/200179090-23813e89-c863-44cb-8aa3-8ded16d024e4.png)
* Optional timezone environment variable
  ![image](https://user-images.githubusercontent.com/32832850/200179144-41492a50-d009-46b7-be27-bac8bf66d260.png)
* Storage:
  + configure your local path you need to backup as a Host Path Volume:\
    You have to mount each Dataset you want to back up in a seperate directory\
    ![image](https://user-images.githubusercontent.com/32832850/200178883-1e49489c-19be-4513-a0b1-268d587a32a4.png)
  + configure volumes for persisting files:
    ````
    config:/work/IDriveForLinux/idriveIt
    dependencies:/work/IDriveForLinux/scripts/Idrivelib/dependencies
    files:/mnt/files
    ````
    ![image](https://user-images.githubusercontent.com/32832850/200178452-5c6cb000-b5e1-4e84-8e20-1d3ca19bd606.png)
* Update Strategy: Kill existing pods before creating new ones

leave everything else on default

## Configuration after first start
Configure your IDrive account after first start.
* Exec into container
* Run ````./account_setting.pl````
* Login with your account details and configure other basic settings. Important is your Backup location.
* Now you should see your container in your IDrive dashboard.
