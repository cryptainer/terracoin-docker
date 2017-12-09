FROM ubuntu:16.04

ARG binaryPath=/usr/local/bin/terracoind
ENV BINARY_PATH=$binaryPath
ENV SENTINEL_DEBUG=1

ADD https://github.com/terracoin/terracoin/releases/download/0.12.1.5p/terracoind $binaryPath

RUN apt-get update && \
    apt-get install -y software-properties-common python-software-properties && \
    add-apt-repository ppa:bitcoin/bitcoin && \
    apt-get update && \
    apt-get install -y \
    libdb4.8-dev libdb4.8++-dev libevent-dev libminiupnpc-dev \
    libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev \
    python-virtualenv git && \
    apt-get purge -y python-software-properties

RUN chmod +x $binaryPath

RUN mkdir -p /opt/sentinel && \
    cd /opt/sentinel && \
    git clone https://github.com/terracoin/sentinel.git . && \
    virtualenv ./venv && \
    ./venv/bin/pip install -r requirements.txt && \
    echo "terracoin_conf=/root/.terracoincore/terracoin.conf" >> sentinel.conf && \
    echo "* * * * * cd /opt/sentinel && SENTINEL_DEBUG=1 ./venv/bin/python bin/sentinel.py >> sentinel.log 2>&1" > /tmp/crontab && \
    crontab /tmp/crontab && \
    ./venv/bin/py.test ./test 2>&1; exit 0

RUN mkdir -p /root/.terracoincore/



ENTRYPOINT ${BINARY_PATH} -printtoconsole

