#! /bin/sh -e

. ./common.sh

cat <<EOF
# upload
hdfs dfs -put ${SRCFILE} ${HDFSDIR}/netflow_work
# import
impala-shell ${IMPALA_ARGS} -f ${TMPDIR}/text-init.sql
EOF
for q in `ls -1 ./queries/*.sql | sort`; do
	name=`basename ${q} .sql`
	cat <<EOF
# ${name}
impala-shell ${IMPALA_ARGS} -f ${q}
EOF
done
