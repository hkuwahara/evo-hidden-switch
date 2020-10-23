#! /usr/bin/Rscript
library("dplyr");
library("data.table");
library("reshape2");
library("ggplot2");
library("scales");
library("ggsci");
library("gridExtra");
library("ggpubr");
library("cvms");

mypal = pal_npg("nrc", alpha = 1.0)(9);
show_col(mypal);

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

textscale <- 1.0;
pointsize <- 1.5;

pardir <- "/home/hiro/research/kaust/change-env-fluctuation/revision/more-samples";
outdir <- "/home/hiro/research/kaust/change-env-fluctuation/revision/more-samples";

###
# i is 141 for a bistable example.
# i is 64 for a monostable example.
##
i <- 141;
sys.type <- "bistable";
# i <- 64;
# sys.type <- "monostable";


gen.dat <- function( i ) {
  dx <- 0.1;
  x <- seq(0,250,dx);
  filepath <- sprintf("%s/from-100000-to-20-p-1000-%i/f-20-n-2-gen-29900-env-1.csv", pardir, i );
  dat <-  read.csv(filepath);
  k <- which.max(dat[,7]);
  param.2 <- dat[k,];
  fA <- genA(param.2);
  fD <- genD(param.2);
  A <- sapply(x,fA);
  D <- sapply(x,fD);
  
  t <- (A+A) / D * dx;
  cumm2 <- cumsum(t);
  rec <- data.frame( x=x, y=-cumm2, phase=rep("intermediate", length(x)) );
  
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
  rec <- rbind( rec, data.frame( x=x, y=-cumm3, phase=rep("derived", length(x)) ) );
  rec;
}

plot.dat <- function(dat, run.id, show.legend ) {
  # plt.colors <- c("#71c837", "#0066ff");
  plt.colors <- c( mypal[3], mypal[2]);
  plt <- ggplot(data = dat, aes(x=x, y=y, group=phase, color=phase ));
  plt <- plt + geom_line(size=2);
  plt <- plt + scale_color_manual(values=plt.colors);
  plt <- plt + ylab("potential energy");
  plt <- plt + xlab("X");
  plt <- plt + annotate(geom = 'text', label = paste0("run ", run.id ), x = Inf, y = -Inf, hjust = 1, vjust = 0, size = 10);
  plt <- plt + theme_minimal();
  if( show.legend ) {
    plt <- plt + theme(
      legend.position = c(0.25, 0.83),
      legend.box.background = element_rect(colour = "black"),
      # panel.background = element_rect(fill = "whitesmoke", colour = "black"),
      panel.background = element_rect(fill = "white", colour = "black"),
      axis.text.x = element_text(size = 18),
      axis.title.x = element_text(size = 20),
      axis.text.y = element_text(size = 18),
      axis.title.y = element_text(size = 20),
      legend.title =element_blank(),
      legend.text = element_text(size = 18));
  } else {
    plt <- plt + theme(
      legend.position = "none",
      legend.box.background = element_rect(colour = "black"),
      # panel.background = element_rect(fill = "whitesmoke", colour = "black"),
      panel.background = element_rect(fill = "white", colour = "black"),
      axis.text.x = element_text(size = 18),
      axis.title.x = element_text(size = 20),
      axis.text.y = element_text(size = 18),
      axis.title.y = element_text(size = 20),
      legend.title =element_blank(),
      legend.text = element_blank());
  }
  plt;
}


bi.run <- 141;
bi.dat <- gen.dat( bi.run );
bi.plt <- plot.dat( bi.dat, bi.run, T );

mono.run <- 64;
mono.dat <- gen.dat( mono.run );
mono.plt <- plot.dat( mono.dat, mono.run, F );

plt <- ggarrange(bi.plt, mono.plt,
                 ncol = 1, nrow = 2 );
print(plt);
ggsave(filename=paste(outdir, "potential_plot.svg", sep="/"), device="svg", plot=plt, width=13, height= 16, units="cm");

