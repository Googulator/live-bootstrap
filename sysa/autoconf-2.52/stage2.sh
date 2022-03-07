# SPDX-FileCopyrightText: 2021 Andrius Štikonas <andrius@stikonas.eu>
#
# SPDX-License-Identifier: GPL-3.0-or-later

checksum=51bb5ba7d787cf33c74d7c79a843c5e615c050e0c0ee3ac724c4a1dea3a8b75a

src_prepare() {
    rm doc/standards.info doc/autoconf.info
    rm Makefile.in */Makefile.in
    rm configure
    autoconf-2.52
    automake-1.4

    # Install autoconf data files into versioned directory
    for file in */Makefile.in Makefile.in; do
        sed -i '/^pkgdatadir/s:$:-@VERSION@:' $file
    done
}

src_configure() {
    ./configure --prefix="${PREFIX}" --program-suffix=-2.52
}

src_compile() {
    make MAKEINFO=true DESTDIR="${DESTDIR}"
}

src_install() {
    # Remove manually installed autoconf
    rm ${PREFIX}/bin/autoconf-2.52
    rm -rf ${PREFIX}/share/autoconf-2.52

    make install MAKEINFO=true DESTDIR="${DESTDIR}"
}
