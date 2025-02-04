#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2006-2025 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2025 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: BSD-3-Clause

set -e
SCRIPT_ROOT=$(dirname $(readlink -f $0))
source $SCRIPT_ROOT/variables.sh

trap 'echo; echo "## [$(date +"%Y-%m-%d %T")] ERROR ##"' ERR

echo "## [$(date +"%Y-%m-%d %T")] Start ##"

echo -n "[$(date +"%Y-%m-%d %T")] Copying input..."
    /usr/bin/time -o $copy_time -v \
        $SCRIPT_ROOT/copy_input.sh \
            &>$copy_log
echo "Done."

echo -n "[$(date +"%Y-%m-%d %T")] Running squeakr..."
    /usr/bin/time -o $squeakr_time -v \
        $SCRIPT_ROOT/squeakr.sh \
            &>$squeakr_log
echo "Done."

echo -n "[$(date +"%Y-%m-%d %T")] Running mantis build..."
    /usr/bin/time -o $mantis_build_time -v \
        $SCRIPT_ROOT/mantis_build.sh \
            &>$mantis_build_log
echo "Done."

echo -n "[$(date +"%Y-%m-%d %T")] Running mantis mst..."
    /usr/bin/time -o $mantis_mst_time -v \
        $SCRIPT_ROOT/mantis_mst.sh \
            &>$mantis_mst_log
echo "Done."

echo -n "[$(date +"%Y-%m-%d %T")] Running mantis query..."
    /usr/bin/time -o $mantis_query_time -v \
        $SCRIPT_ROOT/mantis_query.sh \
            &>$mantis_query_log
echo "Done."

echo "## [$(date +"%Y-%m-%d %T")] End ##"
