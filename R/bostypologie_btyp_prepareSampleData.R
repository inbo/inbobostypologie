#scale Pct, BrBl, Tan11, Londo
#NL, SCI


#' Title
#'
#' @param opname opname
#' @param scale schaal
#' @param conversiontable conversietabel
#' @param specieslist soortenlijst
#' @param lang_sp taal soortenlijst "NL"
#' @param namecolumn kolomnaam van de soort
#' @param keycolumn sleutelkolom
#' @param coveragecolumn kolom met bedekkingen
#' @importFrom dplyr distinct 
#' @importFrom ggplot2 facet_wrap
#'
#' @return data.frame
#' @export
#'
btyp_prepareSampleData <- 
  function(opname, scale, conversiontable, specieslist,
           lang_sp = "NL", namecolumn = "SOORT", keycolumn = "OPNAMECODE",
           coveragecolumn = "COVERAGE_CODE"){
  
  #SPECIES_NR, OPNAMECODE, BEDEKKING
  opname$OPNAMECODE <- opname[, keycolumn]
  opname$COVERAGE_CODE <- opname[, coveragecolumn]

  if (any(is.na(opname$OPNAMECODE))){
    stop("Kolom OPNAMECODE moet aanwezig zijn als sleutel voor de opname\n
         Deze mag ook geen NA waarden bevatten")
  }

  if ("SPECIES_NR" %in% names(opname)){
    if (!all(opname$SPECIES_NR %in% specieslist$SPECIES_NR))
      stop("Niet alle soortnummers zijn gekend in de soortenlijst")

  } else {
    if (lang_sp == "NL"){
      distinctspec <- data.frame(NAME_NL = unique(opname[,namecolumn]),
                                 stringsAsFactors = FALSE)
      speclist <- distinct(
        left_join(distinctspec, specieslist, by = "NAME_NL"))
      opname$NAME_NL <- opname[, namecolumn]
      opname <- left_join(opname, speclist, by = "NAME_NL")
    } else if (lang_sp == "SCI"){
      distinctspec <- data.frame(NAME_SCIENTIFIC = unique(opname[,namecolumn]),
                                 stringsAsFactors = FALSE)
      speclist <- distinct(
        left_join(distinctspec, specieslist, by = "NAME_SCIENTIFIC"))
      opname$NAME_SCIENTIFIC <- opname[, namecolumn]
      opname <- left_join(opname, speclist, by = "NAME_SCIENTIFIC")

    } else {
      stop("De taal werd niet herkend")
    }
    if (any(is.na(speclist$SPECIES_NR))){
      stop("Voor niet iedere soortnaam kon een SPECIES_NR gevonden worden")
    }
  }

  opname$NAME_SHORT <- scale

  Data <- left_join(opname, conversiontable, by = c("NAME_SHORT", "COVERAGE_CODE"))
  Data$BEDEKKING <- Data$COVERAGE

  if (any(is.na(Data$BEDEKKING))) {
    stop("Niet alle bedekkingen konden correct gedecodeerd worden")
  }
  Data %>% 
    select( .data$OPNAMECODE, .data$SPECIES_NR, .data$COVERAGE)
  }


################################################################################


