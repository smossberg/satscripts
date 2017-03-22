#!/bin/sh
# Creates the .hammer_cli used to authenticate
PASSWORD="changeme"
hostname="satellite.mosslab.org"
cat >> /etc/hammer/cli_config.yml << EOF
:foreman:
    :host: 'https://$(hostname)/'
    :username: 'admin'
    :password: '$PASSWORD'
EOF

if [ ! -d "$HOME/.hammer" ]; then
	mkdir "$HOME/.hammer"
fi

hammer defaults add --param-name organization_id --param-value 1

