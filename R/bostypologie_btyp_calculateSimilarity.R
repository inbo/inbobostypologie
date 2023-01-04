
#' Calculate similarities
#'
#' The central routine to calculate similarities. Normally called from a do (dplyr) or ddply (plyr) loop like btyp_calculateAffinity
#'
#' @param dat Vegetation data only containing 1 "vegetatieopname"
#' @param ref Reference data to which the similarity is calculated
#' @param correct Correct for vegetation density or not
#' @param typology Which typology score to use (now T1 (10 types), T2 (30 subtypes), T3 (39 detail types) are allowed)
#' @importFrom dplyr filter left_join select group_by summarize
#'
#' @return dataset met resultaten
#' @export
#'
btyp_calculateSimilarity <- function(dat, ref, correct, typology = "T1"){
  cat(as.character(dat$OPNAMECODE[1]), "\n")
  ref <- dplyr::filter(ref, .data$TypologieCode == typology)
  #niet meer nodig, de IndValwaarden in de databank zijn reeds genormaliseerd
  #refsum <- ddply(ref, .(BostypeCode), summarize, sum_IndVal = sum(IndVal))
  rv <- dat %>% 
    select(.data$SPECIES_NR, .data$BEDEKKING) %>% 
    left_join(ref %>% 
                filter(.data$TypologieCode == typology) %>% 
                select(.data$SPECIES_NR, .data$BostypeCode,
                       .data$Freq, .data$KarBed, .data$IndVal),
              by = "SPECIES_NR")
  
  if(correct){
    rv$w_ak<- sqrt(pmin(rv$BEDEKKING, rv$KarBed) / pmax(rv$BEDEKKING, rv$KarBed))
  } else {
    rv$w_ak <- 1
  }
  rv <- rv %>% 
    group_by(.data$BostypeCode) %>% 
    summarize(S_aj = sum(.data$IndVal * .data$w_ak), .groups = "drop")
}

################################################################################
