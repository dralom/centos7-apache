# Pull from the latest centos image at the time of writing
FROM centos:centos7.9.2009

# Add the setup file, see file for details
COPY src/ /tmp/src/

# Execute setup
RUN chmod +x /tmp/src/setup.sh && \
    cd /tmp/src/ && \
    ./setup.sh

EXPOSE 80

# Starts apache running in the foreground, preventing the container from stoping.
CMD ["/usr/sbin/apachectl", "-DFOREGROUND"]
