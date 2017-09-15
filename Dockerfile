FROM alpine:3.5

MAINTAINER Huang Rui <vowstar@gmail.com>, Turtle <turtled@emqtt.io>

ENV EMQ_VERSION=v2.3-beta.3

COPY ./start.sh /start.sh

RUN set -ex \
    # add build deps, remove after build
    && apk --no-cache add --virtual .build-deps \
        build-base \
        # gcc \
        # make \
        bsd-compat-headers \
        perl \
        erlang \
        erlang-public-key \
        erlang-syntax-tools \
        erlang-erl-docgen \
        erlang-gs \
        erlang-observer \
        erlang-ssh \
        #erlang-ose \
        erlang-cosfiletransfer \
        erlang-runtime-tools \
        erlang-os-mon \
        erlang-tools \
        erlang-cosproperty \
        erlang-common-test \
        erlang-dialyzer \
        erlang-edoc \
        erlang-otp-mibs \
        erlang-crypto \
        erlang-costransaction \
        erlang-odbc \
        erlang-inets \
        erlang-asn1 \
        erlang-snmp \
        erlang-erts \
        erlang-et \
        erlang-cosnotification \
        erlang-xmerl \
        erlang-typer \
        erlang-coseventdomain \
        erlang-stdlib \
        erlang-diameter \
        erlang-hipe \
        erlang-ic \
        erlang-eunit \
        #erlang-webtool \
        erlang-mnesia \
        erlang-erl-interface \
        #erlang-test-server \
        erlang-sasl \
        erlang-jinterface \
        erlang-kernel \
        erlang-orber \
        erlang-costime \
        erlang-percept \
        erlang-dev \
        erlang-eldap \
        erlang-reltool \
        erlang-debugger \
        erlang-ssl \
        erlang-megaco \
        erlang-parsetools \
        erlang-cosevent \
        erlang-compiler \
    # add fetch deps, remove after build
    && apk add --no-cache --virtual .fetch-deps \
        git \
        wget \
    # add run deps, never remove
    && apk add --no-cache --virtual .run-deps \
        ncurses-terminfo-base \
        ncurses-terminfo \
        ncurses-libs \
        readline \
    # add latest rebar
    && git clone -b ${EMQ_VERSION} https://github.com/emqtt/emq-relx.git /emqttd

# ADD files/Makefile /emqttd
# ADD files/relx.config /emqttd

# build the project
RUN set -ex \    
    && cd /emqttd \
    && make 
  

