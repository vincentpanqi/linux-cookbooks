#!/bin/bash -e

function install()
{
    # Install

    installAptGetPackages 'tmpreaper'

    # Config Cron

    local content=''
    local i=0

    for ((i = 0; i < ${#TMP_REAPER_FOLDERS[@]}; i = i + 3))
    do
        content="${content}\ntmpreaper -a -f -s -v --protect '${TMP_REAPER_FOLDERS[${i} + 1]}' '${TMP_REAPER_FOLDERS[${i} + 2]}' '${TMP_REAPER_FOLDERS[${i}]}'"
    done

    echo -e "$(trimString "${content}")" > "${TMP_REAPER_CRON_FOLDER}/tmp-reaper"
    chmod 755 "${TMP_REAPER_CRON_FOLDER}/tmp-reaper"
}

function main()
{
    appPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    source "${appPath}/../../../libraries/util.bash"
    source "${appPath}/../attributes/default.bash"

    checkRequireSystem
    checkRequireRootUser

    header 'INSTALLING TMP-REAPER'

    install
    installCleanUp
}

main "${@}"