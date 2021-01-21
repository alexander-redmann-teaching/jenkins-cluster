FROM      ubuntu
LABEL Description="This image is used to start the foobar executable" Vendor="ACME Products" Version="1.0"

ENV http_proxy "$HTTP_PROXY"
ENV https_proxy "$HTTP_PROXY"
ENV ftp_proxy "$HTTP_PROXY"
ENV no_proxy "$NO_PROXY"

RUN apt-get update && apt-get install -y inotify-tools nginx apache2 openssh-server
