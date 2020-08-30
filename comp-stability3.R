#! /usr/bin/Rscript


library("Cairo");

pardir <- ".";
outdir <- ".";
sampleSize <- 200;

filepath <- sprintf("%s/bistable-count-FP-%i-2.csv", pardir, sampleSize );
bistab.dat <-  read.csv(filepath, row.names=1);

filepath <- sprintf("%s/stab_comp_data.tsv", pardir, sampleSize );
stab.dat <-  read.delim(filepath);

xx <- stab.dat$interm;
yy <- stab.dat$derived - (xx-xx);



xx <- stab.dat$interm;
yy <- stab.dat$derived - (xx-xx);

# xx[!flag] <- NA;
# yy[!flag] <- NA;

bistab.flag <- (bistab.dat[3,] >= 1);
monostab.xx <- xx[!bistab.flag];
monostab.yy <- yy[!bistab.flag];
bistab.xx <- xx[bistab.flag];
bistab.yy <- yy[bistab.flag];

  
Cairo(file =sprintf("%s/comp-stab-n2-n3-with-reg-line.svg",outdir),type="svg",width = 15, height = 15, units="cm");  

plot(x=c(0,100),y=c(0,100), xlim=c(3.0, 12), ylim=c(3.0, 12), cex.lab=1.5, cex.axis=1.5, type="l", ylab="stability of derived population", xlab="stability of intermediate population");
shape.p <- 0;
color.p <- "black";
colors <- c("darkgreen", "darkolivegreen3");
shapes <- c(0, 1) ;
c <- 0;

abline(lm(monostab.yy ~ monostab.xx + 0), lty=2, col=colors[1], lwd=2);
abline(lm(bistab.yy ~ bistab.xx + 0), lty=2, col=colors[2], lwd=2);
# abline(v=c(15,20), col=c("blue", "red"), lty=c(1,2), lwd=c(1, 3))
shape.p <- shapes[2];
for( i in 1:length(xx)) {
  if( is.na(xx[i])) {
    next;
  }
  c <- c + 1;
  if( bistab.dat[3,i] >= 1 ) {
    color.p <- colors[2];      
#     color.p <- "red";      
  } else {
    #    next;
    color.p <- colors[1];      
  }
  points( x=xx[i], y=yy[i], pch=shape.p, col=color.p, cex=1.3, lwd=2);
}

# for( i in 1:length(xx)) {
#   if( is.na(xx[i])) {
#     next;
#   }
#   c <- c + 1;
#   if( bistab.dat[2,i] >= 1 ) {
#     color.p <- colors[1];      
#   } else {
# #    next;
#     color.p <- colors[2];      
#   }
#   if( bistab.dat[3,i] >= 1 ) {
#     shape.p <- shapes[2];
#   } else {
#     shape.p <- shapes[1];
#   }
#   points( x=xx[i], y=yy[i], pch=shape.p, col=color.p, cex=1.8, lwd=3);
# }
dev.off();  

lm(monostab.yy ~ monostab.xx + 0);
# slope = 1.183
#
lm(bistab.yy ~ bistab.xx + 0);
# slope = 1.453
