#!/bin/bash

STATUS=$(acpi -b | awk '{ split($5,a,":"); print substr($3,0,2), $4, "["a[1]":"a[2]"]" }' | tr -d ',')
PERCENT=$(acpi -b | awk '{ split($5,a,":"); print substr($4,1,2)}')

full="Fu"
discharging="Di"
charging="Ch"

notificationValue=15
criticalValue=10

case "$STATUS" in
	*"$full"* )
		echo $STATUS
		echo 
		echo "#AAAAAA" ;;
	*"$discharging"* )
		if [ "$PERCENT" -lt "$criticalValue" ]; then
                        notify-send -u critical Battery "Battery Critical Low. Find loader dude!"
                        echo "CRITICAL VALUE!!!! $STATUS"
                        echo "#FF0000"
		elif [ "$PERCENT" -lt "$notificationValue" ]; then
			notify-send -u normal Battery "Battery Low. Find loader dude!"	
			echo "$STATUS"
			echo
			echo "#FF0000"
		else
			echo $STATUS
			echo
			echo "#FFFF00"
		fi
		;;
	*"$charging"* )
		echo $STATUS
		echo 
		echo "#00FF00" ;;
	*)
		echo $STATUS
		echo
		echo "#AAAAAA" ;;
esac

