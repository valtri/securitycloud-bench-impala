#DATA=big
test -n "${DATA}" || DATA='small'
FILE="netflow_csv_anon_${DATA}"

DBNAME="`id -un`_sc_bench"
HIVE_ARGS=''
test -n "${N}" || N=5
BEELINE_ARGS="-u \"jdbc:hive2://hador-c2-1.ics.muni.cz:10000/${DBNAME}_hive\""
IMPALA_ARGS="-B -i hador`seq 1 24 | shuf -n 1`-1.ics.muni.cz"

HDFSDIR="/user/`id -un`/sc-benchmark"
QDIR="`dirname $0`/queries"; QDIR="`readlink -f \"${QDIR}\"`"
SRCFILE="/scratch/`id -un`/sc-hadoop-src/${FILE}"
SRCDIR2="/scratch/`id -un`/sc-hadoop-src/${DATA}2"
SRCDIR10="/scratch/`id -un`/sc-hadoop-src/${DATA}10"
TMPDIR="/tmp/`id -un`/sc-bench"
