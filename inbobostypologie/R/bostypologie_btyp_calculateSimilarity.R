
#' Calculate similarities
#'
#' The central routine to calculate similarities. Normally called from a do (dplyr) or ddply (plyr) loop like btyp_calculateAffinity
#'
#' @param dat Vegetation data only containing 1 "vegetatieopname"
#' @param ref Reference data to which the similarity is calculated
#' @param correct Correct for vegetation density or not
#' @param typology Which typology score to use (now T1 (10 types), T2 (30 subtypes), T3 (39 detail types) are allowed)
#'
#' @return
#' @export
#'
#' @examples
btyp_calculateSimilarity <- function(dat, ref, correct, typology = "T1"){
  cat(as.character(dat$OPNAMECODE[1]), "\n")
  ref <- dplyr::filter(ref, TypologieCode == typology)
  #zo te zien niet echt meer nodig, de IndValwaarden in de databank zijn reeds genormaliseerd
  #refsum <- ddply(ref, .(BostypeCode), summarize, sum_IndVal = sum(IndVal))
  rv <- dplyr::left_join(dat[c("SPECIES_NR","BEDEKKING")],
                  dplyr::select_(dplyr::filter(ref, TypologieCode == typology),
                         "SPECIES_NR", "BostypeCode",
                         "Freq", "KarBed", "IndVal"),
                  by = "SPECIES_NR")
  if(correct){
    rv$w_ak<- sqrt(pmin(rv$BEDEKKING, rv$KarBed) / pmax(rv$BEDEKKING, rv$KarBed))
  } else {
    rv$w_ak <- 1
  }
  rv <- dplyr::group_by_(rv, "BostypeCode")
  print(rv)
  dplyr::summarize(rv, S_aj = sum(IndVal*w_ak))
}

################################################################################
