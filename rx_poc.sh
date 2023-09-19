#! /bin/bash

log_file=rx_poc.log
today=$(date "+%Y%m%d_%H%M%S")
weather_report=raw_data_$today
city=vancouver

curl --output $weather_report https://wttr.in/$city

grep °C $weather_report > temperatures.txt

cat $weather_report

# extract the current temperature
obs_tmp=$(cat -A temperatures.txt | head -1 | cut -d "+" -f2 | cut -d "^" -f1 )
echo "observed temperature = $obs_tmp"

fc_tmp=$(cat -A temperatures.txt | head -3 | tail -1 | cut -d "C" -f2 | cut -d "^" -f7 | cut -d "m" -f2)
echo "Forcast temperature = $fc_tmp"

hour=$(TZ='America/Los_Angeles' date "+%H")
day=$(TZ='America/Los_Angeles' date "+%d")
month=$(TZ='America/Los_Angeles' date "+%m")
year=$(TZ='America/Los_Angeles' date "+%Y")

row=$(echo -e "$year\t$month\t$day\t$obs_tmp\t$fc_tmp")
echo $row >> $log_file

