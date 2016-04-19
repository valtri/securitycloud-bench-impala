#! /bin/sh -e

. ./common.sh

for i in `seq 1 ${N}`; do
	cat <<EOF
# dbinit
impala-shell ${IMPALA_ARGS} -q "CREATE DATABASE ${DBNAME}_impala; INVALIDATE METADATA;" 2>&1
# create
impala-shell ${IMPALA_ARGS} -d ${DBNAME}_impala -f ${TMPDIR}/text-init.sql 2>&1
# upload
hdfs dfs -put ${SRCFILE} ${HDFSDIR}/netflow_work 2>&1
# import
impala-shell ${IMPALA_ARGS} -d ${DBNAME}_impala -q 'REFRESH flowdata' 2>&1
EOF
	if test ${i} -lt ${N}; then
		cat <<EOF
# destroy
impala-shell ${IMPALA_ARGS} -q "DROP DATABASE ${DBNAME}_impala CASCADE; INVALIDATE METADATA;" 2>&1
# remove
hdfs dfs -rm ${HDFSDIR}/netflow_work\* 2>&1
# sleep
sleep 10
EOF
	fi
done

for i in `seq 1 ${N}`; do
	for q in `ls -1 ./queries/*.sql | sort`; do
		name=`basename ${q} .sql`
		cat <<EOF
# ${name}
impala-shell ${IMPALA_ARGS} -d ${DBNAME}_impala -f ${q} 2>&1
EOF
	done
done
