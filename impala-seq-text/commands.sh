#! /bin/sh -e

. ./common.sh

for i in `seq 1 ${N}`; do
	cat <<EOF
# init
impala-shell ${IMPALA_ARGS} -q 'INVALIDATE METADATA' 2>&1
# import
impala-shell ${IMPALA_ARGS} -d ${DBNAME}_impala -f ${TMPDIR}/text-init.sql 2>&1
EOF
	for f in `cd ${SRCDIR10}/; ls -1 | sort`; do
		cat <<EOF
# upload
hdfs dfs -put ${SRCDIR10}/${f} ${HDFSDIR}/netflow_work_${f} 2>&1
# import-refresh
impala-shell ${IMPALA_ARGS} -d ${DBNAME}_impala -q 'REFRESH flowdata' 2>&1
EOF
	done

	for i in 1 2 3; do
		for q in `ls -1 ./queries/*.sql | sort`; do
			name=`basename ${q} .sql`
			cat <<EOF
# ${name}
impala-shell ${IMPALA_ARGS} -d ${DBNAME}_impala -f ${q} 2>&1
EOF
		done
	done
cat <<EOF
# destroy
impala-shell ${IMPALA_ARGS} -d ${DBNAME}_impala -f ${TMPDIR}/text-destroy.sql 2>&1
# remove
hdfs dfs -rm ${HDFSDIR}/netflow_work_\*
EOF
done

