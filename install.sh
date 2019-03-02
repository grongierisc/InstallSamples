#!/bin/bash
# Usage install.sh [instanceName] [password]

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 2 ] || die "Usage install.sh [instanceName] [password]"

DIR=$(dirname $0)
if [ "$DIR" = "." ]; then
DIR=$(pwd)
fi

instanceName=$1
password=$2

tClassImportDir=$DIR/install

irissession $instanceName -U USER <<EOF 
SuperUser
$password
do \$system.OBJ.ImportDir("$tClassImportDir","*.cls","cubk",.errors,1)
write "Complation de l'installer done"
Set pVars("DirSamples")="$DIR/samples"
Do ##class(App.Installer).setup(.pVars)
zn "%SYS"

set props("DeepSeeEnabled")=1
set sc=##class(Security.Applications).Modify("/csp/samples", .props)

halt
EOF
