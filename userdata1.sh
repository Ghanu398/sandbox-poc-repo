#!/bin/bash
set -e

# -------------------------------
# 1. Update and install packages
# -------------------------------
sudo yum update -y
sudo yum install -y awscli httpd
# -------------------------------
# 2. Start HTTPD
# -------------------------------
echo "Hello from $(hostname -f)" > /var/www/html/index.html
sudo systemctl enable httpd
sudo systemctl start httpd

# -------------------------------
# 3. Create combined monitoring script
# -------------------------------
cat <<'EOF' > /opt/combined_monitor.sh
#!/bin/bash

DNS_NAME="failover.ghanshyam.site"
CW_REGION="us-east-2"


while true
do
  ####################################
  # PART 2 — ROUTE53 TRAFFIC CHECK
  ####################################
  RESPONSE=$(curl -s --max-time 2 http://$DNS_NAME)

  REGION_FOUND=$(echo "$RESPONSE" | grep -oE 'us-east-[0-9]' | head -n1)

  if [ "$REGION_FOUND" = "us-east-1" ]; then
    TRAFFIC_VALUE=1
  elif [ "$REGION_FOUND" = "us-east-2" ]; then
    TRAFFIC_VALUE=2
  else
    TRAFFIC_VALUE=0
  fi

  aws cloudwatch put-metric-data \
    --namespace "Custom/TrafficMetrics" \
    --metric-name "Route53TrafficRegion" \
    --value "$TRAFFIC_VALUE" \
    --unit Count \
    --timestamp "$TIMESTAMP" \
    --storage-resolution 1 \
    --region "$CW_REGION"

  sleep 1
done
EOF

# -------------------------------
# 4. Permissions
# -------------------------------
chmod +x /opt/combined_monitor.sh

# -------------------------------
# 5. Run in background
# -------------------------------
nohup /opt/combined_monitor.sh >> /var/log/combined_monitor.log 2>&1 &
