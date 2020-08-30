#! /usr/bin/Rscript

library("dplyr");
library("data.table");
library("reshape2");
library("ggplot2");
library("scales");
library("ggsci");
library("gridExtra");
library("ggpubr");

args <- commandArgs(TRUE);
data.dir <- args[1];
pardir <- data.dir;
outdir <- data.dir;


filepath <- sprintf("%s/stability-n1.tsv", pardir );
dat1 <-  read.delim(filepath);

filepath <- sprintf("%s/stability-n3.tsv", pardir );
dat3 <-  read.delim(filepath);

mean.dat1 <- rowMeans( dat1[,-1], na.rm = T);
mean.dat3 <- rowMeans( dat3[,-1], na.rm = T);
d <- data.frame( generation=c( dat1$generation, dat3$generation ), 
                 population=rep( c("ancient", "derived"), c(length(dat1$generation), length(dat3$generation)) ),
                 stability=c(mean.dat1, mean.dat3)
);

plt <- ggplot(d, aes(x=generation, y=stability, group=population, color=population));
plt <- plt + geom_line(aes(linetype=population));
# plt <- plt + scale_linetype_manual(values=c("longdash", "dashed"));
plt <- plt + scale_color_manual(values=c("red", "blue"));
plt <- plt + scale_size_manual(values=c(3, 3));
plt <- plt + theme(
  legend.position = c(0.9, 0.4),
  legend.box.background = element_rect(colour = "black"),
  # panel.background = element_rect(fill = "whitesmoke", colour = "black"),
  panel.background = element_rect(fill = "white", colour = "black"),
  axis.text.x = element_text(size = 14),
  axis.title.x = element_text(size = 16),
  axis.text.y = element_text(size = 14),
  axis.title.y = element_text(size = 16),
  legend.title = element_blank(),
  legend.text = element_text(size = 14));

ggsave(filename=paste(outdir, "stability-evo.svg", sep="/"), device="svg", plot=plt, width=20, height= 5, units="cm");

