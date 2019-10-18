[< Previous step: Welcome to the Metwork Framework](./index.md)

## Installation

For this tutorial, we are going to start with a fresh CentOS 7 virtual machine. The virtual machine should have at least 6GB RAM and 10GB disk. MetWork Framework can run with much less RAM but we are going to do a full install, including administration tools.

Your virtual machine should have access to the Internet. On a CentOS VM, you might need to activate the Internet access from 'Applications / System tools / Settings / Network'.

First, register the MetWork Framework stable repository. Login as root, copy the following command and paste it in a terminal.

``` bash
cat >/etc/yum.repos.d/metwork.repo <<EOF
[metwork_stable]
name=MetWork Stable
baseurl=http://metwork-framework.org/pub/metwork/releases/rpms/stable/centos7/
gpgcheck=0
enabled=1
metadata_expire=0
EOF
```

MetWork Framework is organized in modules. We are going to install the webservice module: mfserv.

``` bash
yum -y install metwork-mfserv
```

That's all we need for now!

[Next step: Create your first API >](./2_first_api.md)