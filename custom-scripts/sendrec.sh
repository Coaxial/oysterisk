#!/usr/bin/env bash
#converts recordings to wav then to mp3 then emails them

# args: $1=record file location $2=email addr to send to $3=DD-MM-YYYY
# $4=HH:MM:SS $5=CALLERID(num) $6=number dialled

lame -V 4 /tmp/$1.wav /tmp/$1.mp3

body=$(printf "%b\n" "Hello,\n\nPlease find the conversation recorded on $3 at $4 between $5 and $6.\n\nRegards,\nAsterisk")

subject="Recording for call to $6"

echo "$body" | mutt -s "$subject" -a /tmp/$1.mp3 -- $2

#rm /tmp/$1.*

exit 0