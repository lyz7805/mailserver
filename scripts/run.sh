#!/bin/sh

[ -z "${SERVER_HOSTNAME}" ] && echo "SERVER_HOSTNAME is not set" && exit 1
SSL_CRT=$(find "${SSL_DIR}" -iname '*.crt')
SSL_KEY=$(find "${SSL_DIR}" -iname '*.key')
if [ -z "${SSL_CRT}" ] || [ -z "${SSL_KEY}" ]; then
  echo "SSL files are not set, please set crt and key file in ${SSL_DIR}" && exit 1
fi

mkdir -p "${SSL_DIR}"
chmod -R 400 "${SSL_DIR}"

DOMAIN=$(echo "${SERVER_HOSTNAME}" | awk 'BEGIN{FS=OFS="."}{print $(NF-1),$NF}')
ALWAYS_ADD_MISSING_HEADERS=${ALWAYS_ADD_MISSING_HEADERS:-no}

sed -i "s/{{DB_USER}}/${DB_USER}/g" /etc/postfix/mysql-virtual-alias-maps.cf
sed -i "s/{{DB_HOST}}/${DB_HOST}/g" /etc/postfix/mysql-virtual-alias-maps.cf
sed -i "s/{{DB_NAME}}/${DB_NAME}/g" /etc/postfix/mysql-virtual-alias-maps.cf
sed -i "s/{{DB_PASSWORD}}/${DB_PASSWORD}/g" /etc/postfix/mysql-virtual-alias-maps.cf

sed -i "s/{{DB_USER}}/${DB_USER}/g" /etc/postfix/mysql-virtual-mailbox-maps.cf
sed -i "s/{{DB_HOST}}/${DB_HOST}/g" /etc/postfix/mysql-virtual-mailbox-maps.cf
sed -i "s/{{DB_NAME}}/${DB_NAME}/g" /etc/postfix/mysql-virtual-mailbox-maps.cf
sed -i "s/{{DB_PASSWORD}}/${DB_PASSWORD}/g" /etc/postfix/mysql-virtual-mailbox-maps.cf

sed -i "s/{{DB_USER}}/${DB_USER}/g" /etc/postfix/mysql-virtual-mailbox-domains.cf
sed -i "s/{{DB_HOST}}/${DB_HOST}/g" /etc/postfix/mysql-virtual-mailbox-domains.cf
sed -i "s/{{DB_NAME}}/${DB_NAME}/g" /etc/postfix/mysql-virtual-mailbox-domains.cf
sed -i "s/{{DB_PASSWORD}}/${DB_PASSWORD}/g" /etc/postfix/mysql-virtual-mailbox-domains.cf

sed -i "s/{{DB_USER}}/${DB_USER}/g" /etc/dovecot/dovecot-sql.conf
sed -i "s/{{DB_HOST}}/${DB_HOST}/g" /etc/dovecot/dovecot-sql.conf
sed -i "s/{{DB_NAME}}/${DB_NAME}/g" /etc/dovecot/dovecot-sql.conf
sed -i "s/{{DB_PASSWORD}}/${DB_PASSWORD}/g" /etc/dovecot/dovecot-sql.conf

postconf -e "myhostname = ${SERVER_HOSTNAME}"
postconf -e "mydomain = ${DOMAIN}"

postconf -e "always_add_missing_headers = ${ALWAYS_ADD_MISSING_HEADERS}"

# Enable Postfix TLS
postconf -e "smtpd_tls_cert_file = ${SSL_CRT}"
postconf -e "smtpd_tls_key_file = ${SSL_KEY}"

sed -i "s@{{SSL_CRT}}@${SSL_CRT}@g" /etc/dovecot/local.conf
sed -i "s@{{SSL_KEY}}@${SSL_KEY}@g" /etc/dovecot/local.conf

# Set message_size_limit and mailbox_size_limit
if [ -n "${MESSAGE_SIZE_LIMIT}" ]; then
  MAILBOX_SIZE_LIMIT=${MESSAGE_SIZE_LIMIT}
  postconf -e "message_size_limit = ${MESSAGE_SIZE_LIMIT}"
  postconf -e "mailbox_size_limit = ${MAILBOX_SIZE_LIMIT}"
fi


echo "Server run start..."
echo "Host: ${SERVER_HOSTNAME}"

# Run Dovecot
dovecot
# Run Postfix and Dovecot
postfix start-fg
