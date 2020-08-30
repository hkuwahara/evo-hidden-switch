#! /bin/bash

# this is the env switching rate.  0.1 means env changes every 10 gen.
f0=100000
f1=20
popSize=1000

parallel -a <(seq 1 200) perl ./run-samples.pl ${f0} {} ${f1} ${popSize}

