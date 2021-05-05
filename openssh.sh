#install openssl-server. Below assumes container is on ubuntu
apt-get update 
apt-get -y install openssh-server
#create testuser
useradd testuser
passwd testuser 
info "testuser added"
#restart ssh service
info "restarting ssh service"
service ssh restart