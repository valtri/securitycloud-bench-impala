#! /bin/sh -e

. ./common.sh

cat <<EOF
# import
hive --database ${DBNAME}_hive ${HIVE_ARGS} -f ${TMPDIR}/hive-init.sql 2>&1
EOF

for i in `seq 1 ${N}`; do
	for q in `ls -1 ./queries/*.sql | sort`; do
		name=`basename ${q} .sql`
		cat <<EOF
# ${name}
hive --database ${DBNAME}_hive ${HIVE_ARGS} -f ${q} 2>&1
EOF
	done
done
