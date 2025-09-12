/* getcto.h -- calltrick util

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

static int getcto(Filter *f, const byte *buf, const int n = 256) {
    int ic = n;

    if (f->preferred_ctos) {
        for (const int *pc = f->preferred_ctos; *pc >= 0; pc++) {
            if (*pc < n && buf[*pc] == 0) {
                ic = *pc;
                break;
            }
        }
    }

#if 0
    // just a test to see if certain ctos would improve compression
    if (ic >= n)
        for (ic = 0; ic < n; ic += 16)
            if (buf[ic] == 0)
                break;
#endif
    if (ic >= n)
        for (ic = 0; ic < n; ic++)
            if (buf[ic] == 0)
                break;

    if (ic >= n)
        // throwCantPack("call trick problem");
        return -1;

    f->cto = (byte) ic;
    return ic;
}

/* vim:set ts=4 sw=4 et: */
