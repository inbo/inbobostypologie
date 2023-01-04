

### Inleesfuncties (de data staat in de inst map van het pakket)
#' Title
#'
#' @return lijst met ingelezen waarden
#' @importFrom utils read.csv2
#' @export
#'
btyp_readReferenceDataFiles <- function(){
  fpath <- system.file("pkgdata", "bostypes_vlaanderen.csv", 
                       package="inbobostypologie")
  dfrBostypes <- read.csv2(fpath, stringsAsFactors = FALSE)

  fpath <- system.file("pkgdata", "referentiewaarden_berekening.csv", 
                       package="inbobostypologie")
  dfrReference <- read.csv2(fpath, stringsAsFactors = FALSE)

  fpath <- system.file("pkgdata", "soortenlijst_vlaanderen.csv", 
                       package="inbobostypologie")
  dfrSpecieslist <- read.csv2(fpath, stringsAsFactors = FALSE)

  fpath <- system.file("pkgdata", "schaal_conversie.csv", 
                       package="inbobostypologie")
  dfrConversion <- read.csv2(fpath, stringsAsFactors = FALSE)

  list(Bostypes = dfrBostypes,
       Reference = dfrReference,
       Species = dfrSpecieslist,
       Conversion = dfrConversion)
}

################################################################################
