#!/bin/bash

# <UDF name="hostname" label="Set your System's Hostname">
# HOSTNAME=
# <UDF name="fqdn" label="Set your System's Fully Qualified Domain Name">
# FQDN=

function install_epel {

    rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

}

function install_ssh_key {

    mkdir /root/.ssh/
    touch /root/.ssh/authorized_keys
    cat >>/root/.ssh/authorized_keys<<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5MHLMI6Xj//vpyLFYcYLlq9tVZ6vfU1RLipvQF22sS+YdDCz91jKt0DZjM79OYHq1D9Re0XjvWdeVXa3oYAfyZyWdMcirOSedy9jcEzN0yBAnfDS7JQeTFAlLg9m7Om4lcpNIAMOJIFcZ6wpz8ozMphXXl4zla+yes5zfYVgvBZETtta/PXvvEk9fkd+qVTjC0Ft9z2bHMBaykXEwAhvrU+m5ptRzVtVGW/AGbvf4ux+dTBBWgAiW4kEvhuWixijYPmFKPfme5GcEyCrptxGSj10oo4gTZXu5ls8Kyv0Y92UwChvWthgRW85b53neyavEV3fp7HNiu1g55Q+JpIed lordcongou@RockieMac.local
EOF

}

function fix_locale {

    cat >>/etc/profile.d/z-custom.sh<<EOF
#!/bin/bash

export LC_ALL="en_US.UTF-8"
export LC_TYPE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
EOF
    
}

function install_npm {

    yum -y install \
        npm
        
}

function set_hostname {

    IPADDR=`ip -f inet -r addr | egrep -o "(([0-9]{3}+).*)/24" | sed 's/\/24//'`  
    echo "HOSTNAME=$1" >> /etc/sysconfig/network
    hostname "$1"
    
    # update /etc/hosts
    echo ${IPADDR} ${HOSTNAME} ${FQDN} >> /etc/hosts

}
    
fix_locale
set_hostname    
install_ssh_key
install_epel
install_npm


