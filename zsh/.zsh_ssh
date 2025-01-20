#!/bin/bash

# File to store SSH agent environment variables
SSH_ENV="$HOME/.ssh/agent-environment"

# Start SSH agent and store environment variables
function start_agent {
    # Start agent and store environment variables
    echo "Starting new SSH agent..."
    ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    chmod 600 "${SSH_ENV}"
    source "${SSH_ENV}"

    # Add all private keys
    for key in "$HOME/.ssh/"*; do
        if [ -f "$key" ] && \
           [[ "$key" != *.pub ]] && \
           [[ "$key" != *known_hosts* ]] && \
           [[ "$key" != *authorized_keys* ]] && \
           [[ "$key" != *config* ]] && \
           [[ "$key" != *agent-environment* ]]; then
            ssh-add "$key" 2>/dev/null
        fi
    done
}

# Source SSH environment if it exists, or start new agent
if [ -f "${SSH_ENV}" ]; then
    source "${SSH_ENV}" >/dev/null
    # Verify ssh-agent is running and accessible
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

# Add to your ~/.tmux.conf:
# set-environment -g SSH_AUTH_SOCK $HOME/.ssh/ssh_auth_sock
# set-environment -g SSH_AGENT_PID $HOME/.ssh/agent-environment
# # if ssh auth variable is missing
# if [ -z "$SSH_AUTH_SOCK" ]; then
#   export SSH_AUTH_SOCK="$HOME/.ssh/ssh_auth_sock"
# fi
#
# # if socket is available create the new auth session
# if [ ! -S "$SSH_AUTH_SOCK" ]; then
#   `ssh-agent -a $SSH_AUTH_SOCK`
#   # echo $SSH_AGENT_PID $HOME/.ssh/.auth_pid
# fi
#
# # if agent isn't defined, recreate it from pid file
# if [ -z $SSH_AGENT_PID ]; then
# 	export SSH_AGENT_PID=`cat $HOME/.ssh/.auth_pid`
# fi
#
# # Add all default keys to ssh auth
# ssh-add 2>/dev/null
