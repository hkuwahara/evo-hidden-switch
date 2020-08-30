#! /usr/bin/Rscript
library("rootSolve")


isBistable <- function( params ) {
  k0 <- 0.02;
  k1 <- 0.2;
  kdeg <- 0.002;
  kd <- as.numeric(params[2]);
  b <- as.numeric(params[3]);
  n <- as.numeric(params[4]);
  a <- as.numeric(params[5]);
  
  if( (1/kd)^n > 1e4 ) {
    return(0);
  }
  
  fun <- function(x) {
    m1 <- b;
    m2 <- 2*b^2 + b; 
    Kd <- kd;
    kb <- k0;
    ka <- k1;
    
    p <- (x/Kd)^n;
    AA <- 2*(a*m1*(kb + ka*p)/(1+p) - kdeg*x);
    Dprime <- (a*ka*m2*n*p)/(x*(p+1))-(a*m2*n*p*(kb+ka*p))/(x*(1+p)^2)+kdeg;
    AA - Dprime;
  }
  
  xss <- uniroot.all(fun, c(0, 1000));
  if( length(xss) <= 1) {
    return(0);  
  }
  if( length(xss) == 2) {
    if( xss[2] < 50 ) {
      return(0);
    }else {
      return(1);
    }
  }
  if( xss[3] > 50 && xss[1] < 50 ) {
    return(1);
  }else {
    return(0);
  }
}  

countBistable <- function( filepath ) {
  dat <-  read.csv(filepath);
  m <- as.matrix(dat);
  len <- length(m[,1]);
  x <- apply( m, 1, isBistable );
  sum(x);
}

#freq <- 20;
pardir <- ".";
outdir <- ".";
popSize <- 1000;
sampleSize <- 200;
colNames <- sprintf("sample-%i", 1:sampleSize);
rowNames <- c( "ancestor","intermediate", "descendant");
dat <- matrix(data=NA,ncol=sampleSize,nrow=3);

for( j in 1:sampleSize ) {
  filepath <- sprintf("%s/from-100000-to-20-p-1000-%i/f-100000-n-1-gen-30000-env-1.csv", pardir, j );
  dat[1,j] <- countBistable(filepath); 
  
  filepath <- sprintf("%s/from-100000-to-20-p-1000-%i/f-20-n-2-gen-30000-env-0.csv", pardir, j );
  dat[2,j] <- countBistable(filepath); 
  
  filepath <- sprintf("%s/from-100000-to-20-p-1000-%i/f-100000-n-3-gen-30000-env-1.csv", pardir, j );
  dat[3,j] <- countBistable(filepath);   
}

rec <- as.data.frame(dat);  
names(rec) <- colNames;
rownames(rec) <- rowNames;
write.csv( rec, file=sprintf("%s/bistable-count-FP-%i-2.csv", outdir, sampleSize ), row.names=T );




