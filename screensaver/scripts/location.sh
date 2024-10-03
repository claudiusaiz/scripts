#!/bin/bash

# get IP
IP=`wget -qO - icanhazip.com | tr -d [:space:]`
if [[ $? -ne 0 ]]; then
	exit 1
fi

# download location info
location_page="/tmp/ip_page"
wget -qO $location_page http://whatismyipaddress.com/ip/${IP}

if [[ $? -ne 0 ]]; then
	rm -f $location_page
	exit 1
fi

# modify location info in order for it to be readable
cat $location_page | tr -d '\n' > ${location_page}.bkp
mv ${location_page}.bkp $location_page

sed -i "s/<tr>//g" $location_page
sed -i "s/<\/tr>/\n/g" $location_page
sed -i "s/<\/\?t.>//g" $location_page

# remove all images from page
sed -i "s/<img.*>//g" $location_page

# convert special characters
sed -i "s/&nbsp;/ /g" $location_page
sed -i "s/&deg;/°/g" $location_page
sed -i "s/&prime;/'/g" $location_page
sed -i "s/&Prime;/''/g" $location_page

# get ISP
ISP=`cat $location_page | grep ISP | cut -d ':' -f2 | tr -s [:space:]`

# get Organization
Org=`cat $location_page | grep Organization | cut -d ':' -f2 | tr -s [:space:]`

# get country
country=`cat $location_page | grep Country | cut -d ':' -f2 | tr -d [:space:]`

# get region
region=`cat $location_page | grep State | tail -n 1 | cut -d ':' -f2 | tr -d [:space:]`

# get city
city=`cat $location_page | grep City | cut -d ':' -f2 | tr -d [:space:]`

# get longitude & latitude
latitude=`cat $location_page | grep Latitude | cut -d ':' -f2`
longitude=`cat $location_page | grep Longitude | cut -d ':' -f2`

echo "IP: $IP"
echo $ISP
echo $Org
echo "$country, $region, $city"
echo "$latitude, $longitude"

#rm -f $location_page
