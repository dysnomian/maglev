#!/usr/bin/env bash

function vpn_status {
  if [ -n "$1" ];
    then
      VPN_NAME="$1";
  elif [ -n "$DEFAULT_VPN_NAME" ];
    then
      VPN_NAME="$DEFAULT_VPN_NAME";
  else
    echo "No VPN name given, and DEFAULT_VPN_NAME is not set.";
    return 1;
  fi

  scutil --nc show "$VPN_NAME" | head -n 1 | awk '{gsub(/[()]/,""); print $2}'
}


main() {
  if [ vpn_status == "Connected" ]; then
      return "CONNECTED"
    else
      exit 0
  fi
}
main
