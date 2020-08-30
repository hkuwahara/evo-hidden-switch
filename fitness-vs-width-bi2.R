library("Cairo");

outdir <- ".";

theta <- 100;
theta2 <- 300;
fitness <- function(x) {
  y1 <- (x/theta)^5;
  y2 <- (x/theta2)^8;  
  y1/(1+y1) - y2/(1+y2);
}
delta<- 0.1;
xx <- seq(0,600,delta);


w <- sapply(xx, fitness);
theta.index <- which(xx == theta);
max.index <- length(xx);

ss <- c(80, 50);
ff <- matrix( NA, nrow=length(ss), ncol=length(xx));
pp <- matrix( NA, nrow=length(ss), ncol=length(xx));

for( i in 1:length(ss)) {
  s <- ss[i];
  fH <- dnorm(xx, mean=200, sd=s);
  gL <- dnorm(xx, mean=0, sd=s);
  fL <- gL / (sum(gL)*delta);
  
  
  FL.from.theta <- sum( fL[theta.index:max.index] ) * delta;
  FH.from.theta <- sum( fH[theta.index:max.index] ) * delta;
  
  fL.w.all <- sum( fL * w ) * delta;
  fH.w.all <- sum( fH * w ) * delta;
  fL.w.from.theta <- sum( fL[theta.index:max.index] * w[theta.index:max.index] ) * delta;
  fH.w.from.theta <- sum( fH[theta.index:max.index] * w[theta.index:max.index] ) * delta;
  
  
  pH <- FH.from.theta;
  pL <- 1 - pH;
  
  old.pH <- pH;
  old.pL <- pL;
  for(j in 1:500){
    #selection 
    denom <- pL * fL.w.all + pH * fH.w.all;
    numer <- pL * fL.w.from.theta + pH * fH.w.from.theta;
    qH <- numer / denom;
    qL <- 1 - qH;
    
    #switching
    pH <- qL * FL.from.theta  + qH * FH.from.theta;
    pL <- 1 - pH;
    
    print( sprintf( "current = %g", pH) );
    if( abs( pH - old.pH) <= 0.001 ) {
      break;
    }  
  #   print( sprintf( "old=%g,  current=%g", old.pH, pH) );
    old.pH <- pH; 
    old.pL <- pL;
  }
  ff[i,] <- pL * fL + pH * fH;
  pp[i,] <- (1 - FH.from.theta) / (FL.from.theta + 1 - FH.from.theta) * fL + FL.from.theta / (FL.from.theta + 1 - FH.from.theta) * fH;
}


f1 <- pp[1,];
f2 <- pp[2,];
m1 <- sum( ff[1,] * w) * delta;
m2 <- sum( ff[2,] * w) * delta;


Cairo(file =sprintf("%s/fitness-vs-width-bistable-m-200-2.svg",outdir),type="svg",width = 15, height = 15, units="cm");  
plot( x=xx, y=w, type="l", col="black", lwd=8, xlim=c(0,400), ylim=c(0,1), yaxt="n", xlab="X", ylab="", cex.lab=1.5, cex.axis=1.5);
# Axis(side=2, labels=FALSE);
lines( x=xx, y=f1*80, col="blue", lwd=8, xlim=c(0,400), ylim=c(0,0.01));
lines( x=xx, y=f2*80, col="red", lwd=8, xlim=c(0,400), ylim=c(0,0.01));
points(x=200, y=m1, pch=15, cex=2, col="blue");
points(x=200, y=m2, pch=16, cex=2, col="red");
dev.off();

