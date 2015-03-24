# This Dockerfile is used to build an image containing packer and stuff to be used as a Jenkins slave
FROM ubuntu:14.04
MAINTAINER Jonathan Dupuich <jonathan.dupuich@gmail.com>

# Make sure the image is up-to-date
RUN apt-get update
RUN apt-get -y upgrade

# Install openssh server
RUN apt-get install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Install JDK 7
RUN apt-get install -y openjdk-7-jdk 

# Add user Jenkins
RUN adduser --quiet jenkins
# Set password for the jenkins user
RUN echo "jenkins:jenkins" | chpasswd

# Install PIP 
RUN apt-get -y install python-pip python-dev build-essential zip

# Install AWS-CLI
RUN pip install awscli

# Install Packer
RUN cd /tmp && wget https://dl.bintray.com/mitchellh/packer/packer_0.7.5_linux_amd64.zip
RUN cd /tmp && unzip packer_0.7.5_linux_amd64.zip -d /usr/bin/
RUN packer version

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]