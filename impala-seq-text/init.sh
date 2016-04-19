#! /bin/sh -e

. ./common.sh

hdfs_init

impala-shell ${IMPALA_ARGS} -q "DROP DATABASE IF EXISTS ${DBNAME}_impala CASCADE; INVALIDATE METADATA;" 2>&1
sleep 10
