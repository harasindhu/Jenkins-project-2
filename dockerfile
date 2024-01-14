# Pull base image 
From tomcat:8-jre8 

# Maintainer 
MAINTAINER "kishoregogineni10@gmail.com" 
COPY /github.com/iamkishore0/maven_project.git/to/webapp.war /usr/local/tomcat/webapps
