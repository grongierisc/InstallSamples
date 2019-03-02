#!/bin/bash
# Usage remove.sh [instanceName] [password]

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 2 ] || die "Usage remove.sh [instanceName] [password]"

DIR=$(dirname $0)
if [ "$DIR" = "." ]; then
DIR=$(pwd)
fi

instanceName=$1
password=$2

tClassImportDir=$DIR/install

irissession $instanceName -U %SYS <<EOF 
SuperUser
$password

Set NsEiste = ##class(Config.Namespaces).Exists("SAMPLES")
do:(NsEiste) ##class(Config.Namespaces).Delete("SAMPLES")
do:(NsEiste) ##class(%Library.EnsembleMgr).DisableNamespace("SAMPLES")

set CspExiste = ##Class(Security.Applications).Exists("/csp/SAMPLES")
do:(CspExiste) ##Class(Security.Applications).Delete("/csp/SAMPLES")

set DbExiste = ##class(Config.Databases).Exists("SAMPLES")
set Directory = ##class(Config.Databases).GetDirectory("SAMPLES")
do:(DbExiste) ##class(Config.Databases).Delete("SAMPLES")
do ##class(SYS.Database).DeleteDatabase(Directory)

halt
EOF

