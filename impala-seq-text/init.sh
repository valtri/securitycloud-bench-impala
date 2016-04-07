#! /bin/sh -e

. ./common.sh

hdfs_init
hdfs dfs -rm ${HDFSDIR}/netflow_work\* >/dev/null 2>&1 || :

impala-shell ${IMPALA_ARGS} -q "DROP DATABASE ${DBNAME}_impala CASCADE; INVALIDATE METADATA;" >/dev/null 2>&1 || :
impala-shell ${IMPALA_ARGS} -q "CREATE DATABASE ${DBNAME}_impala; INVALIDATE METADATA;" 2>&1
