#!/bin/sh
#
# SPDX-FileCopyrightText: 2023 fosslinux <fosslinux@aussies.space>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Add the rest of the FHS that we will use and is not created pre-boot
rm -rf /sbin /usr/sbin
ln -s /usr/bin /usr/sbin
for d in bin lib sbin share; do
    ln -s "usr/${d}" "/${d}" || true
done
mkdir -p /etc /run /var /var/log /var/lock /var/spool /var/tmp /var/cache /proc /sys /tmp /dev
mount -t devtmpfs none /dev || true
mount -t proc proc /proc > /dev/null 2>&1 || true
mount -t sysfs sysfs /sys > /dev/null 2>&1 || true
# Make /tmp a ramdisk (speeds up configure etc significantly)
mount -t tmpfs tmpfs /tmp > /dev/null 2>&1 || true
# Add /etc/resolv.conf
echo 'nameserver 1.1.1.1' > /etc/resolv.conf
echo 'nameserver 1.1.1.1' > /etc/resolv.conf.head
