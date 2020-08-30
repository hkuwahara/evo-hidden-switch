#! /bin/sh

Rscript ./evolution-sim2.R 30 20 2000 5 &
Rscript ./evolution-sim2.R 50 20 2000 5 &
Rscript ./evolution-sim2.R 80 20 2000 5 &
Rscript ./evolution-sim2.R 120 20 2000 5 &
Rscript ./evolution-sim2.R 150 20 2000 5 &
Rscript ./evolution-sim2.R 170 20 2000 5 &

wait

