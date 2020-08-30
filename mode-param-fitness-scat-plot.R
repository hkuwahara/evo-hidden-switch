#! /usr/bin/Rscript


mcr <- function(x, drop = FALSE) { #'most common row' 
  xx <- do.call("paste", c(data.frame(x), sep = "\r")) 
  tx <- table(xx) 
  mx <- names(tx)[which(tx == max(tx))[1]] 
  x[match(mx, xx), , drop = drop] 
} 


library("Cairo");

pardir <- ".";
outdir <- ".";

sampleSize <- 200;
col.names <- c( "ancient","intermediate", "derived");
Kd.dat <- matrix(data=NA,nrow=sampleSize,ncol=3);
b.dat <- matrix(data=NA,nrow=sampleSize,ncol=3);
n.dat <- matrix(data=NA,nrow=sampleSize,ncol=3);
a.dat <- matrix(data=NA,nrow=sampleSize,ncol=3);

for( j in 1:sampleSize ) {
  filepath <- sprintf("%s/from-100000-to-20-p-1000-%i/f-100000-n-1-gen-30000-env-1.csv", pardir, j );
  dat <- read.csv(filepath, header=T); 
  t <- mcr(dat[,c(-1,-6,-7,-8)]);
  i <- 1;
  Kd.dat[j,i] <- as.numeric(t[1]);
  b.dat[j,i] <- as.numeric(t[2]);
  n.dat[j,i] <- as.numeric(t[3]);
  a.dat[j,i] <- as.numeric(t[4]);
  
  filepath <- sprintf("%s/from-100000-to-20-p-1000-%i/f-20-n-2-gen-29900-env-1.csv", pardir, j );
  dat <- read.csv(filepath, header=T); 
  t <- mcr(dat[,c(-1,-6,-7,-8)]);
  i <- 2;
  Kd.dat[j,i] <- as.numeric(t[1]);
  b.dat[j,i] <- as.numeric(t[2]);
  n.dat[j,i] <- as.numeric(t[3]);
  a.dat[j,i] <- as.numeric(t[4]);
  
  filepath <- sprintf("%s/from-100000-to-20-p-1000-%i/f-100000-n-3-gen-30000-env-1.csv", pardir, j );
  dat <- read.csv(filepath, header=T); 
  t <- mcr(dat[,c(-1,-6,-7,-8)]);
  i <- 3;
  Kd.dat[j,i] <- as.numeric(t[1]);
  b.dat[j,i] <- as.numeric(t[2]);
  n.dat[j,i] <- as.numeric(t[3]);
  a.dat[j,i] <- as.numeric(t[4]);
}


Cairo(file =sprintf("%s/mode-fitness-boxplot.svg",pardir), type="svg", width= 10, height= 32, units="cm");
par(mfcol=c(4,1), mar=c(4,5,0.5,0.2)+0.1, oma=c(0,0,0,0)+0.1, mgp=c(1.8,0.9,0));

boxplot( as.data.frame( a.dat ), las = 1, col=c("red", "darkgreen", "blue"), at = c(1,2,3), names = c("","",""), cex=1.8, cex.lab=2.5, cex.axis=2.0);

boxplot( as.data.frame( b.dat ), las = 1, col=c("red", "darkgreen", "blue"), at = c(1,2,3), names = c("","",""), cex=1.8, cex.lab=2.5, cex.axis=2.0);

boxplot( as.data.frame( Kd.dat ), las = 1, col=c("red", "darkgreen", "blue"), at = c(1,2,3), names = c("","",""), cex=1.8, cex.lab=2.5, cex.axis=2.0);

boxplot( as.data.frame( n.dat ), las = 1, col=c("red", "darkgreen", "blue"), at = c(1,2,3), names = c("ancestor","intermediate","derived"), cex=1.8, cex.lab=2.5, cex.axis=2.0);

dev.off();




param.names <- c("Kd", "b", "n", "a");

