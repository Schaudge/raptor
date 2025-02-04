#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2006-2024 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2024 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: BSD-3-Clause

set -euo pipefail

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    current_file=$(readlink -f "$0")
    echo "The script '${current_file}' must be sourced, not executed."
    echo "There is potentially another script that sources this script."
    echo "If not, please run 'source ${current_file}' instead."
    exit 1
fi

###
# Directory configuration
OUTPUT_DIR=""
# Outputs:
# - ${OUTPUT_DIR}/logs: The log files
# - ${OUTPUT_DIR}/build: The built dependencies
# - ${OUTPUT_DIR}/<NUMBER_OF_BINS>/bins: The simulated bins
# - ${OUTPUT_DIR}/<NUMBER_OF_BINS>/reads_e<READ_ERRORS>_<READ_LENGTH>: The simulated reads
# - ${OUTPUT_DIR}/<NUMBER_OF_BINS>/info/*.vcf.gz: The VCF files generated by Mason Variator (if KEEP_VCF=true)
# - ${OUTPUT_DIR}/<NUMBER_OF_BINS>/<NUMBER_OF_BINS>.filenames: A list of the bin files
# - ${OUTPUT_DIR}/<NUMBER_OF_BINS>/info/config.sh: The configuration file used for the simulation
# - ${OUTPUT_DIR}/<NUMBER_OF_BINS>/info/run.sh: The script used to run the simulation

####
# Parameters supporting suffixes (e.g. 4G, 1M, 1024)
# The following suffixes are supported (case-sensitive): <none>, K, M, G, T, P
# The values must not contain spaces, i.e., "4 G" is not allowed.
# The suffixes are interpreted as binary suffixes, i.e., 1K = 1024.
REFERENCE_LENGTH=2M
NUMBER_OF_BINS="64 1K"
NUMBER_OF_HAPLOTYPES=2
READ_COUNT=2K
# The total sequence size will be REFERENCE_LENGTH * NUMBER_OF_HAPLOTYPES

# A file containing sizes of the reference sequences. The file must contain one size per line.
# The size is in bytes, i.e., characters.
# If set, the simulated references are not uniform in size but are sampled from the given file and normalized for
# the REFERENCE_LENGTH and NUMBER_OF_BINS.
SAMPLE_FROM=""

# Optional, a path to the root of the raptor repository.
# If set, the script will use the raptor binaries from the given path.
# Otherwise, the repository will be cloned.
REPO_PATH=""

###
# Other parameters
READ_ERRORS=2
READ_LENGTH=250
# Seed used for mason_genome
SEED=42
THREADS=12
# Whether to keep the VCF files generated by Mason Variator (haplotype generation). Valid values: true, false
KEEP_VCF=false

### Internal
expand_suffix() {
    local VAR=$1
    local VALUE=${!1}

    if [[ ${VALUE} =~ " " ]]; then
        echo "The given value must not contain spaces: '${VALUE}'"
        return 1
    fi

    eval "${VAR}"='$(numfmt --from=iec "${VALUE}")'
}

to_iec() {
    numfmt --to=iec "$1" --format '%.0f'
}

check_config() {
    if [[ -z "${OUTPUT_DIR}" ]]; then
        echo "[ERROR] The variable OUTPUT_DIR must be set."
        return 1
    fi

    if [[ ${REFERENCE_LENGTH} -lt ${READ_LENGTH} ]]; then
        echo "[ERROR] The reference length (${REFERENCE_LENGTH}) must be greater than the read length (${READ_LENGTH})."
        return 1
    fi

    if [[ ${READ_ERRORS} -gt ${READ_LENGTH} ]]; then
        echo "[ERROR] The number of read errors (${READ_ERRORS}) must be less than the read length (${READ_LENGTH})."
        return 1
    fi

    if [[ "${KEEP_VCF}" != "true" && "${KEEP_VCF}" != "false" ]]; then
        echo "[ERROR] The value of KEEP_VCF must be either 'true' or 'false'."
        return 1
    fi

    for BINS in ${NUMBER_OF_BINS}; do
        expand_suffix "BINS"

        if [[ ${BINS} -gt ${READ_COUNT} ]]; then
            echo "[ERROR] The number of bins (${BINS}) must be less than the number of reads (${READ_COUNT})."
            return 1
        fi

        if [[ $((BINS * NUMBER_OF_HAPLOTYPES)) -gt ${READ_COUNT} ]]; then
            echo "[WARNING] At least one read will be simulated for each haplotype. This results in $((BINS * NUMBER_OF_HAPLOTYPES)) reads, which exceeds the total number of reads (${READ_COUNT})."
        fi

        if [[ -f "${SAMPLE_FROM}" ]]; then
            if [[ $(wc -l "${SAMPLE_FROM}") -lt ${BINS} ]]; then
                echo "[ERROR] The number of lines in the file '${SAMPLE_FROM}' must be at least ${BINS}."
                return 1
            fi
        fi

        if [[ -d "${OUTPUT_DIR}/${BINS}" ]]; then
            echo "[ERROR] The output directory '${OUTPUT_DIR}/${BINS}' already exists."
            echo "[ERROR] If you want to rerun the simulation for ${BINS} bins, please remove the directory."
            echo "[ERROR] If you want to keep the existing data, remove '${BINS}' from the NUMBER_OF_BINS variable."
            return 1
        fi
    done
}

expand_suffix "REFERENCE_LENGTH"
expand_suffix "READ_COUNT"
expand_suffix "NUMBER_OF_HAPLOTYPES"
NEEDS_MASON=$(test ${NUMBER_OF_HAPLOTYPES} -ne 1 && echo ON || echo OFF)

check_config
