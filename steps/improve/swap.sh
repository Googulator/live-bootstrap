#!/bin/sh
#
# SPDX-FileCopyrightText: 2023 fosslinux <fosslinux@aussies.space>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Set up swap

. /steps/bootstrap.cfg
. /steps/env

if ! test -f /swap
then
    echo "Making swap..."
    dd if=/dev/zero of=/swap bs=1M count=${SWAP_SIZE}
    mkswap /swap
fi
swapon /swap
