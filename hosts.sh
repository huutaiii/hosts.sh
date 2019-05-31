#! /usr/bin/env bash

rm -rf parts
mkdir parts

while read url; do
	filename=`grep -oP '(?<=://).*' <<< "$url" | tr '/' '_'`
	curl "$url" -o "parts/$filename"
done <sources.txt

cat `find parts -type f` user.hosts \
	| grep -oP "^\d+\.\d+\.\d+\.\d+.*$" \
	| cut -d'#' -f1 \
	| awk '{$1=$1};1' \
	| awk '!a[$0]++' \
	| egrep -v "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+ $(printf '(%s)' $(printf %s "$(awk NF whitelist.txt | cut -d'#' -f1 | awk '{$1=$1};1')" | tr '\n' '|'))$" \
	>hosts
