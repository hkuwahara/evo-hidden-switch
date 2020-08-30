#! /usr/bin/Rscript

kdeg <- 0.002;
kb <- 0.02;
ka <- 0.2;

genA <- function(params) {
  Kd <- as.numeric(params[2]);
  b <- as.numeric(params[3]);
  n <- as.numeric(params[4]);
  a <- as.numeric(params[5]);
  m1 <- b;
  
  function(x) {
    p <- (x/Kd)^n;    
    a*m1*(kb + ka*p)/(1+p) - kdeg*x;
  }  
}

genD <- function(params) {
  Kd <- as.numeric(params[2]);
  b <- as.numeric(params[3]);
  n <- as.numeric(params[4]);
  a <- as.numeric(params[5]);
  m2 <- 2*b^2 + b;

  function(x) {
    p <- (x/Kd)^n;    
    a*m2*(kb + ka*p)/(1+p) + kdeg*x;
  }  
}

library("Cairo");
textscale <- 1.0;
pointsize <- 1.5;
dx <- 0.1;
x <- seq(0,300,dx);

pardir <- ".";
outdir <- ".";

###
# i is 141 for a bistable example.
# i is 64 for a monostable example.
##
i <- 141;
sys.type <- "bistable";
# i <- 64;
# sys.type <- "monostable";

filepath <- sprintf("%s/from-100000-to-20-p-1000-%i/f-20-n-2-gen-29900-env-1.csv", pardir, i );
dat <-  read.csv(filepath);
k <- which.max(dat[,7]);
param.2 <- dat[k,];
# done <- F;
# while(!done) {
#   k <- which.max(dat[,7]);
#   param.2 <- dat[k,];
#   if( param.2[1] < 1 ) {
#     dat[k,6] <- 0;
#   } else {
#     done <- T;
#   }
# }
# k <- 1;
fA <- genA(param.2);
fD <- genD(param.2);
A <- sapply(x,fA);
D <- sapply(x,fD);
  
t <- (A+A) / D * dx;
cumm2 <- cumsum(t);
freq <- exp( cumm2*dx ) / D;
prob2 <- freq / sum(freq);
dev.new();
plot( x, -cumm2, type="l", lwd=12, xlab="",ylab="", xlim=c(0,300),ylim=c(-25,50),cex.axis=1.8);
# plot( x, -cumm2, type="l", lwd=12, xlab="",ylab="", xlim=c(0,300),ylim=c(-60,50),cex.axis=1.8);
dev.off();

Cairo(file =sprintf("%s/%s-interm-example-%i.svg",pardir, sys.type, i), type="svg", width= 10, height= 10, units="cm");
plot( x, -cumm2, type="l", lwd=12, xlab="",ylab="", xlim=c(0,300),ylim=c(-25,50),cex.axis=1.8);
# plot( x, -cumm2, type="l", lwd=12, xlab="",ylab="", xlim=c(0,300),ylim=c(-60,50),cex.axis=1.8);
dev.off();

filepath <- sprintf("%s/from-100000-to-20-p-1000-%i/f-100000-n-3-gen-30000-env-1.csv", pardir, i );
dat <-  read.csv(filepath);
k <- which.max(dat[,7]);
param.3 <- dat[k,];

fA <- genA(param.3);
fD <- genD(param.3);
A <- sapply(x,fA);
D <- sapply(x,fD);

t <- (A+A) / D * dx;
cumm3 <- cumsum(t);
freq <- exp( cumm3*dx ) / D;
prob3 <- freq / sum(freq);
# plot( x, prob );

dev.new();
plot( x, -cumm3, type="l", lwd=12, xlab="",ylab="", xlim=c(0,300),ylim=c(-30,20),cex.axis=1.8);
# plot( x, -cumm3, type="l", lwd=12, xlab="",ylab="", xlim=c(0,300),ylim=c(-70,5),cex.axis=1.8);
dev.off();

Cairo(file =sprintf("%s/%s-derived-example-%i.svg",pardir, sys.type, i), type="svg", width= 10, height= 10, units="cm");
plot( x, -cumm3, type="l", lwd=12, xlab="",ylab="", xlim=c(0,300),ylim=c(-30,20),cex.axis=1.8);
# plot( x, -cumm3, type="l", lwd=12, xlab="",ylab="", xlim=c(0,300),ylim=c(-70,5),cex.axis=1.8);
dev.off();

