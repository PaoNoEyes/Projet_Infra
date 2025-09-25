#!/bin/bash

set -e

# ========= CONFIGURATION =========
HOSTNAME="ClientLinux1"
DOMAIN="GDI.local"
REALM="GDI.LOCAL"
AD_SERVER="192.168.30.1"
ADMIN_USER="Administrateur"
ADMIN_PASS="Azerty01."

# ========= CONFIG DNS =========
echo "Configuring DNS..."
cat <<EOF > /etc/resolv.conf
nameserver 192.168.30.1
nameserver 8.8.8.8
search $DOMAIN
EOF

# ========= CONFIG /etc/hosts =========
echo "Setting hostname in /etc/hosts..."
grep -q "$HOSTNAME" /etc/hosts || echo "127.0.1.1 $HOSTNAME" >> /etc/hosts

# ========= CONFIG KERBEROS =========
echo "Configuring Kerberos..."
cat <<EOF > /etc/krb5.conf
[libdefaults]
  default_realm = $REALM
  dns_lookup_realm = true
  dns_lookup_kdc = true
  rdns = false

[realms]
  $REALM = {
    kdc = $AD_SERVER
    admin_server = $AD_SERVER
  }

[domain_realm]
  .$DOMAIN = $REALM
  $DOMAIN = $REALM
EOF

# ========= APT UPDATE =========
echo "Updating APT..."
apt update

# ========= SET HOSTNAME =========
echo "Setting hostname to $HOSTNAME..."
hostnamectl set-hostname "$HOSTNAME"

# ========= INSTALL PACKAGES =========
echo "Installing required packages..."
apt install -y realmd sssd sssd-tools samba-common \
  packagekit adcli krb5-user oddjob oddjob-mkhomedir ntp || true

# ========= CLI MODE =========
echo "Switching to CLI mode..."
systemctl isolate multi-user.target

# ========= DISCOVER DOMAIN =========
echo "Discovering domain..."
realm discover $DOMAIN || echo "Domain discovery failed"

# ========= CHECK IF JOINED =========
if realm list | grep -q "$REALM"; then
    echo "Already joined to domain $REALM"
else
    echo "Joining domain $REALM..."
    echo "$ADMIN_PASS" | realm join --user=$ADMIN_USER $DOMAIN --verbose
fi

# ========= RESTART SSSD =========
echo "Restarting SSSD..."
systemctl restart sssd
sleep 5

# ========= REINSTALL GNOME & DESKTOP (optional) =========
echo "Reinstalling gnome-shell and ubuntu-desktop..."
apt install -y gnome-shell ubuntu-desktop || true

# ========= FINAL REBOOT =========
echo "Rebooting in 45 seconds..."
sleep 45
reboot

