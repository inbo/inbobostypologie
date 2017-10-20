
#' Create xy coordinates of a circle given the radius and resolution
#'
#' @param radius radius of circle
#' @param num resolution of circle. Amount of points of which a half-circle consists
#'
#' @return
#' @export
#'
#' @examples
#' cko <- btyp_makeCircle(radius = 3, num = 100)
#' par(pty="s")
#' plot(cko$x, cko$y, type="l", pty = "s")
btyp_makeCircle <- function(radius, num){
  x <- c(seq(-radius,radius, length = num), seq(radius, -radius, length = num))
  sign <- rep(c(1,-1), rep(num,2))
  y <- sqrt(radius**2 - x**2) * sign
  cko <- data.frame(x=x, y=y, radius=radius, sign=sign)
  cko
}

