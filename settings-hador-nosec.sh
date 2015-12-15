#FILE='netflow_csv_anon_big'
test -n "${FILE}" || FILE='netflow_csv_anon_small'

DBNAME="`id -un`_sc_bench"
HIVE_ARGS=''
test -n "${N}" || N=5
BEELINE_ARGS="-u \"jdbc:hive2://hador21-1.ics.muni.cz:10000/${DBNAME}_hive\""
IMPALA_ARGS="-B -i hador`seq 22 24 | shuf -n 1`-1.ics.muni.cz"

HDFSDIR="/user/`id -un`/sc-benchmark"
QDIR="`dirname $0`/queries"; QDIR="`readlink -f \"${QDIR}\"`"
SRCFILE="/scratch/`id -un`/sc-hadoop-src/${FILE}"
TMPDIR="/tmp/`id -un`/sc-bench"
