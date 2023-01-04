## ---- fig.show='hold'----------------------------------------------------
plot(1:10)
plot(10:1)

## ---- echo=FALSE, results='asis'-----------------------------------------
knitr::kable(head(mtcars, 10))

## ------------------------------------------------------------------------
#'
#' @param n_ak aantal opnamen met soort k behorend tot type a
#' @param n aantal opnamen behoren tot type a
#'
#' @return
#' @export
#'
#' @examples
P_ak <- function(n_ak, n_a){
  n_ak / n_a * 100
}

## ---- eval = FALSE-------------------------------------------------------
#  #'
#  #' @param B_ak vector met de bedekkingen van soort k in de opnames j behorend tot type a
#  #' @param n_ak aantal opnamen met soort k behorend tot type a
#  #'
#  #' @return
#  #' @export
#  #'
#  #' @examples
#  KB_ak <- function(B_ak, n_ak){
#    sum(B_ak) / n_ak
#  }

## ---- eval = FALSE-------------------------------------------------------
#  #' @param n_k aantal opnamen met soort k in de hele dataset
#  #' @param n tottal aantal opnamen in de hele dataset
#  #'
#  #' @return
#  #' @export
#  #'
#  #' @examples
#  P_k <- function(n_k, n){
#    nk / n * 100
#  }

## ---- eval = FALSE-------------------------------------------------------
#  #' @param P_ak Presentie van een soort in een bostype (formule 1)
#  #' @param P_k Algemene presentie van een soort in de dataset (formule 4)
#  #'
#  #' @return
#  #' @export
#  #'
#  #' @examples
#  T_ak <- function(P_ak, P_k){
#    P_ak / P_k
#  }

## ---- eval = FALSE-------------------------------------------------------
#  #' @param Pak Presentie van een soort in een bostype (formule 1)
#  #' @param Pk mag leeg zijn als Tak ingevuld is. Algemene presentie van een soort in de dataset (formule 4).
#  #' @param Tak mag leeg zijn als Pk ingevuld is. Trouw van een soort aan een bostype (formule 3)
#  #'
#  #' @return
#  #' @export
#  #'
#  #' @examples
#  IndVal_ak <- function(P_ak, P_k, T_ak){
#    if (!missing(Pk)){
#      rv <- P_ak^2 / (P_k * 100)
#    } else {
#      rv <- T_ak * P_ak / 100
#    }
#  
#    rv
#  }

## ---- eval = FALSE-------------------------------------------------------
#  #' @param IndVal_ak vector met indicatorwaarde van de soorten voor een bepaalde gemeenschap (formule 5)
#  #'
#  #' @return vector
#  #' @export vector met genormaliseerde IndValwaarden
#  #'
#  #' @examples
#  v_ak <- function (IndVal_ak){
#    IndVal_ak / sum(IndVal_ak)
#  }

## ---- eval = FALSE-------------------------------------------------------
#  #' @param v_ak vector met genormaliseerde indvalwaarden voor alle soorten in een bepaalde opname (formule 6)
#  #'
#  #' @return
#  #' @export
#  #'
#  #' @examples
#  S_aj_simple <- function(v_ak){
#    sum(v_ak)
#  }

## ---- eval = FALSE-------------------------------------------------------
#  #' @param B_jk Bedekking van soort k in opname j
#  #' @param KB_ak karaktereistiek ebedekking van soort k in gemeenschap a
#  #'
#  #' @return
#  #' @export
#  #'
#  #' @examples
#  w_ajk <- function(B_jk, KB_ak){
#    sqrt(pmin(B_jk, KB_ak)/pmax(B_jk, KB_ak))
#  }

## ---- eval = FALSE-------------------------------------------------------
#  #' @param v_ak v_ak vector met genormaliseerde indvalwaarden voor alle soorten in een bepaalde opname (formule 6)
#  #' @param w_ajk vector met wegingsfactoren (formule 9)
#  #'
#  #' @return
#  #' @export
#  #'
#  #' @examples
#  S_aj <- function(v_ak, w_ajk){
#    sum(v_ak * w_ajk)
#  }

