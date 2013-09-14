# Environment Installation
## 1.  Configuration  
  
Configuration file：config.inc.php  
	
### Components to install

export COMPONENTS="\<component name\> ..."  

Supported components（space separated）： 

* nginx 
* mysql 
* php54 
* phpmyadmin 
* redis 
* mongodb 
* qt
* phing

e.g. `export COMPONENTS="mongodb"`  

### Component specific config

* username
* password
* port
* ......

## 2.  Installation steps

1. Update configuration.
2. sh ./install.sh -d  
"-d" option will enable automatic downloading of required packages. 

## 3.  Usage

### Service start/stop

`service <service name> start`  
`service <service name> stop`  
`service <service name> restart` 

Services list:

* nginx
* mysql
* php
* redis
* mongodb

e.g. `service nginx start`
