/* p_com.h -- dos/com executable format

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

#pragma once

/*************************************************************************
// dos/com
**************************************************************************/

class PackCom /*not_final*/ : public Packer {
    typedef Packer super;

public:
    explicit PackCom(InputFile *f) : super(f) { bele = &N_BELE_RTP::le_policy; }
    virtual int getVersion() const override { return 13; }
    virtual int getFormat() const override { return UPX_F_DOS_COM; }
    virtual const char *getName() const override { return "dos/com"; }
    virtual const char *getFullName(const Options *) const override { return "i086-dos16.com"; }
    virtual const int *getCompressionMethods(int method, int level) const override;
    virtual const int *getFilters() const override;

    virtual void pack(OutputFile *fo) override;
    virtual void unpack(OutputFile *fo) override;

    virtual tribool canPack() override;
    virtual tribool canUnpack() override;

protected:
    virtual Linker *newLinker() const override;
    void addFilter16(int filter_id);
    // dos/sys will override these:
    virtual unsigned getCallTrickOffset() const { return 0x100; }
    virtual void buildLoader(const Filter *ft) override;
    virtual void patchLoader(OutputFile *fo, byte *, int, unsigned);
};

/* vim:set ts=4 sw=4 et: */
