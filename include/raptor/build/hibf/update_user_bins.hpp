// --------------------------------------------------------------------------------------------------
// Copyright (c) 2006-2023, Knut Reinert & Freie Universität Berlin
// Copyright (c) 2016-2023, Knut Reinert & MPI für molekulare Genetik
// This file may be used, modified and/or redistributed under the terms of the 3-clause BSD-License
// shipped with this file and also available at: https://github.com/seqan/raptor/blob/main/LICENSE.md
// --------------------------------------------------------------------------------------------------

/*!\file
 * \brief Provides raptor::hibf::update_user_bins.
 * \author Enrico Seiler <enrico.seiler AT fu-berlin.de>
 */

#pragma once

#include <chopper/layout/layout.hpp>

#include <raptor/build/hibf/build_data.hpp>

namespace raptor::hibf
{

void update_user_bins(std::vector<int64_t> & filename_indices, chopper::layout::layout::user_bin const & record);

} // namespace raptor::hibf
