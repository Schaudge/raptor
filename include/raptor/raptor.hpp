// -----------------------------------------------------------------------------------------------------
// Copyright (c) 2006-2022, Knut Reinert & Freie Universität Berlin
// Copyright (c) 2016-2022, Knut Reinert & MPI für molekulare Genetik
// This file may be used, modified and/or redistributed under the terms of the 3-clause BSD-License
// shipped with this file and also available at: https://github.com/seqan/raptor/blob/master/LICENSE.md
// -----------------------------------------------------------------------------------------------------

#pragma once

#include <sharg/parser.hpp>

namespace raptor
{

void init_top_level_parser(sharg::parser & parser);
void run_build(sharg::parser & parser);
void run_search(sharg::parser & parser);

} // namespace raptor
