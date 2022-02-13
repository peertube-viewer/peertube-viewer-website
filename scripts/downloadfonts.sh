#!/bin/sh

datafile=$(mktemp)
curl --location https://google-webfonts-helper.herokuapp.com/api/fonts > "$datafile"
tmpdir=$(mktemp -d)

function onetype() {
	version=$(jq '.[]|select(.id=="'"$1"'")|.version'  "$datafile"| sed 's/"//g')
	rm "static/webfonts/$1"-*
	for i in {latin-ext,latin,greek,cyrillic-ext,cyrillic}"&variants="{700,700italic,regular}
	do
		curl "https://google-webfonts-helper.herokuapp.com/api/fonts/$1?download=zip&subsets=$i" --location --output "$tmpdir"/"$i".zip
	done

	for file in "$tmpdir"/*.zip
	do
		unzip "$file" -d static/webfonts/
	done
	sed 's/---VERSION---/'"$version"'/g' scripts/"$1".css > static/css/"$1".css
	rm "$tmpdir"/*.zip
}

onetype comfortaa
onetype open-sans
