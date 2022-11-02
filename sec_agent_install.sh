#!/bin/bash
# Created by Thulasiram - Install Security Agent Simulation

echo "Downloading security agent..."
sudo wget -q https://tcb-mgnt-service-bucket.s3.amazonaws.com/security_agent -P /usr/bin
echo "Security agent installation in progress..."
sudo chmod +x /usr/bin/security_agent
sleep 25
echo "Security agent installation completed."
sudo /usr/bin/security_agent status