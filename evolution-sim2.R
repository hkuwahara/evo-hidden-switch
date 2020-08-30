
pardir <- ".";

sigma.threshold <- 100;

args <- commandArgs(trailingOnly = TRUE);
if( length(args) >= 1 ) {
  sigma0 <- as.numeric(args[1]);
} else {
  sigma0 <- 80;
}
if( length(args) >= 2 ) {
  numRuns <- as.numeric(args[2]);
} else {
  numRuns <- 10;
}
if( length(args) >= 3 ) {
  genNum <- as.numeric(args[3]);
} else {
  genNum <- 1000;
}
if( length(args) >= 4 ) {
  nw <- as.numeric(args[4]);
} else {
  nw <- 5;
}



protein.threshold <- 100;
sigma.max <- 200;
level0 <- 150;
deltaS <- 2;
mean.high <- 200;
mean.low <- 0;
mu <- 0.01;
popSize <- 1000;
printGens <- seq(10,10000,10);

dir <- sprintf("%s/s-%g-g-%i-nw-%i", pardir, sigma0, genNum, nw);
if(!file.exists(dir)){
  dir.create(dir);
}

for( run in 1:numRuns ) {
  outdir <- sprintf("%s/run-%i", dir, run);
  if(!file.exists(outdir)){
    dir.create(outdir);
  }
  # xx <- seq(0,200, 0.1);
  # yy <- dnorm(xx, mean=0,sd=100);
  # 
  # plot(xx,yy,type='l');
  getFitness <- function(x) {
    y <- (x/protein.threshold)^nw;
    y/(1+y);
    z <- (x/300)^8;
    y/(1+y) - z/(1+z);
  }
  
  w <- getFitness(level0);
  
  level <- rep(level0,popSize);
  sigma <- rep(sigma0,popSize);
  fitness <- rep(w,popSize);
  bugs <- data.frame( level, sigma, fitness );
  
  for( j in 1:genNum ) {
    
    # mutation
    rr <- runif(popSize, 0, 1);
    for( i in 1:popSize ) {
      if( rr[i] <= mu ) {
        s <- bugs[i, "sigma"];
        s <- s + rnorm(1, 0, deltaS);
        if( s < 0 ) {
          s <- 0;  
        } else if( s > sigma.max ) {
          s <- sigma.max;
        }
        bugs[i, "sigma"] <- s;
      }
    }    
  
    # sampling
    rr <- rnorm(popSize, 0, 1);
    for( i in 1:popSize ) {
      s <- bugs[i, "sigma"];
      p <- bugs[i, "level"];
      ran <- rr[i];
      if(s < sigma.threshold) {
        if(p >= protein.threshold) {
          repeat {
            p <- mean.high + s * ran;
            if( p >= 0 ) {
              break;
            }
            ran <- rnorm(1, 0, 1);
          }
        } else {
          if( mean.low <= 0 ) {
            p <- abs(ran);
          } else {
            repeat {
              p <- mean.low + s * ran;    
              if( p >= 0 ) {
                break;
              }
              ran <- rnorm(1, 0, 1);
            }
          }
        }     
      } else {
        s2 <- sigma.max - s; 
        repeat {
          p <- mean.high + s2 * ran;
          if( p >= 0 ) {
            break;
          }
          ran <- rnorm(1, 0, 1);
        }
      }
      bugs[i, "level"] <- p;
    }    
    
    # replacement
    bugs$fitness <- sapply( bugs$level, getFitness);
    totalW <- sum(bugs$fitness); 
    cumm <- cumsum(bugs$fitness);
    rr <- runif(popSize, 0, totalW);
    newLevel <- rep(0,popSize);
    newSigma <- rep(0,popSize);  
    newFitness <- rep(0,popSize);  

    for( i in 1:popSize ) {
      threshold <- rr[i];
      k <- min(which(cumm >= threshold));
      newLevel[i] <- bugs[k, "level"];
      newSigma[i] <- bugs[k, "sigma"];
      newFitness[i] <- bugs[k, "fitness"];
    }
    bugs$level <- newLevel;
    bugs$sigma <- newSigma;
    bugs$fitness <- newFitness;
    
    # print  
    if( j %in% printGens ) {
      filepath <- sprintf("%s/gen-%i.csv", outdir, j);
      write.csv( bugs, filepath, quote=F);  
    }  
  }
}

