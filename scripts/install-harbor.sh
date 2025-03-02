#!/bin/bash

# Use root user
sudo -i
apt update -y

# Make dir
mkdir -p /root/tools/docker
cd /root/tools/docker

# Create and populate docker installation script
cat > docker-install.sh << 'DOCKERSCRIPT'
#!/bin/bash

sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce
sudo systemctl start docker
sudo systemctl enable docker
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker --version
docker-compose --version
DOCKERSCRIPT

# Make script executable and run it
chmod +x docker-install.sh
./docker-install.sh

# Install certbot
apt install certbot -y
mkdir -p /root/tools/harbor 
cd /root/tools/harbor

# Install Harbor
curl -s https://api.github.com/repos/goharbor/harbor/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep '.tgz$' | wget -i -

# Unzip
tar xzvf harbor-offline*

cd harbor
cp harbor.yml.tmpl harbor.yml

export DOMAIN="moda.id.vn"  
export EMAIL="levanbao2104@gmail.com"

certbot certonly --standalone -d $DOMAIN --preferred-challenges http --agree-tos -m $EMAIL --keep-until-expiring -n

# Update Harbor configuration
sed -i "s/hostname: .*/hostname: $DOMAIN/" harbor.yml
sed -i "s|certificate: .*|certificate: /etc/letsencrypt/live/$DOMAIN/fullchain.pem|" harbor.yml
sed -i "s|private_key: .*|private_key: /etc/letsencrypt/live/$DOMAIN/privkey.pem|" harbor.yml

# Install Harbor with HTTPS
./prepare
./install.sh
docker compose up -d