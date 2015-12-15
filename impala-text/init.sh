#! /bin/sh -e

. ./common.sh

hdfs_init
hdfs dfs -rm ${HDFSDIR}/netflow_work 2>/dev/null || :

impala-shell ${IMPALA_ARGS} -e "DROP DATABASE ${DBNAME}_impala CASCADE" || :
impala-shell ${IMPALA_ARGS} -e "CREATE DATABASE ${DBNAME}_impala"
