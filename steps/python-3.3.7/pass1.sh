# SPDX-FileCopyrightText: 2022 fosslinux <fosslinux@aussies.space>
#
# SPDX-License-Identifier: GPL-3.0-or-later

src_prepare() {
    default

    # Delete generated files
    rm Include/Python-ast.h Python/Python-ast.c
    rm Lib/stringprep.py
    rm Lib/pydoc_data/topics.py
    rm Misc/Vim/python.vim
    rm -r Modules/_ctypes/libffi
    rm Python/importlib.h
    mv Lib/plat-generic .
    rm -r Lib/plat-*
    mv plat-generic Lib/
    grep generated -r . -l | grep encodings | xargs rm

    # Regenerate encodings
    mkdir Tools/unicode/in Tools/unicode/out
    mv ../CP437.TXT Tools/unicode/in/
    pushd Tools/unicode
    python -B gencodec.py in/ ../../Lib/encodings/
    popd

    # Regenerate unicode
    rm Modules/unicodedata_db.h Modules/unicodename_db.h Objects/unicodetype_db.h
    mv ../*.txt ../*.zip .
    python -B Tools/unicode/makeunicodedata.py

    # Regenerate sre_constants.h
    rm Modules/sre_constants.h
    cp Lib/sre_constants.py .
    python -B sre_constants.py

    # Regenerate _ssl_data.h
    python -B Tools/ssl/make_ssl_data.py /usr/include/openssl Modules/_ssl_data.h

    # Regenerate autoconf
    autoreconf-2.71 -fi
}

src_configure() {
    MACHDEP=linux ac_sys_system=Linux \
    CFLAGS="-U__DATE__ -U__TIME__" \
    LDFLAGS="-L${LIBDIR}" \
        ./configure \
        --build=i386-unknown-linux-musl \
        --host=i386-unknown-linux-musl \
        --prefix="${PREFIX}" \
        --libdir="${LIBDIR}" \
        --with-system-ffi
}

src_compile() {
    # Build pgen
    PYTHONDONTWRITEBYTECODE=1 make "${MAKEJOBS}" Parser/pgen
    # Regen graminit.c and graminit.h
    PYTHONDONTWRITEBYTECODE=1 make "${MAKEJOBS}" Include/graminit.h

    # Regenerate some Python scripts using the other regenerated files
    # Must move them out to avoid using Lib/ module files which are
    # incompatible with running version of Python
    cp Lib/{symbol,keyword,token}.py .
    cp token.py _token.py
    python -B symbol.py
    python -B keyword.py
    python -B token.py

    # Now build the main program
    PYTHONDONTWRITEBYTECODE=1 make -j1 CFLAGS="-U__DATE__ -U__TIME__"
}

src_install() {
    default
    ln --symbolic --relative "${DESTDIR}${LIBDIR}/python3.3/lib-dynload" "${DESTDIR}${PREFIX}/lib/python3.3/lib-dynload"
    ln --symbolic --relative "${DESTDIR}${PREFIX}/bin/python3.3" "${DESTDIR}${PREFIX}/bin/python"

    # Remove non-reproducible .pyc/o files
    find "${DESTDIR}" -name "*.pyc" -delete
    find "${DESTDIR}" -name "*.pyo" -delete

    # This file is not reproducible and I don't care to fix it
    rm "${DESTDIR}/${PREFIX}/lib/python3.3/lib2to3/"{Pattern,}"Grammar3.3.7.final.0.pickle"
}
