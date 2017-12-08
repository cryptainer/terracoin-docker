FROM ubuntu:16.04

ARG binaryPath=/usr/local/bin/terracoind
ENV BINARY_PATH=$binaryPath

ADD https://github.com/terracoin/terracoin/releases/download/0.12.1.5p/terracoind $binaryPath

RUN apt-get update && \
    apt-get install -y software-properties-common python-software-properties && \
    add-apt-repository ppa:bitcoin/bitcoin && \
    apt-get update && \
    apt-get install -y \
    libdb4.8-dev libdb4.8++-dev libevent-dev libminiupnpc-dev \
    libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev && \
    apt-get purge -y python-software-properties

RUN chmod +x $binaryPath

RUN mkdir /root/.terracoincore && \
    touch /root/.terracoincore/debug.log

ENTRYPOINT ${BINARY_PATH} --daemon && tail -f /root/.terracoincore/debug.log

