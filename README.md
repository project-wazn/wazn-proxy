WAZN Proxy
======================

[![License](https://img.shields.io/badge/license-EUPL--1.2-red)](https://opensource.org/licenses/EUPL-1.2)

WAZN proxy for Node.js Pool

Supports:

* cn-wazn1
* cn-extremelite
* cn-upx2

## Deployment via Installer on Ubuntu 16.04

1. Create a user 'nodeproxy' and assign a password (or add a SSH key. If you prefer that, you should already know how to do it).

```bash
useradd -d /home/nodeproxy -m -s /bin/bash nodeproxy
passwd nodeproxy
```

2. Add your user to `/etc/sudoers`, this must be done so the script can sudo up and do it's job.  We suggest passwordless sudo.  Suggested line: `<USER> ALL=(ALL) NOPASSWD:ALL`.  Our sample builds use: `nodeproxy ALL=(ALL) NOPASSWD:ALL`

```bash
echo "nodeproxy ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
```

3. Log in as the **NON-ROOT USER** you just created and run the [deploy script](https://raw.githubusercontent.com/project-wazn/wazn-proxy/master/install.sh).  This is very important!  This script will install the proxy to whatever user it's running under!

```bash
curl -L https://raw.githubusercontent.com/project-wazn/wazn-proxy/master/install.sh | bash
```

3. Once it's complete, copy `config_example.json` to `config.json` and edit as desired.
4. Run: `source ~/.bashrc`  This will activate NVM and get things working for the following pm2 steps.
8. Once you're happy with the settings, go ahead and start all the proxy daemon, commands follow.

```shell
cd ~/wazn-proxy/
pm2 start proxy.js --name=proxy --log-date-format="YYYY-MM-DD HH:mm:ss:SSS Z"
pm2 save
```
You can check the status of your proxy by either issuing

```
pm2 logs proxy
```

or using the pm2 monitor

```
pm2 monit
```

## Updating wazn-proxy

```bash
cd wazn-proxy
./update.sh
```

## Deployment via Docker on Windows 10 with the Fall Creators Update (or newer)

1. Install and run [Docker for Windows](https://docs.docker.com/docker-for-windows/install/) with Linux containers mode.

2. Get wazn-proxy sources by downloading and unpacking the latest [wazn-proxy](https://github.com/project-wazn/wazn-proxy/archive/master.zip)
archive to wazn-proxy-master directory.

3. Got to wazn-proxy-master directory in Windows "Command Prompt" and build wazn-proxy Docker image:

```
docker build . -t wazn-proxy
```

4. Copy config_example.json to config.json and edit config.json file as desired (do not forget to update default WAZN wallet).

5. Create xnp Docker contained based on wazn-proxy image (make sure to update port numbers if you changed them in config.json):

```
docker create -p 3333:3333 -p 8080:8080 -p 8443:8443 --name xnp wazn-proxy
```

6. Copy your modified config.json to xnp Docker container:

```
docker cp config.json xnp:/wazn-proxy
```

7. Run xnp Docker container (or attach to already running one):

```
docker start --attach xnp
```

8. Stop xnp Docker container (to start it again with update):

```
docker stop xnp
```

9. Delete xnp Docker container (if you want to create it again with different ports):

```
docker rm xnp
```

10. Delete wazn-proxy Docker image (if you no longer need proxy):

```
docker rmi wazn-proxy
```

## Configuration BKMs

1. Specify at least one main pool with non zero share and "default: true". Sum of all non zero pool shares should be equal to 100 (percent).

2. There should be one pool with "default: true" (the last one will override previous ones with "default: true"). Default pool means pool that is used
for all initial miner connections via proxy.

3. You can use pools with zero share as backup pools. They will be only used if all non zero share pools became down.

4. You should select pool port with difficulty that is close to hashrate of all of your miners multiplied by 10.

5. Proxy ports should have difficulty close to your individual miner hashrate multiplied by 10.

6. Algorithm names ("algo" option in pool config section) can be taken from [Algorithm names and variants](https://github.com/xmrig/xmrig-proxy/blob/dev/doc/STRATUM_EXT.md#14-algorithm-names-and-variants) table

7. Blob type ("blob_type" option in pool config section) can be as follows

	* cryptonote  - Monero forks like WAZN, Sumokoin, Electroneum, Graft, Aeon, Intense

	* cryptonote2 - Masari

	* forknote    - Some old Bytecoin forks

	* forknote2   - Bytecoin forks like Turtlecoin, IPBC

## Switching from other xmr-node-proxy repository

	```bash
	cd xmr-node-proxy
	git remote set-url origin https://github.com/MoneroOcean/xmr-node-proxy.git && git pull -X theirs --no-edit && npm update
	```

## Known Issues

VMs with 512Mb or less RAM will need some swap space in order to compile the C extensions for node.
Bignum and the CN libraries can chew through some serious memory during compile.
In regards to this here is guide for T2.Micro servers: [Setup of wazn-proxy on free tier AWS t2.micro instance](http://moneroocean.blogspot.com/2017/10/setup-of-xmr-node-proxy-on-free-tier.html).
There is also more generic proxy installation guide: [Complete guide to install and configure wazn-proxy on a Ubuntu 16.04 VPS](https://tjosm.com/7689/install-xmr-node-proxy-vps/)

If not running on an Ubuntu 16.04 system, please make sure your kernel is at least 3.2 or higher, as older versions will not work for this.

Many smaller VMs come with ulimits set very low. We suggest looking into setting the ulimit higher. In particular, `nofile` (Number of files open) needs to be raised for high-usage instances.

In your `packages.json`, do a `npm install`, and it should pass.


## License
```
Licensed under the EUPL-1.2
Copyright (c) 2020 WAZN Project
```
