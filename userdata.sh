#!/bin/bash
set -e

# -------------------------------
# 1. Update system
# -------------------------------
sudo yum update -y

# -------------------------------
# 2. Install awscli & httpd
# -------------------------------
sudo yum install -y awscli
sudo yum install -y httpd
echo "Hello from $(hostname -f)" > /var/www/html/index.html 
sudo systemctl enable httpd
sudo systemctl start httpd  
# -------------------------------
# 3. Create status file (manual input file)
# -------------------------------
STATUS_FILE="/tmp/httpd_status.txt"
touch "$STATUS_FILE"
chmod 666 "$STATUS_FILE"
echo "active" > "$STATUS_FILE"
# -------------------------------
# 4. Create metric script
# -------------------------------
cat <<'EOF' > /opt/httpd_file_metric.sh
#!/bin/bash

LOCKFILE="/tmp/httpd_file_metric.lock"
exec 9>"$LOCKFILE"
flock -n 9 || exit 0

STATUS_FILE="/tmp/httpd_status.txt"
REGION="us-east-1"

# make sure file exists
touch "$STATUS_FILE"

while true
do
  STATUS=$(cat "$STATUS_FILE" 2>/dev/null | tr -d '[:space:]')

  if [ "$STATUS" = "active" ]; then
    VALUE=1
  else
    VALUE=0
  fi

  aws cloudwatch put-metric-data \
    --namespace "Custom/ServiceMetrics" \
    --metric-data "MetricName=HttpdRunningFromFile,Value=$VALUE,Unit=Count,StorageResolution=1" \
    --region "$REGION"

  sleep 1
done
EOF

# -------------------------------
# 5. Permissions & log file
# -------------------------------
chmod +x /opt/httpd_file_metric.sh
touch /var/log/httpd_file_metric.log
chmod 644 /var/log/httpd_file_metric.log
# -------------------------------
# 6. Run script ONCE at reboot
# -------------------------------
cd /opt
./httpd_file_metric.sh >> /var/log/httpd_file_metric.log 2>&1  &
# # -------------------------------
# # 6. Run script ONCE at reboot
# # -------------------------------
# CRON_JOB="@reboot /opt/httpd_file_metric.sh >> /var/log/httpd_file_metric.log 2>&1"

# ( crontab -l 2>/dev/null | grep -v '/opt/httpd_file_metric.sh' ; echo "$CRON_JOB" ) | crontab -
