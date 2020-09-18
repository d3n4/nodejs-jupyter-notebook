FROM ubuntu:bionic

USER root
WORKDIR /var/jupyter

ARG DEBIAN_FRONTEND=noninteractive
ARG DEBCONF_NONINTERACTIVE_SEEN=true

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true


RUN apt-get update -qqy

RUN export DEBIAN_FRONTEND=noninteractive
RUN export DEBCONF_NONINTERACTIVE_SEEN=true
RUN echo 'tzdata tzdata/Areas select Etc' | debconf-set-selections
RUN echo 'tzdata tzdata/Zones/Etc select UTC' | debconf-set-selections

RUN apt-get install -qqy --no-install-recommends tzdata

RUN apt-get install -qqy curl

RUN curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh

RUN apt-get install -qqy nodejs
RUN apt-get install -qqy python3-notebook jupyter jupyter-core python-ipykernel
RUN npm install -g --unsafe-perm ijavascript && ijsinstall --install=global


RUN apt-get install -qqy git


RUN apt-get autoremove
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*
RUN rm nodesource_setup.sh
RUN npm init -y
RUN npm i dstools

EXPOSE 80

CMD ["jupyter", "notebook", "--no-browser", "--port=80", "--ip=0.0.0.0", "--allow-root"]
