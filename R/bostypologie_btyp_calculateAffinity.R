
#' Calculate affinity-score with a certain forest type
#'
#'This function is a wrapper that calculates for every "vegetatieopname" the similarity score using the function btyp_calculateSimilarity
#' @param dat Opnamedata
#' @param ref Referentiedata
#' @param correct Corrigeer op basis van vegetatiebedekking
#' @param typology Welke typologie wil je gebruiken
#' \itemize{
#' \item{T1}{Categorisatie in 10 hoofdtypes}
#' \item{T2}{Categorisatie in 30 subtypes}
#' \item{T3}{Categorisatie in 39 detailtypes}}
#' @import dplyr
#' @return
#' @export
#'
#' @examples
btyp_calculateAffinity <- function(dat, ref, correct = TRUE, typology = "T1"){
  dat <- dplyr::group_by_(dat, "OPNAMECODE")
  dplyr::do(dat, btyp_calculateSimilarity(.,
                                   ref = ref,
                                   correct = correct,
                                   typology = typology))
}



################################################################################
