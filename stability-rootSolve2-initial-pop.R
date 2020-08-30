#! /usr/bin/Rscript

library("rootSolve")

args <- commandArgs(TRUE);
sample.id <- args[1];

findPeak <- function(a, b, kd, n ) {
  kdeg <- 0.002;
  kb <- 0.02;
  ka <- 0.2;

  fun <- function(x) {
    m1 <- b;
    m2 <- 2*b^2 + b; 
    Kd <- kd;
    
    p <- (x/Kd)^n;
    AA <- 2*(a*m1*(kb + ka*p)/(1+p) - kdeg*x);
    Dprime <- (a*ka*m2*n*p)/(x*(p+1))-(a*m2*n*p*(kb+ka*p))/(x*(1+p)^2)+kdeg;
    AA - Dprime;
  }
  
  xss <- uniroot.all(fun, c(0, 1000));
  x.max <- max(xss);
  if( x.max < 50 ) {
    NA;
  } else {
    x.max;
  }  
}

sGen <- function(a, b, kd, n ) {
  kdeg <- 0.002;
  kb <- 0.02;
  ka <- 0.2;
  m2 <- 2*b^2 + b;
  x.peak <- findPeak(a, b, kd, n );
  
  sfun <- function( x ) {
    aprime <- (a*b*ka*n*(x/kd)^n)/(x*((x/kd)^n+1))-(a*b*n*(x/kd)^n*(kb+ka*(x/kd)^n))/(x*(1+(x/kd)^n)^2)-kdeg;
    dprimeprime <- (a*ka*m2*n^2*(x/kd)^n)/(x^2*((x/kd)^n+1))-(a*ka*m2*n*(x/kd)^n)/(x^2*((x/kd)^n+1))-(2*a*ka*m2*n^2*(x/kd)^(2*n))/(x^2*(1+(x/kd)^n)^2)-(a*m2*n^2*(x/kd)^n*(kb+ka*(x/kd)^n))/(x^2*(1+(x/kd)^n)^2)+(a*m2*n*(x/kd)^n*(kb+ka*(x/kd)^n))/(x^2*(1+(x/kd)^n)^2)+(2*a*m2*n^2*(x/kd)^(2*n)*(kb+ka*(x/kd)^n))/(x^2*(1+(x/kd)^n)^3);
    bprime <- abs(2*aprime - dprimeprime); 
    d <- m2 * a * (kb + ka * (x/kd)^n)/(1 + (x/kd)^n) + kdeg * x;
    s <- sqrt(d / bprime);  
  }
  if( is.na(x.peak)  ) {
    NA;
  }
  else {
    x.peak / sfun(x.peak);
  }
}


computeStability <- function( params ) {
  Kd <- params[2];
  b <- params[3];
  n <- params[4]
  a <- params[5];

  sGen( a, b, Kd, n );
}




s <- computeStability( c(NA, 50, 1, 0, 1));

pardir <- ".";
outdir <- ".";

r <- data.frame( generation=c(0), stability=c(s));   
write.csv( r, file=sprintf("%s/stability-initial.csv", outdir ), row.names=FALSE, quote = F );

