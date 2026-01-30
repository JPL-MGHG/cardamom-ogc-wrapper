#!/usr/bin/env -S bash --login
set -euo pipefail
# This script is used to install any custom packages required by the algorithm.

# Get current location of build script
basedir=$( cd "$(dirname "$0")" ; pwd -P )

conda env update -f ${basedir}/environment.yml
git clone --depth 1 https://github.com/CARDAMOM-framework/CARDAMOM.git
pushd CARDAMOM
conda run --live-stream --name base "./BASH/CARDAMOM_COMPILE.sh"
popd