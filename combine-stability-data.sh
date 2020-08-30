#! /bin/bash

./run-stability-measure-per-sample.sh
./run-stability-measure-per-sample-n2.sh

temp_dir=temp
mkdir -p ${temp_dir}

cat <(echo "generation") <(echo "0") <(tail -n +2 stability-n1-sample-1.csv | cut -d',' -f1) > ${temp_dir}/stability-n1-gen.tsv
cat <(echo "generation") <(echo "0")  <(tail -n +2 stability-n1-sample-3.csv | cut -d',' -f1) > ${temp_dir}/stability-n3-gen.tsv
 
parallel -a <(seq 1 200) ./combine-stability-data-worker.sh {} ${temp_dir}

paste ${temp_dir}/stability-n1-gen.tsv ${temp_dir}/stability-n1-sample-*.tmp > stability-n1.tsv
paste ${temp_dir}/stability-n3-gen.tsv ${temp_dir}/stability-n3-sample-*.tmp > stability-n3.tsv

rm -rf ${temp_dir}

