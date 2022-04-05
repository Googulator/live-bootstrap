# SPDX-FileCopyrightText: 2021 Paul Dersey <pdersey@gmail.com>
# SPDX-FileCopyrightText: 2022 fosslinux <fosslinux@aussies.space>
#
# SPDX-License-Identifier: GPL-3.0-or-later

src_unpack() {
    src_dir="${base_dir}/src"

    # Remove previous source diretory
    rm -rf "${pkg}"

    tar -xf "${src_dir}/${pkg}.tar"
}

src_prepare() {
    cp lib/fnmatch_.h lib/fnmatch.h
    cp lib/ftw_.h lib/ftw.h
    cp lib/search_.h lib/search.h
    touch config.h

    patch -Np0 -i ../../patches/touch-getdate.patch

    # Bison pre-generated file
    rm lib/getdate.c

    cp "${mk_dir}/pass2.mk" Makefile
}

src_install() {
    default

    # perl later requires /bin/pwd
    ln -s "${PREFIX}/bin/pwd" /bin/pwd
}
