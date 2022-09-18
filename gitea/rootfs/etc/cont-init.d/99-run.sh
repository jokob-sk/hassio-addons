#!/usr/bin/env bashio
# shellcheck shell=bash

for file in /data/gitea/conf/app.ini /etc/templates/app.ini; do
PROTOCOL = http
done

SITE_TITLE=$(bashio::config 'SITE_TITLE')
SERVER_DOMAIN=$(bashio::config 'SERVER_DOMAIN')
BASE_URL=$(bashio::config 'BASE_URL')

echo "site tile $SITE_TITLE"
echo "server domain $SERVER_DOMAIN"
echo "base url $BASE_URL"

# sed "s/^APP.*/APP      = $SITE_TITLE/" /data/gitea/conf/app.ini
# sed "s/^DOMAIN.*/DOMAIN      = $SERVER_DOMAIN/" /data/gitea/conf/app.ini
# sed "s/^ROOT_URL.*/ROOT_URL       = $BASE_URL/" /data/gitea/conf/app.ini


for file in /data/gitea/conf/app.ini /etc/templates/app.ini; do

##############
# SSL CONFIG #
##############

# Clean values
sed -i "/PROTOCOL/d" 

# Add ssl
bashio::config.require.ssl
if bashio::config.true 'ssl'; then
bashio::log.info "Ssl is enabled"
sed -i "/server/a PROTOCOL = https" "$file"
else
sed -i "/server/a PROTOCOL = http" "$file"
fi

done

##############
# LAUNCH APP #
##############

bashio::log.info "Please wait while the app is loading !"

/./usr/bin/entrypoint
