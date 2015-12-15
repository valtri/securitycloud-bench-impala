#! /bin/sh -e

. ./common.sh

cat <<EOF
# import
hive ${HIVE_ARGS} -f ${TMPDIR}/hive-init.sql
EOF

for i in `seq 1 ${N}`; do
	for q in `ls -1 ./queries/*.sql | sort`; do
		name=`basename ${q} .sql`
		cat <<EOF
# ${name}
hive ${HIVE_ARGS} -f ${q}
EOF
	done
done
