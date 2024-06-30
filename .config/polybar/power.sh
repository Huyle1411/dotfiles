#!/bin/bash

# Get battery status and capacity
battery_info=$(acpi -b)

# Check if battery is present
if [ -z "$battery_info" ]; then
	echo "No battery"
	exit 0
fi

# Parse battery percentage
battery_percentage=$(echo "$battery_info" | grep -oP '[0-9]+(?=%)')
# battery_status=$(echo $battery_info | awk '{print $(NF-3)}')
battery_status=$(echo "$battery_info" | awk -F ': ' '{print $2}' | awk -F ', ' '{print $1}')

get_icon() {
	local status=$1
	local percentage=$2

	if [[ $status == "Not charging" ]]; then
		echo ""
	elif [[ $status == "Discharging" ]]; then
		if [[ $percentage -ge 95 ]]; then
			echo "󰁹"
		elif [[ $percentage -ge 80 ]]; then
			echo "󰂁"
		elif [[ $percentage -ge 60 ]]; then
			echo "󰁿"
		elif [[ $percentage -ge 40 ]]; then
			echo "󰁽"
		elif [[ $percentage -ge 20 ]]; then
			echo "󰁼"
		else
			echo "󰂎"
		fi
	elif [[ $status == "Charging" ]]; then
		if [[ $percentage -ge 95 ]]; then
			echo "󰂅"
		elif [[ $percentage -ge 80 ]]; then
			echo "󰂊"
		elif [[ $percentage -ge 60 ]]; then
			echo "󰂉"
		elif [[ $percentage -ge 40 ]]; then
			echo "󰂈"
		elif [[ $percentage -ge 20 ]]; then
			echo "󰂆"
		else
			echo "󰢟"
		fi
	else
		echo "󱉞"
	fi
}

battery_icon=$(get_icon "$battery_status" "$battery_percentage")

# Print formatted output for polybar
echo "${battery_icon}${battery_percentage}%"
