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
xx <- seq(0,400,delta);
xx.H <- seq(100,400,delta);


f1 <- dnorm(xx, mean=200, sd=80);
f2 <- dnorm(xx, mean=200, sd=50);
w <- sapply(xx, fitness);

m1 <- sum( f1 * w) * delta;
m2 <- sum( f2 * w) * delta;

Cairo(file =sprintf("%s/fitness-vs-width-monostable-m-200.svg",outdir),type="svg",width = 15, height = 15, units="cm");  
plot( x=xx, y=w, type="l", col="black", lwd=8, xlim=c(0,400), ylim=c(0,1), yaxt="n", xlab="X", ylab="", cex.lab=1.5, cex.axis=1.5);
# Axis(side=2, labels=FALSE);
lines( x=xx, y=f1*80, col="blue", lwd=8, xlim=c(0,400), ylim=c(0,0.01));
lines( x=xx, y=f2*80, col="red", lwd=8, xlim=c(0,400), ylim=c(0,0.01));
points(x=200, y=m1, pch=15, cex=2, col="blue");
points(x=200, y=m2, pch=16, cex=2, col="red");
dev.off();

