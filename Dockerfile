FROM ubuntu:16.04

ARG terracoinVersion=0.12.1
ARG terracoinRelease=8
ARG sentinelVersion=master
ARG _terracoinBin=/opt/terracoin/terracoind
ARG _sentinelBin=/opt/sentinel/sentinel.sh
ARG _entryPointBin=/opt/docker-entrypoint.sh

ENV WALLET_CONF /etc/terracoin/terracoin.conf
ENV MASTERNODE_CONF /etc/terracoin/masternode.conf
ENV WALLET_DATA /data/
ENV SENTINEL_HOME /opt/sentinel/src

RUN apt-get update && \
    apt-get install -y software-properties-common python-software-properties && \
    add-apt-repository ppa:bitcoin/bitcoin && \
    apt-get update && \
    apt-get install -y \
    libdb4.8-dev libdb4.8++-dev libevent-dev libminiupnpc-dev \
    libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev \
    python-virtualenv git wget && \
    apt-get purge -y python-software-properties

COPY /opt /opt
COPY /docker-entrypoint.sh $_entryPointBin

RUN mkdir -p `dirname $_terracoinBin` && \
    wget https://terracoin.io/bin/terracoin-core-$terracoinVersion\.$terracoinRelease/terracoin-$terracoinVersion\-x86_64-linux-gnu.tar.gz -O trc.tar.gz && \
    tar -xzvf trc.tar.gz && \
    mv terracoin-$terracoinVersion/bin/terracoind $_terracoinBin && \
    rm -rf trc.tar.gz terracoin-$terracoinVersion && \
    chmod +x $_terracoinBin && \
    ln -s $_terracoinBin /usr/local/bin/terracoind && \
    chmod +x $_entryPointBin && \
    ln -s $_entryPointBin /usr/local/bin/docker-entry && \
    mkdir -p /etc/terracoin

RUN mkdir -p ${SENTINEL_HOME} && \
    cd ${SENTINEL_HOME} && \
    git clone https://github.com/terracoin/sentinel.git . && \
    git checkout $sentinelVersion && \
    virtualenv ./venv && \
    ./venv/bin/pip install -r requirements.txt && \
    echo "terracoin_conf=${WALLET_CONF}" >> sentinel.conf && \
    echo "SENTINEL_HOME=${SENTINEL_HOME}" > /tmp/crontab && \
    echo "* * * * * /usr/local/bin/sentinel >> /var/log/sentinel.log 2>&1" >> /tmp/crontab && \
    crontab /tmp/crontab && \
    rm -f /tmp/crontab && \
    chmod +x $_sentinelBin && \
    ln -s $_sentinelBin /usr/local/bin/sentinel && \
    ./venv/bin/py.test ./test 2>&1; exit 0

VOLUME /data

EXPOSE 13333 22350

ENTRYPOINT ["docker-entry"]

