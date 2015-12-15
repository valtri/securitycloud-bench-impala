#! /bin/sh -e

. ./common.sh

hdfs dfs -rm ${HDFSDIR}/netflow_work 2>&1
