#!/bin/bash
set -eu

PORT="${PORT:-2200}"

gen_key() {
  keytype=$1
  ks="${keytype}_"
  key="keys/ssh_host_${ks}key"
  if [ ! -e "${key}" ] ; then
    ssh-keygen -t "${keytype}" -f "${key}" -N '' >/dev/null
  fi
  SIG=$(ssh-keygen -l -E SHA256 -f "${key}.pub" | cut -d ' ' -f 2)
}

mkdir -p keys
gen_key rsa
RSA_SIG=$SIG
gen_key ed25519
ED25519_SIG=$SIG

(
  echo "set -g tmate-server-host $HOSTNAME"
  echo "set -g tmate-server-port $PORT"
  echo "set -g tmate-server-rsa-fingerprint \"$RSA_SIG\""
  echo "set -g tmate-server-ed25519-fingerprint \"$ED25519_SIG\""
) > tmate.conf

echo "Use the generated tmate.conf file to connect to this server:"
echo
echo "    tmate -f $PWD/tmate.conf"
echo

cat tmate.conf
