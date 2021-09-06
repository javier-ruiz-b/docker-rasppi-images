#!/bin/bash
set -euo pipefail
docker exec -it -u www-data:www-data nextcloud-official_app_1 ./occ "$@"
