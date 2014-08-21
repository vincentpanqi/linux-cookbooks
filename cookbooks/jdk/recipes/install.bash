#!/bin/bash -e

function install()
{
    # Clean Up

    rm --force --recursive "${jdkInstallFolder}" '/usr/local/bin/java' '/usr/local/bin/javac'
    mkdir --parents "${jdkInstallFolder}"

    # Install

    unzipRemoteFile "${jdkDownloadURL}" "${jdkInstallFolder}"

    # Config Lib

    chown --recursive "$(whoami)":"$(whoami)" "${jdkInstallFolder}"
    ln --symbolic "${jdkInstallFolder}/bin/java" '/usr/local/bin/java'
    ln --symbolic "${jdkInstallFolder}/bin/javac" '/usr/local/bin/javac'

    # Config Profile

    local profileConfigData=('__INSTALL_FOLDER__' "${jdkInstallFolder}")

    createFileFromTemplate "${appPath}/../templates/default/jdk.sh.profile" '/etc/profile.d/jdk.sh' "${profileConfigData[@]}"

    # Display Version

    info "\n$(java -version 2>&1)"
}

function main()
{
    appPath="$(cd "$(dirname "${0}")" && pwd)"

    source "${appPath}/../../../lib/util.bash"
    source "${appPath}/../attributes/default.bash"

    checkRequireSystem
    checkRequireRootUser

    header 'INSTALLING JDK'

    install
    installCleanUp
}

main "${@}"