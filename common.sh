. ./settings.sh

SQL_INIT_HIVE="DROP TABLE IF EXISTS flowdata;

CREATE EXTERNAL TABLE flowdata
(
   ts TIMESTAMP,
   te TIMESTAMP,
   td DOUBLE,
   sa STRING,
   da STRING,
   sp SMALLINT,
   dp SMALLINT,
   pr STRING,
   flg STRING,
   ipkt INT,
   ibyt INT,
   inum INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

LOAD DATA LOCAL INPATH '${SRCFILE}' OVERWRITE INTO TABLE flowdata;
"

SQL_DESTORY_HIVE="DROP TABLE flowdata;"

# refresh command needed: to let other server know
SQL_INIT_TEXT="DROP TABLE IF EXISTS flowdata;

CREATE EXTERNAL TABLE flowdata
(
   ts TIMESTAMP,
   te TIMESTAMP,
   td DOUBLE,
   sa STRING,
   da STRING,
   sp SMALLINT,
   dp SMALLINT,
   pr STRING,
   flg STRING,
   ipkt INT,
   ibyt INT,
   inum INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '${HDFSDIR}';

REFRESH flowdata;
"

SQL_DESTROY_TEXT="DROP TABLE flowdata PURGE;
INVALIDATE METADATA;
"

# refresh command needed: to let other server know
SQL_INIT_PARQUET="DROP TABLE IF EXISTS flowdata;

CREATE EXTERNAL TABLE flowdata
(
   ts TIMESTAMP,
   te TIMESTAMP,
   td DOUBLE,
   sa STRING,
   da STRING,
   sp SMALLINT,
   dp SMALLINT,
   pr STRING,
   flg STRING,
   ipkt INT,
   ibyt INT,
   inum INT
)
STORED AS parquet;

REFRESH flowdata;
"

# purge needed, otherwise ressurrection will keep old data
# (since CDH 5.5/Impala 2.3)
SQL_DESTROY_PARQUET="DROP TABLE flowdata PURGE;
DROP TABLE flowdata_ext PURGE;
INVALIDATE METADATA;
"

hdfs_init() {
	hdfs dfs -mkdir -p ${HDFSDIR} 2>/dev/null || :
	hdfs dfs -rm ${HDFSDIR}/netflow_work\* >/dev/null 2>&1 || :
	# for Impala (expected it is in the group)
	hdfs dfs -chmod g+w ${HDFSDIR}/
}

# ==== Initializations ====
mkdir -p ${TMPDIR} 2>/dev/null || :

echo "${SQL_INIT_HIVE}" > ${TMPDIR}/hive-init.sql
echo "${SQL_DESTROY_HIVE}" > ${TMPDIR}/hive-destroy.sql

echo "${SQL_INIT_TEXT}" > ${TMPDIR}/text-init.sql
echo "${SQL_DESTROY_TEXT}" > ${TMPDIR}/text-destroy.sql

echo "${SQL_INIT_TEXT}" | sed 's/flowdata/flowdata_ext/g' > ${TMPDIR}/bin-init.sql
echo "${SQL_INIT_PARQUET}" >> ${TMPDIR}/bin-init.sql
echo "${SQL_DESTROY_PARQUET}" > ${TMPDIR}/bin-destroy.sql
