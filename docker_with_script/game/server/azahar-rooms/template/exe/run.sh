#!/bin/bash

# Edit room_name, game, game_id, port, members, room_msg and token

room_name=""
game=""
game_id=""
port=
members=
#username=
motd=$(cat /opt/motd)
next_maintenance=$(cat /opt/next_maintenance)
room_msg="Room dedicated to battling and trading in the Pokemon titles from generation 6: X/Y and OR/AS."
description=$(echo -e "$motd\n\n$room_msg\n\nNext maintenance window will be: $next_maintenance")
token=
api_server=http://88.198.47.46:5000
logfile="/opt/azahar/logs/azahar_$(date +%d%m%y_%H%M%S).log"
banlist="/opt/azahar/banlist/bannedlist.txt"

## Switch to enable (Y or y) or disable (N or n) logging and banlist. Not used as of now because they both were not working.
## Left it untouched as a reference for a possible future use
##
#enable_log_file=N
#enable_ban_list=N
##
#if [ "$enable_log_file" == "Y" ] || [ "$enable_log_file" == "y" ]
#then
#	logging_opt="--log-file $logfile"
#	touch "$logfile"
#fi
#
#if [ "$enable_ban_list" == "Y" ] || [ "$enable_ban_list" == "y" ]
#then
#	banlist_opt="--ban-list-file $banlist"
#	echo -e "AzaharRoom-BanList-1" > "$banlist"
#fi

#Overrides previous variables with the one contained in this file
source /opt/azahar_conf_overrides

mkdir -p /opt/azahar/logs

/app/azahar-room \
	--room-name "$room_name" \
	--preferred-app "$game" \
	--preferred-app-id "$game_id" \
	--room-description "$description" \
	--port $port \
	--max_members $members \
	$logging_opt \
	$banlist_opt \
	--token "$token" \
	--web-api-url "$api_server" 2>&1 | tee -a /opt/azahar/logs/azahar_$(date +%d%m%y_%H%M%S).log
