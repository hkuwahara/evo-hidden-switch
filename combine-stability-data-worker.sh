#! /bin/bash

sample_id=$1
temp_dir=$2

cat <(echo "sample_${sample_id}") <(tail -1 stability-initial.csv | cut -d',' -f2)  <(tail -n +2 stability-n1-sample-${sample_id}.csv | cut -d',' -f2) > ${temp_dir}/stability-n1-sample-${sample_id}.tmp
cat <(echo "sample_${sample_id}") <(tail -1 stability-last-n2-sample-${sample_id}.csv | cut -d',' -f2)  <(tail -n +2 stability-n3-sample-${sample_id}.csv | cut -d',' -f2) > ${temp_dir}/stability-n3-sample-${sample_id}.tmp


