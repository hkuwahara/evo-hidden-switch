#! /bin/bash


parallel -a <(seq 1 200) Rscript --vanilla ./stability-rootSolve2-per-sample-n2.R {}

