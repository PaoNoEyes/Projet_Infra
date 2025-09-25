#!/bin/bash
set -e

# ========================== CONFIGURATION ==========================
HOSTNAME="ClientLinux1"
DOMAIN="GDI.local"
REALM="GDI.LOCAL"
AD_SERVER="192.168.30.1"
ADMIN_USER="Administrateur"
ADMIN_PASS="Azerty01."

# ========================== CONFIGURATION DNS ==========================
echo -e "\n🔧 Configuration du DNS..."
cat <<EOF > /etc/resolv.conf
nameserver 192.168.30.1
nameserver 8.8.8.8
search $DOMAIN
EOF

# ========================== MISE À JOUR DE /etc/hosts ==========================
echo -e "\n🔧 Mise à jour de /etc/hosts..."
grep -q "$HOSTNAME" /etc/hosts || echo "127.0.1.1 $HOSTNAME" >> /etc/hosts


# ========================== DÉFINITION DU NOM D'HÔTE ==========================
echo -e "\n🖥️ Définition du nom d'hôte : $HOSTNAME..."
hostnamectl set-hostname "$HOSTNAME"

# ========================== INSTALLATION DES PAQUETS NÉCESSAIRES ==========================
echo -e "\n📦 Mise à jour des listes de paquets..."
sudo apt update

echo -e "\n🔧 Installation des paquets nécessaires..."
sudo DEBIAN_FRONTEND=noninteractive apt install -y krb5-user krb5-config realmd sssd adcli samba-common sssd-tools keepass2

echo -e "\n⚙️ Correction des dépendances cassées éventuelles..."
sudo apt --fix-broken install -y

echo -e "\n✅ Installation terminée avec succès."

# ========================== CONFIGURATION KERBEROS ==========================
echo -e "\n🔧 Configuration de Kerberos (/etc/krb5.conf)..."
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
  .${DOMAIN,,} = $REALM
  ${DOMAIN,,} = $REALM
EOF

# ========================== DÉCOUVERTE DU DOMAINE ==========================
echo -e "\n🌐 Découverte du domaine $DOMAIN..."
realm discover $DOMAIN || echo "⚠️ Échec de la découverte du domaine"

# ========================== VÉRIFICATION DE L'INTÉGRATION AU DOMAINE ==========================
echo -e "\n🔍 Vérification de l'appartenance au domaine..."
if realm list | grep -q "$REALM"; then
    echo "✅ Déjà joint au domaine $REALM"
else
    echo "🔗 Tentative de jointure au domaine $REALM..."
    echo "$ADMIN_PASS" | realm join --user="$ADMIN_USER" $DOMAIN --verbose
fi

# ========================== REDÉMARRAGE DE SSSD ET CONFIG PAM ==========================
echo -e "\n🔁 Redémarrage de SSSD et activation de pam_mkhomedir..."
sudo pam-auth-update --enable mkhomedir

echo "🧹 Nettoyage du cache SSSD..."
sudo systemctl stop sssd
sudo rm -rf /var/lib/sss/db/*
sudo systemctl start sssd

echo -e "\n✅ Configuration de PAM & SSSD terminée !"

sudo ip link set eth0 down
