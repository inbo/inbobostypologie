#Berekent eigenschapppen om de referentielijst aan te maken indien deze niet beschikbaar is
#Klopt met cijfers in handleiding (in de handleiding staan fouten)
#' Title
#'
#' @param obj object waarop berekeningen gebeuren
#' @param typology keuze van het typologieniveau "T1", "T2"of "T3"
#' @importFrom dplyr mutate
#'
#' @return dataset met resultaten
#' @export 
#'
btyp_calibrateForestTypology <- function(obj, typology = "T1"){
  . <- NULL
  #hulpfunctie om eigenschappen van de data los van de gemeenschap te berekenen
  Calc0 <- function(dat){
    dat <- dat %>% 
      group_by(.data$SPECIES_NR) %>% 
      mutate(n = length(unique(.data$OPNAMECODE))) %>% 
    summarize(n_k = sum(.data$BEDEKKING>0),
              n = .data$n[1],
              P_k = .data$n_k / .data$n * 100)
  }

  Calc1 <- function(dat){
    len_a <-  length(unique(dat$OPNAMECODE[dat$BEDEKKING > 0]))
    Res <- dat %>% 
      group_by(.data$SPECIES_NR) %>% 
      summarize(
        n_ak = sum(.data$BEDEKKING > 0),
        KB_ak = sum(.data$BEDEKKING) / .data$n_ak,
        P_k = .data$P_k[1],
        n = .data$n[1],
        n_k = .data$n_k[1]) %>% 
      mutate(n_a = len_a,
             P_ak = .data$n_ak / .data$n_a * 100,
             T_ak = .data$P_ak / .data$P_k,
             IndVal_ak = .data$T_ak * .data$P_ak / 100,
             Freq = .data$P_ak / 100,
             KarBed = .data$KB_ak,
             v_ak = .data$IndVal_ak / sum(.data$IndVal_ak),
             IndVal = .data$v_ak)

    Res[c("SPECIES_NR","P_ak","T_ak", "KB_ak", "IndVal_ak",
          "v_ak", "n_ak", "n_a", "n", "n_k","P_k",
          "Freq", "KarBed", "IndVal")]
  }

  #Breidt de dataset uit met de eigenschappen die gelden over de gemeenschappen heen
  calculated_prop <- Calc0(obj)

  Opnames_Extended <- obj %>% 
    left_join(calculated_prop, by = "SPECIES_NR")

  #Geeft een score per soort per gemeenschap terug om een gemeenschap te karakteriseren
  rv <- Opnames_Extended %>% 
    group_by(.data$BostypeCode) %>% 
    do(Calc1(.)) %>% 
    mutate(TypologieCode = typology)
  rv

}

################################################################################
