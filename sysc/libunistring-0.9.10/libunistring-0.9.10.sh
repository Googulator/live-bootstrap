# SPDX-FileCopyrightText: 2022 Andrius Štikonas <andrius@stikonas.eu>
#
# SPDX-License-Identifier: GPL-3.0-or-later

urls="https://mirrors.kernel.org/gnu/libunistring/libunistring-0.9.10.tar.xz
 https://git.savannah.gnu.org/cgit/gnulib.git/snapshot/gnulib-52a06cb3.tar.gz"

src_prepare() {
    find . -name '*.info*' -delete

    # libunistring does not specify which gnulib snapshot was used,
    # pick a random one that works
    GNULIB_TOOL=../gnulib-52a06cb3/gnulib-tool ./autogen.sh

    # autogen.sh does not regenerate libtool files
    autoreconf-2.69 -fi
}

src_configure() {
    ./configure \
	--prefix="${PREFIX}" \
	--libdir="${PREFIX}/lib/musl" \
	--disable-shared
}
