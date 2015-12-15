#! /bin/sh

# once:
../benchmarking/run.pl 2>&1 | tee log

# repeat:
for i in `seq 1 5`; do rm -rf result${i}; done
for i in `seq 1 5`; do ../benchmarking/run.pl -o result${i} 2>&1 | tee ${i}.log; done
