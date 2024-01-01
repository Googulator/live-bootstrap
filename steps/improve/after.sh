#!/bin/sh
#
# SPDX-FileCopyrightText: 2024 Gábor Stefanik <netrolller.3d@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
# After bootstrap, drop to a shell if needed, then shut down cleanly.

. /steps/bootstrap.cfg
. /steps/env

if [ "${INTERACTIVE}" = True ]; then
    env - PATH=${PREFIX}/bin PS1="\w # " bash -i
fi

if [ "${CHROOT}" = False ]; then
    echo s > /proc/sysrq_trigger # force sync
    sleep 1
    echo u > /proc/sysrq_trigger # remount everything R/O
    sleep 1
    echo o > /proc/sysrq_trigger # power off
fi
