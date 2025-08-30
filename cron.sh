#!/usr/bin/env bash

# Cron fix
cd "$(dirname $0)"

# Phiên bản cần dùng
tag="7.19.4"
url="https://github.com/elseif/MikroTikPatch/releases/download/$tag/mikrotik-$tag.iso"

echo ">>> Checking $url"

if curl --output /dev/null --silent --head --fail "$url"; then
    echo ">>> URL exists: $url"
    # Ghi version mới vào Dockerfile
    sed -r "s/(ROUTEROS_VERSION=\")(.*)(\")/\1$tag\3/g" -i Dockerfile
    git commit -m "Release of RouterOS changed to $tag" -a
    git push
    git tag "$tag"
    git push --tags
else
    echo ">>> URL don't exist: $url"
fi
