FROM debian:jessie
RUN apt-get update -y
RUN apt-get install -y wget
RUN wget -q -O- https://s3.amazonaws.com/download.fpcomplete.com/debian/fpco.key | apt-key add -
RUN echo 'deb http://download.fpcomplete.com/debian/jessie stable main'| tee /etc/apt/sources.list.d/fpco.list
RUN apt-get update -y
RUN apt-get install -y stack
WORKDIR /app
COPY stack.yaml /app/
RUN stack setup
COPY *.cabal /app/
RUN stack build --dependencies-only --test


