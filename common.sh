#FILE='netflow_csv_anon_big'
FILE='netflow_csv_anon_small'

DBNAME="`id -un`_sc_bench"
BEELINE_ARGS="-u \"jdbc:hive2://hador-c1.ics.muni.cz:10000/${DBNAME}_hive;principal=hive/hador-c1.ics.muni.cz@ICS.MUNI.CZ\""
HIVE_ARGS="--database ${DBNAME}_hive"
IMPALA_ARGS="-i hador`seq 1 24 | shuf -n 1`.ics.muni.cz -d ${DBNAME}_impala"
N=5

HDFSDIR="/user/`id -un`/sc-benchmark"
QDIR="`dirname $0`/queries"; QDIR="`readlink -f \"${QDIR}\"`"
SRCFILE="/scratch/`id -un`/sc-hadoop-src/${FILE}"
TMPDIR="/tmp/`id -un`/sc-bench"

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
   in INT
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
   in INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '${HDFSDIR}/netflow_work';
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
   in INT
)
STORED AS parquet;

INSERT INTO flowdata
  SELECT * FROM flowdata_ext;
"

SQL_DESTROY_PARQUET="DROP TABLE flowdata;
DROP TABLE flowdata_ext;
"

hdfs_init() {
	hdfs dfs -mkdir ${HDFSDIR}/ 2>/dev/null || :
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