## ------------------------------------------------------------------------
library(INBOmisc)
library(plyr)
library(dplyr)
library(ggplot2)

inbomiscpath <- system.file(package = "INBOmisc")
# 
path <- file.path(inbomiscpath, "Bostypologie/extdata", "Species_List_Vlaanderen.csv")
Soortenlijst <- read.csv2(path)
# 
path <- file.path(inbomiscpath, "Bostypologie/extdata", "Tutorial_RefOpnames.csv")
RefOpnames <- read.csv2(path)
# 
# #Calculate calibration scores
# 
Scores <- btyp_calibrateForestTypology(RefOpnames)

## ------------------------------------------------------------------------

MyOpname <- data.frame(OPNAMECODE = 19, 
                       SOORT = c("Zomereik", "Gewone braam", 
                                 "Lelietje-van-dalen", "Wilde hyacint", "Es"),
                       BEDEKKING = c(50,5,5,2,60))

MyOpname <- merge(MyOpname, Soortenlijst[c("SPECIES_NR", "NAME_NL")], all.x = TRUE, by.x = "SOORT", by.y = "NAME_NL")
# #De duplicaten eruit halen want door de synoniemen zijn er meerdere rijen in de soortenlijst die geldig zijn voor dezelfde rij in MyOpname
MyOpname <- MyOpname[!duplicated(MyOpname),,drop = FALSE]

#Classificatie met niet-gewogen scores
result1 <- btyp_calculateAffinity(MyOpname, Scores, correct = FALSE)
result1
# 
#Classificati met gewogen scores
result2 <- btyp_calculateAffinity(MyOpname, Scores, correct = TRUE)
result2

#Plot de resultaten 
btyp_plotAffinity(result1)
btyp_plotAffinity(result2)


## ------------------------------------------------------------------------
#Haal de voorbeeld opname file op
#LET OP. De variabele met de waarden in, moet een character variabele zijn
  #Dus voor Pct moet je letterlijk de waarden .1 .2 .3 ... .9 1 2 3 4 ...25 26 hebben
  # In een latere iteratie van het pakket kan dit opgelost worden
voorbeeldVlaanderen <- read.csv2(paste(system.file(package = "INBOmisc"),
                                       "Bostypologie/extdata/OpnameVoorbeeldVlaanderen.csv",
                                       sep = "/"), stringsAsFactors = FALSE)
str(voorbeeldVlaanderen)
#Haal de calibratie voor Vlaanderen op
reflist <- btyp_readReferenceDataFiles()

wdata <- btyp_prepareSampleData(voorbeeldVlaanderen, 
                                scale = "Pct", #reflist$Conversion$NAME_SHORT
                                conversiontable = reflist$Conversion,
                                specieslist = reflist$Species,
                                lang_sp = "NL", 
                                namecolumn = "Soort.NL",
                                keycolumn = "Key",
                                coveragecolumn = "Code")

wdata$BEDEKKING <- wdata$COVERAGE #Bug die nog moet opgelost worden
resultaten <- btyp_calculateAffinity(wdata, reflist$Reference, correct = TRUE, typology = "T3")

#check resultaten met de effectieve classificatie


resultOfficieel <- read.csv2(paste(system.file(package = "INBOmisc"),
                                "Bostypologie/extdata",
                                "OpnameVoorbeeldVlaanderenOfficieleResultaten.csv",
                                       sep = "/"), stringsAsFactors = FALSE)
str(resultOfficieel)
comparison <- merge(as.data.frame(resultaten)[c("OPNAMECODE","BostypeCode","S_aj")], resultOfficieel[c("Key", "Bostype","Score")], 
                    by.x = c("OPNAMECODE","BostypeCode" ),
                    by.y = c("Key", "Bostype"))
comparison$S_aj <- round(comparison$S_aj,3)
comparison$Score <- round(comparison$Score,3)
cpeval <- ddply(comparison, .(OPNAMECODE), function(dat) {
  data.frame(MX1=dat$BostypeCode[which.max(dat$S_aj)],
             MX2=dat$BostypeCode[which.max(dat$Score)])})


