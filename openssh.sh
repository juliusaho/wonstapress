#install openssl-server. Below assumes container is on ubuntu
apt-get update 
apt-get -y install openssh-server
#create testuser
useradd testuser
passwd testuser 
echo "testuser added"
#restart ssh service
service ssh restart