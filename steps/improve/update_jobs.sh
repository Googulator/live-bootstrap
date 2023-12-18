#!/bin/sh
cat >> /steps/bootstrap.cfg <<- EOF
JOBS=${FINAL_JOBS}
EOF

. /steps/bootstrap.cfg
. /steps/env
