#! /bin/sh -e

. ./common.sh

cat <<EOF
# upload
hdfs dfs -put ${SRCFILE} ${HDFSDIR}/netflow_work 2>&1
# import
impala-shell ${IMPALA_ARGS} -d ${DBNAME}_impala -f ${TMPDIR}/bin-init.sql 2>&1
EOF

for i in `seq 1 ${N}`; do
	for q in `ls -1 ./queries/*.sql | sort`; do
		name=`basename ${q} .sql`
		cat <<EOF
# ${name}
impala-shell ${IMPALA_ARGS} -d ${DBNAME}_impala -f ${q} 2>&1
EOF
	done
done
