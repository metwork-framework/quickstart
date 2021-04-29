[< Previous step: Welcome to the Metwork Framework](./index.md)

## Installation

For this tutorial, we are going to start with a fresh Linux CentOS virtual machine. The virtual machine should have at least 6GB RAM and 10GB disk. MetWork Framework can run with much less RAM but we are going to do a full install, including administration tools.

Your virtual machine should have access to the Internet. On a CentOS VM, you might need to activate the Internet access from 'Applications / System tools / Settings / Network'.

First, register the MetWork Framework stable repository. Login as root, copy the following command and paste it in a terminal.

``` bash
cat >/etc/yum.repos.d/metwork.repo <<EOF
[metwork_1_0]
name=MetWork Stable
baseurl=http://metwork-framework.org/pub/metwork/releases/rpms/release_1.0/portable/
gpgcheck=0
enabled=1
metadata_expire=0
EOF
```

MetWork Framework is organized in modules. We are going to install the webservice module: mfserv.

``` bash
# As root user
yum -y install metwork-mfserv
```

As we are going to play with `nodejs` services, we need to add the `nodejs` support for `mfserv` with:

``` bash
# As root user
yum -y install metwork-mfserv-layer-nodejs
```

Just in case `make` is not installed on your system, as we need it to play with mfserv plugins :

``` bash
# As root user
yum -y install make
```

That's all we need for now!

[Next step: Create your first API >](./2_first_api.md)
