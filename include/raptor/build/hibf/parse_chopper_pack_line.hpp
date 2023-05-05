// --------------------------------------------------------------------------------------------------
// Copyright (c) 2006-2023, Knut Reinert & Freie Universität Berlin
// Copyright (c) 2016-2023, Knut Reinert & MPI für molekulare Genetik
// This file may be used, modified and/or redistributed under the terms of the 3-clause BSD-License
// shipped with this file and also available at: https://github.com/seqan/raptor/blob/main/LICENSE.md
// --------------------------------------------------------------------------------------------------

/*!\file
 * \brief Provides raptor::hibf::parse_chopper_pack_line.
 * \author Enrico Seiler <enrico.seiler AT fu-berlin.de>
 */

#pragma once

#include <string>
#include <vector>

#include <chopper/layout/layout.hpp>

namespace raptor::hibf
{

chopper::layout::layout::user_bin parse_chopper_pack_line(std::string const & current_line,
                                                          std::vector<std::vector<std::string>> & user_bin_filenames);

} // namespace raptor::hibf
