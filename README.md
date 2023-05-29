# idrive
**IDrive Backup Docker image**

Docker Hub: https://hub.docker.com/r/renofischa/idrive

IDrive services persist, so no need to relogin after each restart of the container.\
It also works in TrueNAS SCALE and on unRAID. Configuration examples are below.

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

## unRAID example
Save the following template as My-iDrive.xml under your boot usb drive in /Config/Plugins/dockerMan/templates-user/

````
<?xml version="1.0"?><Container version="2">
<Name>iDrive</Name>  
<Repository>renofischa/idrive</Repository>  
<Registry>https://hub.docker.com/r/renofischa/idrive</Registry>  
<Network>host</Network>  
<MyIP/>  
<Shell>sh</Shell>
<Privileged>false</Privileged>
<Support/>
<Project/>
<Overview/>
<Category/>
<WebUI/>
<TemplateURL/>
<Icon>https://static.idriveonlinebackup.com/source/images/favicon.ico</Icon>
<ExtraParams/>
<PostArgs/>
<CPUset/>  
<DateInstalled>1676085032</DateInstalled>  
<DonateText/>  <DonateLink/>  
<Requires>/work/IDriveForLinux/scripts/Idrivelib/dependencies</Requires>  
<Config Name="Host Path 1" Target="/work/IDriveForLinux/idriveIt" Default="" Mode="rw" Description="" Type="Path" Display="always" Required="false" Mask="false">/mnt/user/appdata/idrive/idriveIt</Config>  
<Config Name="Host Path 2" Target="/home/backup" Default="" Mode="ro" Description="" Type="Path" Display="always" Required="false" Mask="false">/mnt/user/backups/</Config>  
<Config Name="Host Key 1" Target="TZ" Default="" Mode="" Description="" Type="Variable" Display="always" Required="false" Mask="false">America/New_York</Config>
<Config Name="Host Path 3" Target="/work/IDriveForLinux/scripts/Idrivelib/dependencies" Default="" Mode="rw" Description="" Type="Path" Display="always" Required="false" Mask="false">/mnt/user/appdata/idrive/dependencies</Config>  
<Config Name="Host Path 4" Target="/mnt/files" Default="" Mode="rw" Description="" Type="Path" Display="always" Required="false" Mask="false">/mnt/user/appdata/idrive/files</Config>
</Container>
````

## Configuration after first start
Configure your IDrive account after first start.
* Exec into container
* Run ````./account_setting.pl````
* Login with your account details and configure other basic settings. Important is your Backup location.
* Now you should see your container in your IDrive dashboard.
