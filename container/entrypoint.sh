#!/bin/bash

yo --no-insight hubot --owner="${HUBOT_OWNER}" --name="${HUBOT_NAME}" \
   --description="${HUBOT_DESCRIPTION}" --adapter="${HUBOT_ADAPTER}" --defaults

cat << EOF > /home/hubot/external-scripts.json
[
"hubot-diagnostics",
"hubot-plusplus",
"hubot-redis-brain",
"hubot-seen",
"hubot-youtube",
"hubot-yubikey-invalidation"
]
EOF

npm install --save hubot-slack hubot-plusplus hubot-yubikey-invalidation \
    hubot-seen hubot-youtube hubot-redis-brain hubot-diagnostics

exec "$@"
