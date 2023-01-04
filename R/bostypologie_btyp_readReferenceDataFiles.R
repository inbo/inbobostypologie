

### Inleesfuncties (de data staat in de inst map van het pakket)
#' Title
#'
#' @return
#' @export
#'
#' @examples
btyp_readReferenceDataFiles <- function(){
  fpath <- system.file("bostypologie/extdata", "Bostypes_Vlaanderen.csv", package="INBOmisc")
  dfrBostypes <- read.csv2(fpath, stringsAsFactors = FALSE)

  fpath <- system.file("bostypologie/extdata", "Reference_Values.csv", package="INBOmisc")
  dfrReference <- read.csv2(fpath, stringsAsFactors = FALSE)

  fpath <- system.file("bostypologie/extdata", "Species_List_Vlaanderen.csv", package="INBOmisc")
  dfrSpecieslist <- read.csv2(fpath, stringsAsFactors = FALSE)

  fpath <- system.file("bostypologie/extdata", "SchaalConversie.csv", package="INBOmisc")
  dfrConversion <- read.csv2(fpath, stringsAsFactors = FALSE)

  list(Bostypes = dfrBostypes,
       Reference = dfrReference,
       Species = dfrSpecieslist,
       Conversion = dfrConversion)
}

################################################################################
