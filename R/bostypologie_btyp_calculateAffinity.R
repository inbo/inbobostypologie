
utils::globalVariables(".data") #eenmalig in eerste file in alfabet

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
#' @importFrom dplyr group_by do %>%
#' @return dataset met resultaten
#' @export
#'
btyp_calculateAffinity <- function(dat, ref, correct = TRUE, typology = "T1"){
  . <- NULL
  dat <- dat %>% 
    group_by(.data$OPNAMECODE) %>% 
    do(btyp_calculateSimilarity(.,
                                ref = ref,
                                correct = correct,
                                typology = typology))
}



################################################################################
