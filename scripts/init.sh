#!/bin/sh

postconf -e "myorigin = \$mydomain"
postconf -e "inet_interfaces = all"
postconf -e "inet_protocols = all"
postconf -e "mydestination = \$myhostname, localhost.\$mydomain, localhost"

postconf -e "virtual_uid_maps = static:5000"
postconf -e "virtual_gid_maps = static:5000"

postconf -e "virtual_mailbox_domains = mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf"
postconf -e "virtual_mailbox_maps = mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf"
postconf -e "virtual_alias_maps = mysql:/etc/postfix/mysql-virtual-alias-maps.cf"

# Enable Postfix use Dovecot as SASL authentication
postconf -e "smtpd_sasl_type = dovecot"
postconf -e "smtpd_sasl_path = private/auth"
postconf -e "smtpd_sasl_auth_enable = yes"
postconf -e "broken_sasl_auth_clients = yes"
postconf -e "smtpd_sasl_security_options = noanonymous"
postconf -e "smtpd_sasl_local_domain = \$myhostname"
postconf -e "smtpd_sasl_authenticated_header = yes"
postconf -e "smtpd_relay_restrictions =  permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination"

# Enable Postfix TLS
postconf -e "smtpd_use_tls = yes"
postconf -e "smtpd_tls_received_header = yes"
postconf -e "smtpd_tls_loglevel = 1"
postconf -e "smtpd_tls_auth_only = yes"
postconf -e "smtpd_tls_session_cache_database = lmdb:\${data_directory}/smtpd_scache"

postconf -e "smtp_use_tls = yes"
postconf -e "smtp_tls_security_level = encrypt"
postconf -e "smtp_tls_wrappermode = yes"
postconf -e "smtp_tls_loglevel = 1"
postconf -e "smtp_tls_session_cache_database = lmdb:\${data_directory}/smtp_scache"

postconf -Me "smtps/inet = smtps     inet  n       -       n       -       -       smtpd"
postconf -Pe "smtps/inet/syslog_name = postfix/smtps"
postconf -Pe "smtps/inet/smtpd_tls_wrappermode = yes"
postconf -Pe "smtps/inet/smtpd_sasl_auth_enable = yes"
postconf -Pe "smtps/inet/smtpd_relay_restrictions = permit_sasl_authenticated,reject"
postconf -Pe "smtps/inet/milter_macro_daemon_name = ORIGINATING"

sed -i "s@!include auth-passwdfile.conf.ext@#!include auth-passwdfile.conf.ext@g" /etc/dovecot/conf.d/10-auth.conf
sed -i "s@ssl_cert = <@#ssl_cert = <@g" /etc/dovecot/conf.d/10-ssl.conf
sed -i "s@ssl_key = <@#ssl_key = <@g" /etc/dovecot/conf.d/10-ssl.conf

# Transport to dovecot use lmtp
postconf -e "virtual_transport = lmtp:unix:private/dovecot-lmtp"

# Config log to stdout
postconf -e "maillog_file = /dev/stdout"

# Build the postfix necessary DBM or DB file
newaliases

chown -R vmail:dovecot /etc/dovecot
chmod -R o-rwx /etc/dovecot