###
#  compare ancestor and derived 
###
# plot.range <- c( max(floor(min(Kd.dat[,1], Kd.dat[,3]) * 0.9), 0),  ceiling(max(Kd.dat[,1], Kd.dat[,3]) * 1.1));
plot.range <- c( max(floor(min(Kd.dat) * 0.9), 0),  ceiling(max(Kd.dat) * 1.1));
Cairo(file =sprintf("%s/mode-%s-1-3-scatter.svg",pardir, param.names[1]), type="svg", width= 11, height= 11, units="cm");
plot(x=plot.range, y=plot.range, type="l", col="grey50",xlim=plot.range, xlab=col.names[1], ylab=col.names[3], 
     ylim=plot.range, cex.lab=1.7, cex.axis=2.0);
points( x=Kd.dat[,1], y=Kd.dat[,3],pch=5,col="blue", main="", lwd=2, cex=1.2);
text( x=max(Kd.dat)*1.1, y=max(Kd.dat)*1.1, paste0("r = ", signif(cor(Kd.dat[,1], Kd.dat[,3]),3)), adj=1, cex=1.3);
dev.off();


# plot.range <- c( max(floor(min(b.dat[,1], b.dat[,3]) * 0.9), 0),  ceiling(max(b.dat[,1], b.dat[,3]) * 1.1));
plot.range <- c( max(floor(min(b.dat) * 0.9), 0),  ceiling(max(b.dat) * 1.1));
Cairo(file =sprintf("%s/mode-%s-1-3-scatter.svg",pardir, param.names[2]), type="svg", width= 11, height= 11, units="cm");
plot(x=plot.range, y=plot.range, type="l", col="grey50",xlim=plot.range, xlab=col.names[1], ylab=col.names[3], 
     ylim=plot.range, cex.lab=1.7, cex.axis=2.0);
points( x=b.dat[,1], y=b.dat[,3],pch=5,col="blue", main="", lwd=2, cex=1.2);
text( x=max(b.dat)*1.1, y=max(b.dat)*1.1, paste0("r = ", signif(cor(b.dat[,1], b.dat[,3]),3)), adj=1, cex=1.3);
dev.off();


# plot.range <- c( max(floor(min(n.dat[,1], n.dat[,3]) * 0.9), 0),  ceiling(max(n.dat[,1], n.dat[,3]) * 1.1));
plot.range <- c( max(floor(min(n.dat) * 0.9), 0),  ceiling(max(n.dat) * 1.1));
Cairo(file =sprintf("%s/mode-%s-1-3-scatter.svg",pardir, param.names[3]), type="svg", width= 11, height= 11, units="cm");
plot(x=plot.range, y=plot.range, type="l", col="grey50",xlim=plot.range, xlab=col.names[1], ylab=col.names[3], 
     ylim=plot.range, cex.lab=1.7, cex.axis=2.0);
points( x=n.dat[,1], y=n.dat[,3],pch=5,col="blue", main="", lwd=2, cex=1.2);
text( x=max(n.dat)*1.1, y=max(n.dat)*1.1, paste0("r = ", signif(cor(n.dat[,1], n.dat[,3]),3)), adj=1, cex=1.3);
dev.off();


# plot.range <- c( max(floor(min(a.dat[,1], a.dat[,3]) * 0.9), 0),  ceiling(max(a.dat[,1], a.dat[,3]) * 1.1));
plot.range <- c( max(floor(min(a.dat) * 0.9), 0),  ceiling(max(a.dat) * 1.1));
Cairo(file =sprintf("%s/mode-%s-1-3-scatter.svg",pardir, param.names[4]), type="svg", width= 11, height= 11, units="cm");
plot(x=plot.range, y=plot.range, type="l", col="grey50",xlim=plot.range, xlab=col.names[1], ylab=col.names[3], 
     ylim=plot.range, cex.lab=1.7, cex.axis=2.0);
points( x=a.dat[,1], y=a.dat[,3],pch=5,col="blue", main="", lwd=2, cex=1.2);
text( x=max(a.dat)*1.1, y=max(a.dat)*1.1, paste0("r = ", signif(cor(a.dat[,1], a.dat[,3]), 3)), adj=1, cex=1.3);
dev.off();


