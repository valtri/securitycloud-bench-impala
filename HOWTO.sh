#! /bin/sh

# once:
../benchmarking/run.pl

# repeat:
for i in `seq 1 5`; do rm -rf result${i}; done
for i in `seq 1 5`; do ../benchmarking/run.pl -o result${i}; done
