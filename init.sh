#! /bin/bash
sudo apt-get update -y
sudo apt-get install nginx -y
sudo systemctl start nginx
echo "<h1>Deployed via Terraform</h1>" | sudo tee /www/data/index.html
