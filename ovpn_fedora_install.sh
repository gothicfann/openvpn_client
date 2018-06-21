#!/bin/bash

############################
### INSTALL DEPENDENCIES ###
############################

DEPS=(wget make opensc openssl-devel lzo-devel pkcs11-helper-devel pam-devel)

for PKG in ${DEPS[*]}
do
	rpm -q $PKG > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo -e "\xE2\x9C\x94 $PKG is already installed."
	else
		echo -en "? Installing $PKG ..."\\r
		dnf install $PKG -y >/dev/null 2>&1
		echo -e "\xE2\x9C\x94 $PKG has been installed."
	fi
done

#######################
### INSTALL OPENVPN ###
#######################

OVPN=openvpn
VERSION="2.4.6"
TAR="${OVPN}-${VERSION}.tar.gz"
LINK="https://swupdate.openvpn.org/community/releases/${TAR}"

echo -en "? Installing $OVPN from source ..."\\r

wget $LINK > /dev/null 2>&1 && tar zxvf $TAR > /dev/null && \
	(cd ${OVPN}-${VERSION} && ./configure --enable-systemd=no --enable-pkcs11=yes > /dev/null && make > /dev/null && make install > /dev/null) && \
	rm -rf ${OVPN}-${VERSION} $TAR

echo -e "\xE2\x9C\x94 $OVPN has been installed from source."

################################
### GET YUBIKEY SERIALIZED ID ###
################################

PKCS11_PATH="/usr/lib64/pkcs11/opensc-pkcs11.so"

while true
do
	openvpn --show-pkcs11-ids $PKCS11_PATH | grep -i "serialized id" >> /dev/null
	if [ $? -eq 0 ]; then
		SERIAL=$(sudo openvpn --show-pkcs11-ids /usr/lib64/pkcs11/opensc-pkcs11.so | grep -i "serialized id" | tr -s ' ' | cut -d ' ' -f 4)
		break
	else
		echo "Please insert your yubikey device and press [ENTER]"
		read
	fi
done


#######################
### GENERATE CONFIG ###
#######################

CLIENT=test

cat <<EOF > ${CLIENT}.conf
# This files is generated by script

client
pull
dev tun
proto udp
remote 35.185.63.141 1194
resolv-retry infinite
nobind
user nobody
group nobody
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-CBC
auth-nocache
verb 4
pkcs11-providers ${PKCS11_PATH}
pkcs11-id '${SERIAL}'
<ca>
-----BEGIN CERTIFICATE-----
-----END CERTIFICATE-----
</ca>
<tls-crypt>
#
# 2048 bit OpenVPN static key
#
-----BEGIN OpenVPN Static key V1-----
-----END OpenVPN Static key V1-----
</tls-crypt>
EOF

echo -e "\xE2\x9C\x94 ${CLIENT}.conf has been generated."

exit 0