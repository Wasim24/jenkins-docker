FROM ubuntu:16.04

# Update packages
RUN apt-get update && apt-get upgrade -y
RUN apt-get install git wget curl sudo -y
RUN apt-get install apt-transport-https ca-certificates -y
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
RUN sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
RUN sh -c 'echo deb https://apt.dockerproject.org/repo ubuntu-xenial main > /etc/apt/sources.list.d/docker.list'
RUN apt-get -qq update

# Install Python
RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:fkrull/deadsnakes
RUN apt-get install python2.7 -y

# Install JDK
RUN apt-get install default-jre -y
RUN apt-get install default-jdk -y

# Install Jenkins
RUN apt-get install jenkins -y

# Install Docker
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
USER jenkins 
RUN apt-get install docker-engine -y
RUN usermod -aG docker jenkins
RUN ulimit -n 60000

# Install Docker Compose
RUN curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Run
USER jenkins
ENTRYPOINT ["java", "-jar", "/usr/share/jenkins/jenkins.war"]
EXPOSE 8080 50000
CMD [""]