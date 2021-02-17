#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo Welcome to `hostname -I` on `curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone` with this server provisioned with test nr3 | sudo tee /var/www/html/index.html