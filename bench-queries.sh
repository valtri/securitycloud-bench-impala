#! /bin/sh -xe

#
# 1) get benchmark framework (as parent directory, not a subdirectory)
#
#   git clone https://github.com/valtri/benchmarking ../benchmarking
#
# 2) create proper settings.sh file
#
# 3) store the sample file into $SRCFILE
#
# 4) launch splitter.sh (for "seq" benchmarks)
#


# custom parameters
#rm -rf results/; N=2 FILE="netflow_csv_anon_1" ../benchmarking/run.pl -s impala-text

for DATA in anon_1 anon anon_big; do
  rm -rf results/${DATA}.log
  DATA=${DATA}../benchmarking/run.pl -o result-query.${DATA} -s hive,impala-text,impala-parquet 2>&1 | tee ${DATA}.log
  PREFIX="query-${DATE}" ../benchmarking/averager.pl result-query.${DATA}
done

DATA=small
../benchmarking/run.pl -o result-seq.${DATA} -s impala-seq-text  2>&1 | tee seq-${DATA}.log
