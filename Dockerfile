FROM debian:8.1

ADD prepare.sh /

RUN /prepare.sh
