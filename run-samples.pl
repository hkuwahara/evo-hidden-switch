#! /bin/perl -w

$outdir = "";

$mu = 1e-2;
$initFreq = $ARGV[0];
$id = $ARGV[1];
$seed = $id * 10;
$endFreq = $ARGV[2];
$genNum = 10000;
$printInterval = 100;
#$printInterval = 1;
$popSize = $ARGV[3];

$outdir =  "mu-high-from-" . $initFreq . "-to-" . $endFreq . "-p-" . $popSize . "-" . $id;
$basalLevel = 0.10;
# basal reaction rate constant factor.  0.1 means basal rate is 10% of the activated rate. 
 
$thresholdFactor = 0.5;
# Kd / mean(A(infty))  The fraction of the steady state A level needed to achieve V_half.
  

$mutation = 0;
# mutation = 0 means mutate Kd, burst size, Hill-coefficient: N, transcription scaling factor. 
# mutation = 1 means mutate Kd
# mutation = 2 means mutate mean burst size
# mutation = 3 means mutate Hill-coefficient
# mutation = 4 means mutate transcription scaling factor

mkdir( $outdir );
print("simulating in $outdir\n");
system("./evo-sim/bin/noiseevol5 $mu $outdir $genNum $printInterval $initFreq $basalLevel $thresholdFactor $popSize $mutation $seed  $endFreq" ); 


