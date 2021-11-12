clear
echo "============================================================================================="
echo "                              WELCOME TO NKNx FAST DEPLOY!"
echo "============================================================================================="
echo
echo "This script will automatically provision a node as you configured it in your snippet."
echo "So grab a coffee, lean back or do something else - installation will take about 5 minutes."
echo -e "============================================================================================="
echo
echo "Hardening your OS..."
echo "---------------------------"
export DEBIAN_FRONTEND=noninteractive
apt-get -qq update
apt-get -qq upgrade -y
echo "Installing necessary libraries..."
echo "---------------------------"
apt-get install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --force-yes make curl git unzip whois
apt-get install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --force-yes ufw
apt-get install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --force-yes unzip jq
ufw allow 30001 > /dev/null 2>&1
ufw allow 30002 > /dev/null 2>&1
ufw allow 30003 > /dev/null 2>&1
ufw allow 30004 > /dev/null 2>&1
ufw allow 30005 > /dev/null 2>&1
ufw allow 30010/tcp > /dev/null 2>&1
ufw allow 30011/udp > /dev/null 2>&1
ufw allow 30020/tcp > /dev/null 2>&1
ufw allow 30021/udp > /dev/null 2>&1
ufw allow 32768:65535/tcp > /dev/null 2>&1
ufw allow 32768:65535/udp > /dev/null 2>&1
ufw allow 22 > /dev/null 2>&1
ufw --force enable > /dev/null 2>&1
useradd nknx
mkdir -p /home/nknx/.ssh
mkdir -p /home/nknx/.nknx
adduser nknx sudo
chsh -s /bin/bash nknx
PASSWORD=$(mkpasswd -m sha-512 gL41gNQWzfE9)
usermod --password $PASSWORD nknx > /dev/null 2>&1
cd /home/nknx
echo "Installing NKN Commercial..."
echo "---------------------------"
wget --quiet --continue --show-progress https://commercial.nkn.org/downloads/nkn-commercial/linux-amd64.zip > /dev/null 2>&1
unzip -qq linux-amd64.zip
cd linux-amd64
cat >config.json <<EOF
{
    "nkn-node": {
      "args": "--sync light",
      "noRemotePortCheck": true
    }
}
EOF
./nkn-commercial -b NKNL3fxofb5n2apJZsMLgX8XpX8CqDRy285J -c /home/nknx/linux-amd64/config.json -d /home/nknx/nkn-commercial -u nknx install > /dev/null 2>&1
chown -R nknx:nknx /home/nknx
chmod -R 755 /home/nknx
echo "Waiting for wallet generation..."
echo "---------------------------"
while [ ! -f /home/nknx/nkn-commercial/services/nkn-node/wallet.json ]; do sleep 10; done
echo "Chain download skipped."
echo "---------------------------"
echo "Applying finishing touches..."
echo "---------------------------"
addr=$(jq -r .Address /home/nknx/nkn-commercial/services/nkn-node/wallet.json)
pwd=$(cat /home/nknx/nkn-commercial/services/nkn-node/wallet.pswd)
chown -R nknx:nknx /home/nknx
chmod -R 755 /home/nknx
sleep 2
clear
echo
echo
echo
echo
echo "                                  -----------------------"
echo "                                  |   NKNx FAST-DEPLOY  |"
echo "                                  -----------------------"
echo
echo "============================================================================================="
echo "   NKN ADDRESS OF THIS NODE: $addr"
echo "   PASSWORD FOR THIS WALLET IS: $pwd"
echo "============================================================================================="
echo "   ALL MINED NKN WILL GO TO: NKNL3fxofb5n2apJZsMLgX8XpX8CqDRy285J"
echo "============================================================================================="
echo
echo "You can now disconnect from your terminal. The node will automatically appear in NKNx after 1 minute."
echo
echo
echo
echo
