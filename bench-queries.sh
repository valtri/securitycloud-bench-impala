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

for DATA in 1 half big; do
  if [ x"$DATA" = x"1" ]; then
    benchmarks=impala-text,impala-parquet
  else
    benchmarks=impala-text,impala-seq-text,impala-parquet,impala-seq-parquet
  fi
  rm -rf ${DATA}.log
  DATA=${DATA} ../benchmarking/run.pl -o result-query.${DATA} -s ${benchmarks} 2>&1 | tee ${DATA}.log
  PREFIX="query-${DATA}" ../benchmarking/averager.pl result-query.${DATA}
done
