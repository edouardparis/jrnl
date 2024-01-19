#!/usr/bin/env bash

dates() {
    ${dateutils_bin}/dateseq \
        "$(date --date "2 months ago" +"${f}")" \
        "$(date --date "2 months" +"${f}")" \
        -i "${f}" \
        -f "${f}"
}

create_if_not_exist() {
    for file in $(dates); do
        year="${file%%/*}"
        month="${file##*/}"
        mkdir -p "$(dirname "$file")"
        if [ ! -f "$file" ]; then
            touch "$file"
            cal "$month" "$year" > "$file"
        fi
    done
}
