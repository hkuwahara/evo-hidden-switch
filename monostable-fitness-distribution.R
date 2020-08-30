library("Cairo");

outdir <- ".";

theta <- 100;
theta2 <- 300;
fitness <- function(x) {
  y1 <- (x/theta)^5;
  y2 <- (x/theta2)^8;  
  y1/(1+y1) - y2/(1+y2);
}
delta<- 0.1;
xx <- seq(0,600,delta);
ff <- sapply(xx, fitness);
x.ss <- xx[which.max(ff)];
mm <- seq( -60, 60, 1);
ss <- seq( 20, 80, 1);

mlen <- length(mm);
slen <- length(ss);

ww <- matrix( NA, nrow=mlen, ncol=slen);

for( i in 1:mlen ) {
  mu <- x.ss + mm[i];
  for( j in 1:slen) {
    width <- ss[j];
    t <- dnorm(xx, mean=mu, sd=width);
    g <- t/(sum(t)*delta);
    ww[i,j] <- sum( g * ff) * delta;
  }
}

rec <- as.data.frame(ww);  
names(rec) <- ss;
rownames(rec) <- mm;
write.csv( rec, file=sprintf("%s/average-fitness-distribution-monostable.csv", outdir ), row.names=T );






filled.contour3 <-
  function (x = seq(0, 1, length.out = nrow(z)),
            y = seq(0, 1, length.out = ncol(z)), z, xlim = range(x, finite = TRUE), 
            ylim = range(y, finite = TRUE), zlim = range(z, finite = TRUE), 
            levels = pretty(zlim, nlevels), nlevels = 20, color.palette = cm.colors, 
            col = color.palette(length(levels) - 1), plot.title, plot.axes, 
            key.title, key.axes, asp = NA, xaxs = "i", yaxs = "i", las = 1, 
            axes = TRUE, frame.plot = axes,mar, ...) {
  # modification by Ian Taylor of the filled.contour function
  # to remove the key and facilitate overplotting with contour()
  # further modified by Carey McGilliard and Bridget Ferris
  # to allow multiple plots on one page
  
  if (missing(z)) {
    if (!missing(x)) {
      if (is.list(x)) {
        z <- x$z
        y <- x$y
        x <- x$x
      }
      else {
        z <- x
        x <- seq.int(0, 1, length.out = nrow(z))
      }
    }
    else stop("no 'z' matrix specified")
  }
  else if (is.list(x)) {
    y <- x$y
    x <- x$x
  }
  if (any(diff(x) <= 0) || any(diff(y) <= 0)) 
    stop("increasing 'x' and 'y' values expected")
  # mar.orig <- (par.orig <- par(c("mar", "las", "mfrow")))$mar
  # on.exit(par(par.orig))
  # w <- (3 + mar.orig[2]) * par("csi") * 2.54
  # par(las = las)
  # mar <- mar.orig
  plot.new()
  # par(mar=mar)
  plot.window(xlim, ylim, "", xaxs = xaxs, yaxs = yaxs, asp = asp)
  if (!is.matrix(z) || nrow(z) <= 1 || ncol(z) <= 1) 
    stop("no proper 'z' matrix specified")
  if (!is.double(z)) 
    storage.mode(z) <- "double"
  .filled.contour(as.double(x), as.double(y), z, as.double(levels), col = col)
  #.Internal(filledcontour(as.double(x), as.double(y), z, as.double(levels), col = col))
  if (missing(plot.axes)) {
    if (axes) {
      title(main = "", xlab = "", ylab = "")
      Axis(x, side = 1)
      Axis(y, side = 2)
    }
  }
  else plot.axes
  if (frame.plot) 
    box()
  if (missing(plot.title)) 
    title(...)
  else plot.title
  invisible()
}


filled.legend <-
  function (x = seq(0, 1, length.out = nrow(z)), y = seq(0, 1, 
                                                         length.out = ncol(z)), z, xlim = range(x, finite = TRUE), 
            ylim = range(y, finite = TRUE), zlim = range(z, finite = TRUE), 
            levels = pretty(zlim, nlevels), nlevels = 20, color.palette = cm.colors, 
            col = color.palette(length(levels) - 1), plot.title, plot.axes, 
            key.title, key.axes, asp = NA, xaxs = "i", yaxs = "i", las = 1, 
            axes = TRUE, frame.plot = axes, ...) {
  # modification of filled.contour by Carey McGilliard and Bridget Ferris
  # designed to just plot the legend
  if (missing(z)) {
    if (!missing(x)) {
      if (is.list(x)) {
        z <- x$z
        y <- x$y
        x <- x$x
      }
      else {
        z <- x
        x <- seq.int(0, 1, length.out = nrow(z))
      }
    }
    else stop("no 'z' matrix specified")
  }
  else if (is.list(x)) {
    y <- x$y
    x <- x$x
  }
  if (any(diff(x) <= 0) || any(diff(y) <= 0)) 
    stop("increasing 'x' and 'y' values expected")
  #  mar.orig <- (par.orig <- par(c("mar", "las", "mfrow")))$mar
  #  on.exit(par(par.orig))
  #  w <- (3 + mar.orig[2L]) * par("csi") * 2.54
  #layout(matrix(c(2, 1), ncol = 2L), widths = c(1, lcm(w)))
  #  par(las = las)
  #  mar <- mar.orig
  #  mar[4L] <- mar[2L]
  #  mar[2L] <- 1
  #  par(mar = mar)
  # plot.new()
  plot.window(xlim = c(0, 1), ylim = range(levels), xaxs = "i", 
              yaxs = "i")
  rect(0, levels[-length(levels)], 1, levels[-1L], col = col)
  if (missing(key.axes)) {
    if (axes) 
      axis(4)
  }
  else key.axes
  box()
}


textscale <- 7.0;
par(mar=c(5,5,1,4),cex.axis=4.0); 
Cairo(file=sprintf("%s/monostable-average-fitness-dist.svg", outdir), type="svg",width = 16, height = 11, units="cm");  
# svg( file=sprintf("%s/monostable-average-fitness-dist.svg", outdir), width=10,height=5 );

# topology: 2 1 -1 -2 4
# param: 3 3 2 2 2 (0-base)   
# change the 1st and 2nd params (kf1, kb1) and (kf2,kb2) from 1 to 5 with 0.1 increment.
# 
#levels <- log10( seq(1e-10,1+1e-10,0.1) );
#levels <- seq(-10,0,0.1);
levels <- seq(0.60,0.93,0.005);
colorFunc <- colorRampPalette(c("blue", "yellow", "red") );
my.colors <- c( "#0000FF", colorFunc( length(levels) - 1) );
filled.contour3( x=mm, y=ss, z=ww, col=my.colors, levels=c(0,levels), axes=T, key.axes=T,frame.plot = T);

dev.off();


Cairo(file=sprintf("%s/average-fitness-dist-legend.svg", outdir), type="svg",width = 10, height = 20, units="cm");  
filled.contour( x=mm, y=ss, z=ww, color.palette=colorRampPalette(c("blue", "yellow", "red")), levels=levels,cex=textscale,key.axes=F,frame.plot = T);
dev.off();
