#!/bin/sh

# Copyright (C) 2016-2018 Franco Fichtner <franco@opnsense.org>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
# OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

BASE_MTREE=/usr/local/opnsense/version/base.mtree
KERNEL_MTREE=/usr/local/opnsense/version/kernel.mtree
PKG_PROGRESS_FILE=/tmp/pkg_upgrade.progress

# Truncate upgrade progress file
: > ${PKG_PROGRESS_FILE}

echo "***GOT REQUEST TO AUDIT SECURITY***" >> ${PKG_PROGRESS_FILE}
for MTREE in ${BASE_MTREE} ${KERNEL_MTREE}; do
	# XXX complain if file is missing
	# XXX exclude /etc on base
	if [ -f ${MTREE} ]; then
		mtree -e < ${MTREE} >> ${PKG_PROGRESS_FILE} 2>&1
	fi
done
pkg audit -F >> ${PKG_PROGRESS_FILE} 2>&1
echo '***DONE***' >> ${PKG_PROGRESS_FILE}
