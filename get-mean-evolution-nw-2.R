library("Cairo");

# nw <- 2;
sigmas <- c(30,50,80,120,150,170);
pTypes <- c(0,1,4,5,9,10);
cols <- c("blue4", "orangered4", "magenta4", "blue2", "orangered2", "magenta2");
#numRuns <- 100;
numRuns <- 20;
genNum <- 2000;
gens <- seq(100,2000,100);

pardir <- ".";

# nws <- c(1, 5);
nws <- c(5);
for( nw in nws ) {
  Cairo(file =sprintf("%s/sigma-mean-evolution2-nw-%i.svg", pardir, nw), type="svg", width= 24, height= 12, units="cm");
  
  
  xx <- c(0,gens);
  plot(x=xx, y=rep(100,length(xx)), ylim=c(0,200), type="l", yaxt="n", lwd=4.0, col="red", ylab="", xlab="");
  axis(2, at=c(0,50,100,150,200),labels=c(0,50,100,50,0), las=2)
  
  
  p <- 1;
  for( sigma0 in sigmas ) {
    dir <- sprintf("%s/s-%g-g-%i-nw-%i", pardir, sigma0, genNum, nw);
    
    m <- matrix(NA, ncol=(length(gens)+1), nrow=numRuns);
    
    
    m[,1] <- sigma0;
    for( run in 1:numRuns ) {
      for( j in 1:length(gens) ) {
        gen <- gens[j];
        inputdir <- sprintf("%s/run-%i/gen-%i.csv", dir, run, gen);
        dat <- read.csv( file=inputdir, header=T, row.names=1 );
        m[run,j+1] <- mean(dat$sigma); 
      }
    }
    
    mean.s <- colMeans( m );
    sd.s <- apply(m, 2, sd);
    lines(x=xx, y=mean.s, lwd=3, col=cols[p]);
    points(xx, mean.s, cex=1,pch=pTypes[p]);
    arrows(xx,mean.s+sd.s, xx, mean.s-sd.s, angle=90, code=3, length=0.05);
    p <- p + 1;
  }
  
  dev.off();
}