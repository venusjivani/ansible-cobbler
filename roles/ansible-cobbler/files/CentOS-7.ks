# kickstart template for Fedora 8 and later.
# (includes %end blocks)
# do not use with earlier distros

#platform=x86, AMD64, or Intel EM64T
# System authorization information
auth  --useshadow  --enablemd5
# System bootloader configuration
bootloader --location=mbr
# Partition clearing information
clearpart --all --initlabel
# Use text mode install
text
# Firewall configuration
firewall --enabled
# Run the Setup Agent on first boot
firstboot --disable
# System keyboard
keyboard us
# System language
lang en_US
# Use network installation
url --url=http://192.168.168.1/cblr/links/CentOS-7-x86_64
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
repo --name=source-1 --baseurl=http://192.168.168.1/cobbler/ks_mirror/CentOS-7-x86_64

# Network information
network --bootproto=dhcp --device=eth0 --onboot=on

# Reboot after installation
reboot

#Root password
rootpw --iscrypted $1$hIa5ZTPa$x.wfVU3nvX6ooa4bj7HRm.
# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx
# System timezone
#timezone  America/New_York
timezone Etc/UTC --isUtc --nontp
user --homedir=/home/venus.jivani --name=venus.jivani --password=$6$Ew/niBhgNrOSiPtI$.ftWA7iwSmqkaIVhDvmU/2qO.4WzFH86otf57KuqhaGM2xHGXFbAI.7Y4Mv9l1elzX6If7N1vv4acrmNoNshW. --iscrypted --gecos="VJ"
# Install OS instead of upgrade
install
# Clear the Master Boot Record
zerombr
# Allow anaconda to partition the system as needed
autopart

%pre
set -x -v
exec 1>/tmp/ks-pre.log 2>&1

# Once root's homedir is there, copy over the log.
while : ; do
    sleep 10
    if [ -d /mnt/sysimage/root ]; then
        cp /tmp/ks-pre.log /mnt/sysimage/root/
        logger "Copied %pre section log to system"
        break
    fi
done &


curl "http://192.168.168.1/cblr/svc/op/trig/mode/pre/profile/CentOS-7-x86_64" -o /dev/null

# Enable installation monitoring

%end

%packages --ignoremissing
@Base
@Core
@Editors
@Mail Server
@System Tools
@Yum Utilities
OpenIPMI
authconfig
binutils
dbus-python
device-mapper-multipath
elinks
git
grub
httpd
iotop
iscsi-initiator-utils
kernel
kernel-smp
kexec-tools
ksh
lha
libdbi
libpcap
libtalloc
libtdb
lm_sensors
logwatch
lynx
lzo
m2crypto
mod_authz_ldap
mod_ssl
mysql
net-snmp
net-snmp-libs
net-snmp-perl
net-snmp-utils
NetworkManager
NetworkManager-glib
nmap
open
openldap-clients
perl-Crypt-DES
perl-Digest-HMAC
perl-Digest-MD5
perl-Digest-SHA1
perl-Socket6
policycoreutils-python
postfix
postgresql-libs
pyOpenSSL
python-dmidecode
python-ethtool
python-gudev
rsyslog
samba-client
sblim-sfcb
screen
sssd
strace
sysstat
telnet
tree
vim
x86info
yum-priorities
yum-protectbase
yum-utils
-@ Virtualization
-ModemManager
-autofs
-bluez-gnome
-bluez-hcidump
-bluez-utils
-ckermit
-conman
-cpuspeed
-cyrus-sasl
-dnsmasq
-dosfstools
-dovecot
-ecryptfs-utils
-emacspeak
-finger
-firstboot-tui
-fprintd-pam
-git
-hwbrowser
-imap
-imap-utils
-irda-utils
-libvirt
-libvirt-python
-mailman
-mcelog
-mdadm
-mkbootdisk
-nfs-utils
-ntpdate
-pinfo
-redhat-lsb
-redhat-switch-mail
-redhat-switch-mail-gnome
-rhn-virtualization-common
-rhn-virtualization-host
-rp-pppoe
-sendmail
-sendmail-cf
-spamassassin
-squirrelmail
-sysklogd
-system-switch-mail
-system-switch-mail-gnome
-vnc
-xdelta
-ypbind
-yum-updatesd
-zisofs-tools

%end

%post --nochroot
set -x -v
exec 1>/mnt/sysimage/root/ks-post-nochroot.log 2>&1

%end

%post
set -x -v
exec 1>/root/ks-post.log 2>&1

# Start yum configuration
curl "http://192.168.168.1/cblr/svc/op/yum/profile/CentOS-7-x86_64" --output /etc/yum.repos.d/cobbler-config.repo

# End yum configuration



# Start post_install_network_config generated code
# End post_install_network_config generated code




# Start download cobbler managed config files (if applicable)
# End download cobbler managed config files (if applicable)

# Start koan environment setup
echo "export COBBLER_SERVER=192.168.168.1" > /etc/profile.d/cobbler.sh
echo "setenv COBBLER_SERVER 192.168.168.1" > /etc/profile.d/cobbler.csh
# End koan environment setup

# begin Red Hat management server registration
# not configured to register to any Red Hat management server (ok)
# end Red Hat management server registration

# Begin cobbler registration
# cobbler registration is disabled in /etc/cobbler/settings
# End cobbler registration

# Enable post-install boot notification

# Start final steps

curl "http://192.168.168.1/cblr/svc/op/ks/profile/CentOS-7-x86_64" -o /root/cobbler.ks
curl "http://192.168.168.1/cblr/svc/op/trig/mode/post/profile/CentOS-7-x86_64" -o /dev/null
# End final steps
%end