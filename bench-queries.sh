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

# custom parameters
#rm -rf results/; N=2 FILE="netflow_csv_anon_1" ../benchmarking/run.pl -s impala-text

for f in anon_1 anon anon_big; do
  rm -rf results/${f}.log
  FILE="netflow_csv_${f}" ../benchmarking/run.pl -o result-query.${f} -s hive,impala-text,impala-parquet 2>&1 | tee ${f}.log
  PREFIX="query-${f}" ../benchmarking/averager.pl result-query.${f}
done