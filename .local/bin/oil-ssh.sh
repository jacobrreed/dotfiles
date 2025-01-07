#!/bin/sh

# Select a host via fzf
host=$(grep 'Host\>' ~/.ssh/config | sed 's/^Host //' | grep -v '\*' | fzf --cycle --layout=reverse)

if [ -z "$host" ]; then
	exit 0
fi

# Get user from host name
user=$(ssh -G "$host" | grep '^user\>'  | sed 's/^user //')

nvim oil-ssh://"$user"@"$host"/
