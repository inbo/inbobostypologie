################################################################################

#' Title
#'
#' @param obj object waarop berekeningen gebeuren
#' @param size dikte van de lijn
#'
#' @return ggplot object
#' @importFrom stats na.omit
#' @importFrom utils tail
#' @importFrom ggplot2 ggplot aes geom_path geom_text geom_segment coord_fixed
#' @importFrom ggplot2 xlim ylim
#' @export
#'
btyp_plotAffinity <- function(obj, size = 2){
  x <- na.omit(obj)
  if (length(unique(x$OPNAMECODE))> 1) {
    stop("plot moet voor ieder opnamenummer apart gemaakt worden (eventueel via een for-lus)")
  }
  rv <- x
  plotdata <- x
  limits <- max(abs(range(plotdata$S_aj)))
  breaks <- pretty(limits, min.n = 4)

  plotdata$radius <- plotdata$S_aj
  plotdata$radiuslab <- limits
  plotdata$corner <- tail(seq(0, 2*pi,
                              length = (nrow(plotdata)+1)/
                                length(unique(plotdata$OPNAMECODE))),
                          -1)
  plotdata$x <- plotdata$radius * cos(plotdata$corner)
  plotdata$y <- plotdata$radius * sin(plotdata$corner)
  plotdata$xlabel <- plotdata$radiuslab * cos(plotdata$corner) * 1.1
  plotdata$ylabel <- plotdata$radiuslab * sin(plotdata$corner) * 1.1
  plotdata <- rbind(plotdata, plotdata[1,,drop=F])
  num <- 100
  circle1 <- btyp_makeCircle(breaks[1], num)
  circle2 <- btyp_makeCircle(breaks[2], num)
  circle3 <- btyp_makeCircle(breaks[3], num)
  circle4 <- btyp_makeCircle(breaks[4], num)

  ##plot itself
  p <-
    ggplot(plotdata, aes(x = .data$x, y = .data$y)) +
    geom_path(colour = "green", size = size) +
    geom_text(aes(x = .data$xlabel,
                  y = .data$ylabel , 
                  label = .data$BostypeCode)) +
    coord_fixed() +
    xlim(-limits * 1.15, limits * 1.15) +
    ylim(-limits * 1.15, limits * 1.15) +
    geom_segment(aes(xend=0, yend=0, x = .data$xlabel, y = .data$ylabel)) +
    geom_path(data = circle1, aes(x = .data$x, y = .data$y)) +
    geom_path(data = circle2, aes(x = .data$x, y = .data$y)) +
    geom_path(data = circle3, aes(x = .data$x, y = .data$y)) +
    facet_wrap(~.data$OPNAMECODE)
  #rv
  p
}
