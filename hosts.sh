#! /usr/bin/env bash

rm -rf parts
mkdir parts

while read url; do
	filename=`grep -oP '(?<=://).*' <<< "$url" | tr '/' '_'`
	curl "$url" -o "parts/$filename"
done <sources.txt

cat `find parts -type f` user.hosts |
	grep -oP "^[0-9a-f:.]+[ \t]+.*$" | # filter hosts entries
	cut -d'#' -f1 |	awk '{$1=$1};1' | # trailing comments
	awk '!a[$0]++' | # remove duplicate entries
	# apply whitelist
	egrep -v "^(0\.0\.0\.0|127\.0\.0\.1)[ \t]+$(printf '(%s)' $(printf %s "$(awk NF whitelist.txt | cut -d'#' -f1 | awk '{$1=$1};1')" | tr '\n' '|'))$" \
	>hosts