###
#  compare intermediate and derived 
###
# plot.range <- c( max(floor(min(Kd.dat[,2], Kd.dat[,3]) * 0.9), 0),  ceiling(max(Kd.dat[,2], Kd.dat[,3]) * 1.1));
plot.range <- c( max(floor(min(Kd.dat) * 0.9), 0),  ceiling(max(Kd.dat) * 1.1));
Cairo(file =sprintf("%s/mode-%s-2-3-scatter.svg",pardir, param.names[1]), type="svg", width= 11, height= 11, units="cm");
plot(x=plot.range, y=plot.range, type="l", col="grey50",xlim=plot.range, xlab=col.names[2], ylab=col.names[3], 
     ylim=plot.range, cex.lab=1.7, cex.axis=2.0);
points( x=Kd.dat[,2], y=Kd.dat[,3],pch=5,col="blue", main="", lwd=2, cex=1.2);
text( x=max(Kd.dat)*1.1, y=max(Kd.dat)*1.1, paste0("r = ", signif(cor(Kd.dat[,2], Kd.dat[,3]),3)), adj=1, cex=1.3);
dev.off();


# plot.range <- c( max(floor(min(b.dat[,2], b.dat[,3]) * 0.9), 0),  ceiling(max(b.dat[,2], b.dat[,3]) * 1.1));
plot.range <- c( max(floor(min(b.dat) * 0.9), 0),  ceiling(max(b.dat) * 1.1));
Cairo(file =sprintf("%s/mode-%s-2-3-scatter.svg",pardir, param.names[2]), type="svg", width= 11, height= 11, units="cm");
plot(x=plot.range, y=plot.range, type="l", col="grey50",xlim=plot.range, xlab=col.names[2], ylab=col.names[3], 
     ylim=plot.range, cex.lab=1.7, cex.axis=2.0);
points( x=b.dat[,2], y=b.dat[,3],pch=5,col="blue", main="", lwd=2, cex=1.2);
text( x=max(b.dat)*1.1, y=max(b.dat)*1.1, paste0("r = ", signif(cor(b.dat[,2], b.dat[,3]),3)), adj=1, cex=1.3);
dev.off();


# plot.range <- c( max(floor(min(n.dat[,2], n.dat[,3]) * 0.9), 0),  ceiling(max(n.dat[,2], n.dat[,3]) * 1.1));
plot.range <- c( max(floor(min(n.dat) * 0.9), 0),  ceiling(max(n.dat) * 1.1));
Cairo(file =sprintf("%s/mode-%s-2-3-scatter.svg",pardir, param.names[3]), type="svg", width= 11, height= 11, units="cm");
plot(x=plot.range, y=plot.range, type="l", col="grey50",xlim=plot.range, xlab=col.names[2], ylab=col.names[3], 
     ylim=plot.range, cex.lab=1.7, cex.axis=2.0);
points( x=n.dat[,2], y=n.dat[,3],pch=5,col="blue", main="", lwd=2, cex=1.2);
text( x=max(n.dat)*1.1, y=max(n.dat)*1.1, paste0("r = ", signif(cor(n.dat[,2], n.dat[,3]),3)), adj=1, cex=1.3);
dev.off();


# plot.range <- c( max(floor(min(a.dat[,2], a.dat[,3]) * 0.9), 0),  ceiling(max(a.dat[,2], a.dat[,3]) * 1.1));
plot.range <- c( max(floor(min(a.dat) * 0.9), 0),  ceiling(max(a.dat) * 1.1));
Cairo(file =sprintf("%s/mode-%s-2-3-scatter.svg",pardir, param.names[4]), type="svg", width= 11, height= 11, units="cm");
plot(x=plot.range, y=plot.range, type="l", col="grey50",xlim=plot.range, xlab=col.names[2], ylab=col.names[3], 
     ylim=plot.range, cex.lab=1.7, cex.axis=2.0);
points( x=a.dat[,2], y=a.dat[,3],pch=5,col="blue", main="", lwd=2, cex=1.2);
text( x=max(a.dat)*1.1, y=max(a.dat)*1.1, paste0("r = ", signif(cor(a.dat[,2], a.dat[,3]), 3)), adj=1, cex=1.3);
dev.off();


