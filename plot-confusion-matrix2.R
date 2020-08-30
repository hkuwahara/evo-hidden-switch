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
# args <- commandArgs(TRUE);
# data.dir <- args[1];
# sample.num <- as.numeric(args[2]);
# pop.size <- as.numeric(args[3]);



data.dir <- ".";
sample.num <- 200;
pop.size <- 1000;

pardir <- data.dir;
outdir <- data.dir;


pop.names <- c("intermediate", "derived");

filepath <- paste0(pardir, "/bistable-count-FP-", sample.num, "-2.csv");
dat <-  read.csv(filepath, row.names = 1);

derived.state <- ifelse( dat[3,] > 0, "bistable", "monostable");
interm.state <- ifelse( dat[2,] > 0, "bistable", "monostable");
conf.mat <- table(interm.state, derived.state, dnn=c("intermediate", "derived"));
melted.conf.mat <- melt(conf.mat);
# melted.conf.mat$intermediate <- factor(melted.conf.mat$intermediate, levels=c("bistable", "monostable") );
melted.conf.mat$derived <- factor(melted.conf.mat$derived, levels=c("bistable", "monostable") );
melted.conf.mat$intermediate <- factor(melted.conf.mat$intermediate, levels=c("monostable","bistable") );
# melted.conf.mat$derived <- factor(melted.conf.mat$derived, levels=c("monostable","bistable") );

plt <- plot_confusion_matrix(melted.conf.mat, targets_col = "derived", predictions_col = "intermediate", counts_col = "value", 
                             palette = "Greens", add_arrows = F,
                             font_counts=font(size=5), font_normalized = font(size=7), 
                             font_row_percentages=font(size=4), font_col_percentages=font(size=4));
plt <- plt + labs(x = "derived", y = "intermediate");
# plt <- plt + scale_y_discrete(limits = c("bistable", "monostable"));
# plt <- plt + scale_x_discrete(limits = rev(c("bistable", "monostable"));

plt <- plt + theme(
  # axis.text.x = element_text(angle = 45, vjust = 1, size = 8, hjust = 1),
  # axis.text.y = element_text(size = 8)
  axis.ticks.x=element_blank(),
  axis.ticks.y=element_blank(),
  axis.title.x = element_text(size = 18),
  axis.title.y = element_text(size = 18),
  axis.text.x = element_text(size = 18),
  axis.text.y = element_text(size = 18)
);

print(plt)
ggsave(filename=paste(data.dir, "confusion-mat.svg", sep="/"), device="svg", plot=plt, width=10, height= 10, units="cm");

# alternative hypothesis: true odds ratio is not equal to 1
# 95 percent confidence interval:
#   17.03016 148.57487
# sample estimates:
#   odds ratio 
# 46.19075 

