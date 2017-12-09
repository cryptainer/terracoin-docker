#!/bin/bash

# Apply terracoin.conf configuration from environment variables
env | grep ^conf_ | sed -r 's/^conf_//g' > ${WALLET_CONF};

# Apply masternode.conf configuration from environment variables
env | grep ^mn_ | sed -r 's/^mn_//g' | sed 's/=/ /g' > ${MASTERNODE_CONF};

# If the container was restarted / the data directory is mounted from the host, there may be an old lock file
rm -f ${WALLET_DATA}/.lock

echo "Starting Terracoin Core."

if [ ${DEBUG} ]
then
    echo "terracoin.conf:"
    cat ${WALLET_CONF}
    echo "masternode.conf:"
    cat ${MASTERNODE_CONF}
else
    echo "Set DEBUG=1 to dump configs here."
fi

# Ensure cron is running, so sentinel is run periodically
cron;

exec terracoind -conf=${WALLET_CONF} -mnconf=${MASTERNODE_CONF}