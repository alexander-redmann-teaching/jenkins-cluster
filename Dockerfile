FROM      ubuntu
LABEL Description="This image is used to start the foobar executable" Vendor="ACME Products" Version="1.0"

ENV http_proxy "http://proxy.management.dmz:8080/"
ENV https_proxy "http://proxy.management.dmz:8080/"
ENV ftp_proxy "http://proxy.management.dmz:8080/"
ENV no_proxy "localhost,127.0.0.1,.sma.de,.management.dmz,.sunnyportal.com,.cluster.local"

RUN apt-get update && apt-get install -y inotify-tools nginx apache2 openssh-server
