#! /bin/bash

current_dir=$PWD
output_dir=data
mkdir -p ${output_dir}


out_file=stab_comp_data.tsv
echo -e "sample\tinterm\tderived" > ${out_file}

for i in {1..200}; 
do 
	int_file=stability-last-n2-sample-${i}.csv
	der_file=stability-n3-sample-${i}.csv
	paste <(echo "${i}") <(tail -2 ${int_file} | head -1 | cut -d',' -f2) <(tail -1 ${der_file} | cut -d',' -f2) >> ${out_file}	
done

