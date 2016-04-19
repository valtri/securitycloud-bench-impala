#! /bin/sh -e

. ./common.sh

# imports
for i in `seq 1 ${N}`; do
	cat <<EOF
# dbinit
impala-shell ${IMPALA_ARGS} -q "INVALIDATE METADATA; CREATE DATABASE ${DBNAME}_impala; INVALIDATE METADATA;" 2>&1
# create
impala-shell ${IMPALA_ARGS} -d ${DBNAME}_impala -f ${TMPDIR}/bin-init.sql 2>&1
EOF
	for f in `cd ${SRCDIR10}/; ls -1 | sort`; do
		cat <<EOF
# upload
hdfs dfs -put ${SRCDIR10}/${f} ${HDFSDIR}/netflow_work_${f} 2>&1
# import
impala-shell ${IMPALA_ARGS} -d ${DBNAME}_impala -q 'REFRESH flowdata_ext; INSERT INTO flowdata SELECT * FROM flowdata_ext' 2>&1
# remove
hdfs dfs -rm ${HDFSDIR}/netflow_work\* 2>&1
EOF
	done

	if test ${i} -lt ${N}; then
		cat <<EOF
# destroy
impala-shell ${IMPALA_ARGS} -q "DROP DATABASE ${DBNAME}_impala CASCADE; INVALIDATE METADATA;" 2>&1
# sleep
sleep 10
EOF
	fi
done

# queries
for i in `seq 1 ${N}`; do
	for q in `ls -1 ./queries/*.sql | sort`; do
		name=`basename ${q} .sql`
		cat <<EOF
# ${name}
impala-shell ${IMPALA_ARGS} -d ${DBNAME}_impala -f ${q} 2>&1
EOF
	done
done
