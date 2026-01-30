#!/usr/bin/env -S bash --login
set -euo pipefail
# This script is the one that is called by the DPS.
# Use this script to prepare input paths for any files
# that are downloaded by the DPS and outputs that are
# required to be persisted

# Get current location of build script
basedir=$(dirname "$(readlink -f "$0")")

# Parse named arguments
input_file=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --input_file)
      input_file="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

# Validate input file argument
if [[ -z "$input_file" ]]; then
  echo "Error: --input_file argument is required"
  exit 1
fi

# Create output directory to store outputs.
# The name is output as required by the DPS.
mkdir -p ${PWD}/output

input_filename=$(basename "$input_file")
current_time=$(date +"%Y-%m-%d_%H-%M-%S")

OUTPUT_PARAM_FILENAME="output_param_file_${input_filename}.cbr"
OUTPUT_FILENAME="output_file_${input_filename}.nc"

conda run --live-stream --name base "${basedir}/CARDAMOM/C/projects/CARDAMOM_MDF/CARDAMOM_MDF.exe" "$input_file" "output/${OUTPUT_PARAM_FILENAME}"
conda run --live-stream --name base "${basedir}/CARDAMOM/C/projects/CARDAMOM_GENERAL/CARDAMOM_RUN_MODEL.exe" "$input_file" "output/${OUTPUT_PARAM_FILENAME}" "output/${OUTPUT_FILENAME}"