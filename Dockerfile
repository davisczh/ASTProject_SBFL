# Use an official Java base image with Perl
FROM openjdk:8-jdk

# Install necessary packages including Perl, cpanminus, Git, and SVN
RUN apt-get update && apt-get install -y \
    git \
    perl \
    subversion \
    build-essential \
    cpanminus \
    maven \ 
    nano 

WORKDIR /workdir

# Entry point to keep the container running and for interactive use
CMD ["tail", "-f", "/dev/null"]
