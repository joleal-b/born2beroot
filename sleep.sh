#!/bin/bash

# TIMER
upt=$(uptime -s | awk '{print $2}' | cut -d ":" -f2)
uptt=$(($upt % 10))
uptts=$(($uptt * 60))
upts=$(uptime -s | awk '{print $2}' | cut -d ":" -f3)
waitime=$(($uptts + $upts))

sleep $waitime