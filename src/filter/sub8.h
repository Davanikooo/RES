/* sub8.h -- simple delta filter

   This file is part of the Resize executable compressor.

   Copyright (C) 2025 WHO-AM-I-404
   Based on UPX - Ultimate Packer for eXecutables
   Copyright (C) 1996-2025 Markus Franz Xaver Johannes Oberhumer
   Copyright (C) 1996-2025 Laszlo Molnar
   All Rights Reserved.

   Resize and the UCL library are free software; you can redistribute them
   and/or modify them under the terms of the GNU General Public License as
   published by the Free Software Foundation; either version 2 of
   the License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; see the file COPYING.
   If not, write to the Free Software Foundation, Inc.,
   59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

   WHO-AM-I-404 <who-am-i-404@proton.me>
   Based on original work by:
   Markus F.X.J. Oberhumer <markus@oberhumer.com>
   Laszlo Molnar <ezerotven+github@gmail.com>
 */

/*************************************************************************
//
**************************************************************************/

#include "sub.hh"

#define SUB8(f, N)  SUB(f, N, unsigned char, get_8, set_8)
#define ADD8(f, N)  ADD(f, N, unsigned char, get_8, set_8)
#define SCAN8(f, N) SCAN(f, N, unsigned char, get_8, set_8)

/*************************************************************************
//
**************************************************************************/

// filter
static int f_sub8_1(Filter *f) { SUB8(f, 1) }

static int f_sub8_2(Filter *f) { SUB8(f, 2) }

static int f_sub8_3(Filter *f) { SUB8(f, 3) }

static int f_sub8_4(Filter *f) { SUB8(f, 4) }

// unfilter
static int u_sub8_1(Filter *f) { ADD8(f, 1) }

static int u_sub8_2(Filter *f) { ADD8(f, 2) }

static int u_sub8_3(Filter *f) { ADD8(f, 3) }

static int u_sub8_4(Filter *f) { ADD8(f, 4) }

// scan
static int s_sub8_1(Filter *f) { SCAN8(f, 1) }

static int s_sub8_2(Filter *f) { SCAN8(f, 2) }

static int s_sub8_3(Filter *f) { SCAN8(f, 3) }

static int s_sub8_4(Filter *f) { SCAN8(f, 4) }

#undef SUB
#undef ADD
#undef SCAN
#undef SUB8
#undef ADD8
#undef SCAN8

/* vim:set ts=4 sw=4 et: */
