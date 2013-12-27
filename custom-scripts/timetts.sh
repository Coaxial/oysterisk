#!/usr/bin/env bash
# Renders callername using Google TTS API
# call it with script.sh hours minutes calluniqueid
wget -O /tmp/$3-timetts-part1.mp3 --user-agent="Mozilla/5.0 (X11\; Linux\; rv:8.0) Gecko/20100101" http://translate.google.com/translate_tts?tl=pl\&q=Obecnie%20jest%20$1%20$2%20w%20Montrealu.%20Czy%20nadal%20chcesz%20zadzwoni%C4%87%20do%20Gali%3F

wget -O /tmp/$3-timetts-part2.mp3 --user-agent="Mozilla/5.0 (X11\; Linux\; rv:8.0) Gecko/20100101" http://translate.google.com/translate_tts?tl=pl\&q=Naci%C5%9Bnij%201%20%C5%BCeby%20kontynuowa%C4%87%2C%20naci%C5%9Bnij%202%20albo%20roz%C5%82%C4%85cz%20si%C4%99%20%C5%BCeby%20anulowa%C4%87

ffmpeg -i "concat:/tmp/$3-timetts-part1.mp3|/tmp/$3-timetts-part2.mp3" -acodec copy /tmp/$3-timetts.mp3

mpg123 -w /tmp/$3-timetts.wav /tmp/$3-timetts.mp3

sox /tmp/$3-timetts.wav -t raw -r 8000 -c 1 /tmp/$3-timetts.sln tempo 1.2

chown asterisk.asterisk /tmp/$3-timetts.sln

exit 0