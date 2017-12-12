[![Docker Build Status](https://img.shields.io/docker/build/cryptainer/terracoin.svg?style=for-the-badge)](https://hub.docker.com/r/cryptainer/terracoin/)
[![Docker Stars](https://img.shields.io/docker/stars/cryptainer/terracoin.svg?style=for-the-badge)](https://hub.docker.com/r/cryptainer/terracoin/)
[![Docker Pulls](https://img.shields.io/docker/pulls/cryptainer/terracoin.svg?style=for-the-badge)](https://hub.docker.com/r/cryptainer/terracoin/)

# terracoin-docker
This is a fully featured docker image for running a terracoin wallet. It's initial purpose is the operation of a terracoin masternode.

The image ships with a pre-configured [sentinel](https://github.com/terracoin/sentinel) cronjob.

## Usage

A typical `cryptainer/terracoin` masternode container can be started as follows:
```bash
docker run cryptainer/terracoin \
  -e conf_rpcuser=changeme \
  -e conf_rpcpassword=changeme \
  -e conf_rpcallowip=::/0 \
  -e conf_rpcport=22350 \
  -e conf_port=13333 \
  -e conf_printtoconsole=1 \
  -e conf_masternode=1 \
  -e conf_externalip=<your masternode public ip>:13333 \
  -e conf_masternodeprivkey=<your masternode privatekey> \
  -v /path/to/data/:/root/.terracoincore
```

### Volumes
* `/root/.terracoincore`: The `.terracoincore` directory (blockdata,...)

### Configuration
The `terracoin.conf` gets generated on each container start based on the given environment variables prefixed with `conf_`.
For example, to set `masternode=1` you need to run the container as follows:
```bash
docker run -e conf_masternode=1 cryptainer/terracoin
```

### Troubleshooting
Set `DEBUG=1` in order to have all configuration printed to stdout during container startup.

Sentinel logs can be found in `/var/log/sentinel.log`.

## Contribute
Please follow the [TerracoinCore guidelines for contributing](https://github.com/terracoin/terracoin/blob/v0.12.1.x/CONTRIBUTING.md).

Specifically to contribute a patch, the [workflow](https://github.com/terracoin/terracoin/blob/v0.12.1.x/CONTRIBUTING.md#contributor-workflow) is as follows:

1. Fork repository
2. Create topic branch
3. Commit patches

In general commits should be atomic and diffs should be easy to read. For this reason do not mix any formatting fixes or code moves with actual code changes.

Commit messages should be verbose by default, consisting of a short subject line (50 chars max), a blank line and detailed explanatory text as separate paragraph(s); unless the title alone is self-explanatory (like "Corrected typo in main.cpp") then a single title line is sufficient. Commit messages should be helpful to people reading your code in the future, so explain the reasoning for your decisions. Further explanation here.

## License
Released under the MIT license, under the same terms as [TerracoinCore](https://github.com/terracoin/terracoin) itself. See [LICENSE](LICENSE) for more info.

## Donations
Do you like this project and want to say thanks? Your donation is always welcome:

Terracoin: `13QtLFYD1q9wBLczbvt9jM1o2ZpwCehcY6`

Bitcoin: `1Eam5QWifTTu24p6u4dicN8W7eqXXcfJ1q`
