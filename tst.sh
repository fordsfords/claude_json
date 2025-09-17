#!/bin/bash
# Go to settings -> privacy -> export

jq <conversations.2025-09-11.json >2025-09-11.x

echo "Corrupted chats from 2025-09-11"
./corrupted.pl 2025-09-11.x | egrep "title='[^'].*empty=[^0]" >corrupted.x
cat corrupted.x
