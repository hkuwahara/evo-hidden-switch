#! /usr/bin/Rscript

library("dplyr");
library("data.table");
library("reshape2");
library("ggplot2");
library("scales");
library("ggsci");
library("gridExtra");
library("ggpubr");

# args <- commandArgs(TRUE);
# data.dir <- args[1];
# sample.num <- as.numeric(args[2]);
# pop.size <- as.numeric(args[3]);

get.lower.tri<-function(mat){
  mat[upper.tri(mat)] <- NA;
  return(mat);
}
get.upper.tri <- function(mat){
  mat[lower.tri(mat)]<- NA;
  return(mat);
}

generate.heatmap <- function(melted.dat, show.legend=F) {
  melted.dat$prob <- round(melted.dat$value, 3);
  plt <- ggplot(melted.dat, aes(B, A, fill = value));
  plt <- plt + geom_tile(color = "white");
  plt <- plt + geom_text(aes(x = B, y = A, label = percent(value, accuracy=0.1)), color = "black", size = 6);
  plt <- plt + geom_text(aes(x = B, y = A, label = percent(cond, accuracy=0.1)), color = "steelblue", size = 4.5, nudge_y = -0.2);
  plt <- plt + scale_fill_gradient2(low = "white", high = "orange2", 
                                    limit = c(0,1), na.value ="white", space = "Lab", 
                                    name="Joint bistability prob.");
  plt <- plt + xlab("B");
  plt <- plt + ylab("A");
  plt <- plt + annotate("text", x = 3, y = 3, label = paste("P( A", "\U2229", "B )"), parse = F, size = 6);
  plt <- plt + annotate("text", x = 3, y = 2.8, label = paste("P( A", "\U007C", "B )"), parse = F, size = 4.5, color="steelblue");
  
  plt <- plt + theme_minimal(); # minimal theme
  plt <- plt + theme(
    # axis.text.x = element_text(angle = 45, vjust = 1, size = 8, hjust = 1),
    # axis.text.y = element_text(size = 8)
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16),
    axis.text.x = element_text(size = 15),
    axis.text.y = element_text(size = 15, angle = 90, hjust = 0.5)
  );
  plt <- plt + coord_fixed();
  plt <- plt + theme(
    # axis.title.x = element_blank(),
    # axis.title.y = element_blank(),
    panel.grid.major = element_blank(),
    panel.border = element_blank(),
    panel.background = element_blank(),
    axis.ticks = element_blank()
  );
  if(show.legend) {
    plt <- plt + theme(
      legend.justification = c(1, 0),
      # legend.position = c(0.5, 0.7),
      # legend.direction = "horizontal",
      legend.position = "left",
    );
  } else {
    plt <- plt + theme(
      legend.position = "none"
    );
  }
  plt <- plt + guides(fill = guide_colorbar(barwidth = 7, barheight = 1,
                                            title.position = "top", title.hjust = 0.5));  
  plt;
}




data.dir <- ".";
sample.num <- 200;
pop.size <- 1000;

pardir <- data.dir;
outdir <- data.dir;


pop.names <- c("ancient", "intermediate", "derived");

filepath <- paste0(pardir, "/bistable-count-FP-", sample.num, "-2.csv");
dat <-  read.csv(filepath, row.names = 1);

joint.prob.fun <- function(a,b){
  sum( dat[a,] > 0 & dat[b,] > 0)/(length(dat[a,])+1e-10);
}

joint.prob <- outer( 1:3, 1:3, Vectorize(joint.prob.fun));
joint.prob <- get.lower.tri(joint.prob);
melted.dat <- melt(joint.prob);
melted.dat$A <- factor( pop.names[melted.dat$Var1], levels=rev(pop.names));
melted.dat$B <- factor( pop.names[melted.dat$Var2], levels=pop.names);

cond.prob.fun <- function(a,b){
  sum( dat[a,] > 0 & dat[b,] > 0)/( sum( dat[b,] > 0)+1e-10);
}

cond.prob <- outer( 1:3, 1:3, Vectorize(cond.prob.fun));
cond.prob <- get.lower.tri(cond.prob);
melted.cond.dat <- melt(cond.prob);
melted.dat$cond <- melted.cond.dat$value;

plt <- generate.heatmap(melted.dat);
print(plt);

ggsave(filename=paste(data.dir, "bistability-prob1.svg", sep="/"), device="svg", plot=plt, width=12, height= 12, units="cm");

