#DATA=big
test -n "${DATA}" || DATA='small'
FILE="netflow_csv_anon_${DATA}"

DBNAME="`id -un`_sc_bench"
BEELINE_ARGS="-u \"jdbc:hive2://hador-c1.ics.muni.cz:10000/${DBNAME}_hive;principal=hive/hador-c1.ics.muni.cz@ICS.MUNI.CZ\""
HIVE_ARGS=''
IMPALA_ARGS="-B -i hador`seq 1 24 | shuf -n 1`.ics.muni.cz"
test -n "${N}" || N=5

HDFSDIR="/user/`id -un`/sc-benchmark"
QDIR="`dirname $0`/queries"; QDIR="`readlink -f \"${QDIR}\"`"
SRCFILE="/scratch/`id -un`/sc-hadoop-src/${FILE}"
SRCDIR2="/scratch/`id -un`/sc-hadoop-src/${DATA}2"
SRCDIR10="/scratch/`id -un`/sc-hadoop-src/${DATA}10"
TMPDIR="/tmp/`id -un`/sc-bench"
