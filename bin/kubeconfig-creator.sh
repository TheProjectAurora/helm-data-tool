#!/usr/bin/env sh
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
set -e

help() {
    echo "Usage: $0 -b <base dir> [-h <API server>] [-u <name for service account>]"
    exit 1
}

full_command=$(realpath "$0")
path=$(dirname "$full_command")
helm_data_tool="$path/helm-data-yaml.sh"

host=https://kubernetes.default.svc/
user=default

t="false"
for arg in  "$@"; do
    if [ "$t" = "true" ]; then
        t="false"
    else
        case "$arg" in
        -b)
            basedir="$2"
            t="true"            
        ;;
        -h)
            host="$2"
            t="true"
        ;;
        -u)
            user="$2"
            t="true"
        ;;
        *)
            help
        ;;
        esac
        shift;shift
    fi
done

if test ! -f"$basedir/ca.crt" -o ! -f "$basedir/token"; then
    echo Token or cert authority file is missing from "$basedir" 1>&2
    exit 1
fi

"$helm_data_tool" -f "$path/../templates/kubeconfig.yaml" --set clusters[0].cluster.certificate-authority-data="$(base64 < "$basedir/ca.crt" )" \
    --set clusters[0].cluster.server="${host}",clusters[0].name="${host}",contexts[0].context.cluster="${host}" \
    --set contexts[0].context.user="${user}",users[0].name="${user}" \
    --set users[0].user.token="$(cat "$basedir/token" )" 
