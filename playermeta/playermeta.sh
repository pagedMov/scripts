#!/run/current-system/sw/bin/bash
arg=$1

if [ "$arg" == "--listen" ]; then

	playerctl -F status | while read -r status; do
		# Only process if the status is "Playing" or "Paused"
		if [ "$status" == "Playing" ] || [ "$status" == "Paused" ]; then
			metadata=$(playerctl metadata)
			num_lines=$(echo "$metadata" | wc -l)
			line_num=0
			echo -n "{"
			while read -r line; do
				((line_num++))
				# manipulate data into json format
				key=$(echo "$line" | sed 's/:/@#@#@/' | awk -F '@#@#@' '{gsub(/ +/, " ", $2); print substr($2, 1, index($2, " ") - 1)}' | xargs)
				value=$(echo "$line" | sed 's/:/@#@#@/' | awk -F '@#@#@' '{gsub(/ +/, " ", $2); print substr($2, index($2, " ") + 1)}' | xargs)

				# Print comma separator unless it's the last line
				if [ ! -z "$key" ]; then
					echo -n "\"$key\":\"$value\""
					if [ "$line_num" -lt "$num_lines" ]; then
						echo -n ", "
					else
						echo ", \"status\":\"$(playerctl status)\"}"
					fi
				fi
			done <<< "$metadata"
		fi
	done
else
	metadata=$(playerctl metadata)
	num_lines=$(echo "$metadata" | wc -l)
	while read -r line; do
		((line_num++))
		# manipulate data into json format
		key=$(echo "$line" | sed 's/:/@#@#@/' | awk -F '@#@#@' '{gsub(/ +/, " ", $2); print substr($2, 1, index($2, " ") - 1)}' | xargs)
		value=$(echo "$line" | sed 's/:/@#@#@/' | awk -F '@#@#@' '{gsub(/ +/, " ", $2); print substr($2, index($2, " ") + 1)}' | xargs)

		# Print comma separator unless it's the last line
		if [ ! -z "$key" ]; then
			echo -n "\"$key\":\"$value\""
			if [ "$line_num" -lt "$num_lines" ]; then
				echo -n ", "
			else
				echo ", \"status\":\"$(playerctl status)\"}"
			fi
		fi
	done <<< "$metadata"
fi
