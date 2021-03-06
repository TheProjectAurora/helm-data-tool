#!/usr/bin/env sh


full_command=$(realpath "$0")
path=$(dirname "$full_command")

helm template "$@" "$path/../helmchart_yaml/charts" | egrep -v "^#|^---"