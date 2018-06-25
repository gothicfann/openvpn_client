# OpenVPN client installation manuals for yubikey.

## Fedora 28 (script installation)

Just run `sudo ./ovpn_fedora_install.sh`. 
It will install and confgure openvpn and all the dependecnies and generate client config file for you that uses you yubikey to authenticate through OpenVPN server.

## Windows 10 (manual installation)

The windows batch script would be much more complex, and not as flexible as fedora shell script.
So I will explain all the steps for installing and configuring OpenVPN client and configuration file.
Like in linux distros there is a package manager for windows also. I strongly recommend to install it, as in all the next steps in this 
manual we will be using it.
So lets start:

#### 1. Install Windows package manager (http://Chocolatey.org)

Run you command prompt (cmd.exe) as an `Administrator` user and issue command:

```
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
```
Note! After this close the Command Prompt.

For more installation details please visit: https://chocolatey.org/install

#### 2. Install OpenSC

Navigate to this link: https://github.com/OpenSC/OpenSC/releases  
Download latest compatible version for you OS and system architecture.  
Install it with default options.

#### 3. Install OpenVPN (2.4.4)

Run you command prompt (cmd.exe) as an `Administrator` user and issue command:

```
choco install openvpn --version 2.4.4 -y
```

#### 4. Get certificates serialized id from your Yubikey device

1. Insert you Yubikey device.
2. Using command prompt navigate to `C:\Program Files\OpenVPN\bin` using:
```
cd "C:\Program Files\OpenVPN\bin"
```
3. Issue command:
```
openvpn.exe --show-pkcs11-ids "C:\Program Files\OpenSC Project\OpenSC\pkcs11\opensc-pkcs11.dll"
```
4. You will get your certificates Serialized Id from Yubikey, similiar to this:  
`piv_II/PKCS\x2315\x20emulated/0f1f5e860fae681b/client/01`
5. Copy this Serilized Id and paste it in your `client.ovpn` file for `pkcs11-id` parameter:  
**NOTE! Paste your serialized id between single quotes ('')**

```
client
pull
dev tun
proto udp
remote 35.185.63.141 1194
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-CBC
auth-nocache
verb 4
<b>### Your OpenSC pkcs11 drivers full path:
pkcs11-providers 'C:\Program Files\OpenSC Project\OpenSC\pkcs11\opensc-pkcs11.dll'
### NOTE! Dont forget to paste your Serialized Id between the single quotes:
pkcs11-id 'Serialized Id'</b>
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
```