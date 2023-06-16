#!/bin/bash

function main() {
    local scriptDir
    scriptDir="$(cd "$(dirname "${0}")" && pwd )"

    printf "Installing extentions...\n"

    cd "${scriptDir}" || exit 1

    while IFS="" read -r p || [[ -n "${p}" ]]; do
        code --install-extension "${p}" > /dev/null 2>&1         \
            || printf "Extention %s didn't get installed" "${p}"
    done < extentions.txt

    printf "Extentions installed !\n"
}


main
