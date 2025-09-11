#!/bin/bash
# Go to settings -> privacy -> export

jq <conversations.json >conversations.x

./x.pl conversations.x | egrep "title='[^'].*empty=[^0]"
