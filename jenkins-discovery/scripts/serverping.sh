#!/bin/bash

PROJECT_NAMES=/etc/consul-template/output/project-names.txt
PROJECT_NAMES_PREV=/etc/consul-template/output/project-names-prev.txt

if [ -z "$CURL_AUTH_USER" ]; then
    echo "CURL_AUTH missing"
fi

if [ -z "$CURL_AUTH_PASS" ]; then
    echo "CURL_AUTH missing"
fi

if [ -z "$BASE_URL" ]; then
    echo "CURL_REGISTER missing"
fi

if [ -z "$CURL_REGISTER" ]; then
    echo "CURL_REGISTER missing"
fi

if [ -z "$CURL_UNREGISTER" ]; then
    echo "CURL_uNREGISTER missing"
fi

diff "$PROJECT_NAMES_PREV" "$PROJECT_NAMES" | grep '<' | awk '{print $2}' | \
    xargs -IPROJECT wget -q -O /dev/null --user "$CURL_AUTH_USER" --password "$CURL_AUTH_PASS" --post-data "server=$BASE_URL/PROJECT" "$CURL_UNREGISTER"

grep . "$PROJECT_NAMES" | \
    xargs -IPROJECT wget -q -O /dev/null --user "$CURL_AUTH_USER" --password "$CURL_AUTH_PASS" --post-data "server=$BASE_URL/PROJECT" "$CURL_REGISTER"

# Diff, if only NEW should be notified, otherwise all will be
# diff "$PROJECT_NAMES_PREV" "$PROJECT_NAMES" | grep '>' | awk '{print $2}' | \

# CURL would be better, but does not exist
# curl -Lsu "$CURL_AUTH" --data-urlencode "server=$BASE_URL/PROJECT" "$CURL_REGISTER";

cp -a "$PROJECT_NAMES" "$PROJECT_NAMES_PREV"
