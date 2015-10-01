# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT

sudo apt-get update
sudo apt-get install -y unzip git python-pip
sudo pip install awscli

sudo mkdir /esawsvars

echo $1 | sudo tee /esawsvars/AWS_ACCESS_KEY_ID > /dev/null
echo $2 | sudo tee /esawsvars/AWS_SECRET_ACCESS_KEY > /dev/null

wget -q https://dl.bintray.com/mitchellh/terraform/terraform_0.6.3_linux_amd64.zip -O /tmp/terraform.zip >/dev/null 2>&1

unzip /tmp/terraform.zip -d /tmp > /dev/null
sudo chmod +x /tmp/terraform*
sudo mv /tmp/terraform* /usr/local/bin/

git clone https://github.com/stuartrexking/esaws.git /home/vagrant/esaws
sudo chown -R vagrant:vagrant /home/vagrant/esaws

KEY_NAME=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32)

AWS_ACCESS_KEY_ID=$(cat "/esawsvars/AWS_ACCESS_KEY_ID") \
AWS_SECRET_ACCESS_KEY=$(cat "/esawsvars/AWS_SECRET_ACCESS_KEY") \
AWS_DEFAULT_REGION=eu-west-1 \
bash -c "aws ec2 create-key-pair --key-name $KEY_NAME --query 'KeyMaterial' --output text > /home/vagrant/esaws/$KEY_NAME.pem"

cat <<EOF > /home/vagrant/esaws/terraform.tfvars
access_key = "$(cat '/esawsvars/AWS_ACCESS_KEY_ID')"
secret_key = "$(cat '/esawsvars/AWS_SECRET_ACCESS_KEY')"
key_name = "$KEY_NAME"
key_path = "$KEY_NAME.pem"
region = "eu-west-1"
EOF

SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provision "shell" do |s|
      s.inline = $script
      s.args   = "#{ENV['AWS_ACCESS_KEY_ID']} #{ENV['AWS_SECRET_ACCESS_KEY']}"
  end
end