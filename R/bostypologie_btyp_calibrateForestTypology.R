#Berekent eigenschapppen om de referentielijst aan te maken indien deze niet beschikbaar is
#Klopt met cijfers in handleiding (in de handleiding staan fouten)
#' Title
#'
#' @param obj
#' @param typology
#'
#' @return
#' @export
#'
#' @examples
btyp_calibrateForestTypology <- function(obj, typology = "T1"){
  #hulpfunctie om eigenschappen van de data los van de gemeenschap te berekenen
  Calc0 <- function(dat){
    dat <- group_by(dat, SPECIES_NR)
    dat$n <- length(unique(dat$OPNAMECODE))
    summarize(dat,
              n_k = sum(BEDEKKING>0),
              n = n[1],
              P_k = n_k / n * 100)
  }

  Calc1 <- function(dat){
    n_a <-  length(unique(dat$OPNAMECODE[dat$BEDEKKING > 0]))
    dat <- group_by(dat, SPECIES_NR)
    Res <- summarize(
      dat,
      n_ak = sum(BEDEKKING > 0),
      KB_ak = sum(BEDEKKING) / n_ak,
      P_k = P_k[1],
      n = n[1],
      n_k = n_k[1])
    Res$n_a <- n_a
    Res$P_ak <- Res$n_ak / Res$n_a * 100
    Res$T_ak <- Res$P_ak / Res$P_k
    Res$IndVal_ak <- Res$T_ak * Res$P_ak / 100
    Res$Freq <- Res$P_ak / 100
    Res$KarBed <- Res$KB_ak
    Res$v_ak <- Res$IndVal_ak / sum(Res$IndVal_ak)
    Res$IndVal <- Res$v_ak

    Res[c("SPECIES_NR","P_ak","T_ak", "KB_ak", "IndVal_ak",
          "v_ak", "n_ak", "n_a", "n", "n_k","P_k",
          "Freq", "KarBed", "IndVal")]
  }

  #Breidt de dataset uit met de eigenschappen die gelden over de gemeenschappen heen
  calculated_prop <- Calc0(obj)

  Opnames_Extended <- left_join(obj, calculated_prop, by = "SPECIES_NR")

  #Geeft een score per soort per gemeenschap terug om een gemeenschap te karakteriseren
  Opnames_Extended <- group_by(Opnames_Extended, BostypeCode)
  rv <- do(Opnames_Extended, Calc1(.))
  rv$TypologieCode <- typology
  rv

}

################################################################################
