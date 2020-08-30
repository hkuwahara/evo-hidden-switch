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

data.dir <- ".";
sample.num <- 200;
pop.size <- 1000;
pop.names <- c("ancient", "intermediate", "derived");
gens <- c(10000, 20000, 30000);

filepath <- paste0(data.dir, "/bistable-count-FP-", sample.num, "-3.csv");
dat <-  read.csv(filepath, row.names = 1);

bistable.prob1 <- apply( dat, 1, function(v){sum(v > 0)/length(v); } );

melted.dat <- data.frame( population=rep(pop.names, each=3), generation=rep(gens, 3) );
melted.dat$population <- factor(melted.dat$population, levels=pop.names );
melted.dat$generation <- factor(melted.dat$generation, levels=gens );

plot.colors <- pal_npg()(10);
show_col(pal_npg()(10));

melted.dat$prob <- bistable.prob1;

gen.plot <- function( df, show.legend=F ) {
  plt <- ggplot(data=df, aes(population, prob, group=generation));
  plt <- plt + geom_histogram(stat="identity", aes(fill=generation), position=position_dodge2(padding=0.1), alpha=0.7, width = 0.5);
  plt <- plt + scale_fill_manual(name="generation", values=c("10000" = plot.colors[2], "20000" = plot.colors[3], "30000" = plot.colors[4]));
  plt <- plt + ylab("frac of bistable population");
  
  plt <- plt + scale_y_continuous(labels=percent, breaks=seq(0.0, 1.0, 0.2), limits=c(0,1));
  plt <- plt + theme_minimal();
  plt <- plt + theme(
    legend.position = c(0.2, 0.65),
    legend.box.background = element_rect(colour = "black"),
    # panel.background = element_rect(fill = "whitesmoke", colour = "black"),
    panel.background = element_rect(fill = "white", colour = "black"),
    axis.text.x = element_text(size = 14),
    axis.title.x = element_text(size = 16),
    axis.text.y = element_text(size = 14),
    axis.title.y = element_text(size = 16),
    legend.title =element_text(size = 14),
    legend.text = element_text(size = 14));
}

plt <- gen.plot( melted.dat );
print(plt);
# ggsave(filename =sprintf("%s/evo-bistable-prob1.svg", data.dir), device="svg", plot=plt, width=24, height= 8, units="cm");
ggsave(filename =sprintf("%s/evo-bistable-prob1.svg", data.dir), device="svg", plot=plt, width=14, height= 8, units="cm");
