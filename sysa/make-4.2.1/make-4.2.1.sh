# SPDX-FileCopyrightText: 2021 Andrius Štikonas <andrius@stikonas.eu>
#
# SPDX-License-Identifier: GPL-3.0-or-later

src_prepare() {
    default

    rm doc/make.info
    touch doc/make.info

    # We don't have autopoint from gettext yet
    AUTOPOINT=true autoreconf -fi
}

src_configure() {
    ./configure \
        --prefix="${PREFIX}" \
        --target=i386-unknown-linux-gnu \
        --host=i386-unknown-linux-gnu \
        --build=i386-unknown-linux-gnu \
        --disable-nls
}

src_compile() {
    make MAKEINFO="true"
}

src_install() {
    make install MAKEINFO="true" DESTDIR="${DESTDIR}"
}
