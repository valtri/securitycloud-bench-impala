#! /bin/sh -xe

for f in small half big; do
	n=`wc -l netflow_csv_anon_${f} | cut -f1 -d' '`
	for d in 2 10; do
		n2=`expr \( $n + ${d} / 2 \) / ${d}`
		rm -rf ${f}${d}
		mkdir ${f}${d}
		split -l ${n2} -d netflow_csv_anon_${f} ${f}${d}/
	done
done
