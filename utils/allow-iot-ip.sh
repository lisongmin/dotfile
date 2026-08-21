#!/bin/sh

# Configuration
SET_NAME="iot-allowed-ipv4"
TABLE_NAME="fw4"
FAMILY="inet"

# 1. Add or Reset IP Function
add_ip() {
  local ip=$1
  if [ -z "$ip" ]; then
    echo "Error: IP address required."
    return 1
  fi

  # Atomic transaction: delete then add to reset timeout
  # If delete fails (IP not present), the transaction fails,
  # and we fall back to a simple add.
  nft -f - <<-EOF 2>/dev/null
		delete element $FAMILY $TABLE_NAME $SET_NAME { $ip }
		add element $FAMILY $TABLE_NAME $SET_NAME { $ip timeout 1h }
EOF

  if [ $? -ne 0 ]; then
    nft add element $FAMILY $TABLE_NAME $SET_NAME { $ip timeout 1h }
  fi
  echo "Success: $ip added/updated in $SET_NAME (1h timeout)."
}

# 2. Delete IP Function
del_ip() {
  local ip=$1
  if [ -z "$ip" ]; then
    echo "Error: IP address required."
    return 1
  fi

  nft delete element $FAMILY $TABLE_NAME $SET_NAME { $ip } 2>/dev/null
  if [ $? -eq 0 ]; then
    echo "Success: $ip removed from $SET_NAME."
  else
    echo "Notice: $ip was not in the set."
  fi
}

# 3. List Set Function
list_ips() {
  echo "=== Current $SET_NAME Status ==="
  nft list set $FAMILY $TABLE_NAME $SET_NAME
}

usage() {
  cat <<-EOF
Usage: $0 [add|del|list] [IP_ADDRESS]
-------------------------------------------
  add  - Add IP or reset its timer to 1 hour
  del  - Manually remove an IP
  list - Show all IPs and remaining time
EOF
  exit 1
}

# Main Logic
case "$1" in
add) add_ip "$2" ;;
del) del_ip "$2" ;;
list) list_ips ;;
*) usage ;;
esac
