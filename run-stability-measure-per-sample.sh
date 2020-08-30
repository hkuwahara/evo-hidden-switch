#! /bin/bash

Rscript --vanilla ./stability-rootSolve2-initial-pop.R
parallel -a <(seq 1 200) Rscript --vanilla ./stability-rootSolve2-per-sample.R {}

