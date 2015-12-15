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

SQL_DESTROY_TEXT="DROP TABLE flowdata;"

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

INSERT INTO flowdata
  SELECT * FROM flowdata_ext;

REFRESH flowdata;
"

SQL_DESTROY_PARQUET="DROP TABLE flowdata;
DROP TABLE flowdata_ext;
"

hdfs_init() {
	hdfs dfs -mkdir -p ${HDFSDIR} 2>/dev/null || :
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
