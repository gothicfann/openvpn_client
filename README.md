# OpenVPN client installation manuals for yubikey.

### Fedora 28 (script installation)

Just run `sudo ./ovpn_fedora_install.sh`. 
It will install and confgure openvpn and all the dependecnies and generate client config file for you that uses you yubikey to authenticate through OpenVPN server.

### Windows 10 (manual installation)

The windows batch script would be much more complex, and not as flexible as fedora shell script.
So I will explain all the steps for installing and configuring OpenVPN client and configuration file.
Like in linux distros there is a package manager for windows also. I strongly recommend to install it, as in all the next steps in this 
manual we will be using it.
So lets start:

1. First install Windows package manager (http://Chocolatey.org)

open you command prompt (cmd.exe) as an `Administrator` user and issue command:
`@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"`

for more installation details please visit: https://chocolatey.org/install

2. 
