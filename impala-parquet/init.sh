#! /bin/sh -e

. ./common.sh

hdfs_init
hdfs dfs -rm ${HDFSDIR}/netflow_work 2>/dev/null || :

impala-shell ${IMPALA_ARGS} -q "DROP DATABASE ${DBNAME}_impala CASCADE" >/dev/null 2>&1 || :
impala-shell ${IMPALA_ARGS} -q "CREATE DATABASE ${DBNAME}_impala" 2>&1
