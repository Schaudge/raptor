# SPDX-FileCopyrightText: 2006-2024 Knut Reinert & Freie Universität Berlin
# SPDX-FileCopyrightText: 2016-2024 Knut Reinert & MPI für molekulare Genetik
# SPDX-License-Identifier: BSD-3-Clause

macro (raptor_require_mason)
    set (mason_args ${SEQAN3_EXTERNAL_PROJECT_CMAKE_ARGS})
    list (APPEND mason_args "-DSEQAN_BUILD_SYSTEM=APP:mason2")

    include (ExternalProject)
    ExternalProject_Add (mason
                         PREFIX mason
                         GIT_REPOSITORY "https://github.com/seqan/seqan.git"
                         GIT_TAG "main"
                         GIT_SHALLOW true
                         SOURCE_DIR "${PROJECT_BINARY_DIR}/mason/seqan"
                         CMAKE_ARGS "${mason_args}"
                         INSTALL_COMMAND ""
    )
    unset (mason_args)

    ExternalProject_Get_Property (mason BINARY_DIR)
    install (FILES "${BINARY_DIR}/bin/mason_genome"
             DESTINATION "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
             PERMISSIONS OWNER_READ
                         OWNER_WRITE
                         OWNER_EXECUTE
                         GROUP_READ
                         GROUP_EXECUTE
                         WORLD_READ
                         WORLD_EXECUTE
    )
    install (FILES "${BINARY_DIR}/bin/mason_variator"
             DESTINATION "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
             PERMISSIONS OWNER_READ
                         OWNER_WRITE
                         OWNER_EXECUTE
                         GROUP_READ
                         GROUP_EXECUTE
                         WORLD_READ
                         WORLD_EXECUTE
    )
endmacro ()
