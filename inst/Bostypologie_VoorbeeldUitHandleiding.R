
######################################################################
# BEREKENING INDVAL CONFIG
#####################################################################


#Get the available data

inbomiscpath <- system.file(package = "INBOmisc")

path <- file.path(inbomiscpath, "Bostypologie/extdata", "Species_List_Vlaanderen.csv")
Soortenlijst <- read.csv2(path)

path <- file.path(inbomiscpath, "Bostypologie/extdata", "Tutorial_RefOpnames.csv")
RefOpnames <- read.csv2(path)

#Calculate calibration scores

Scores <- btyp_calibrateForestTypology(RefOpnames)

#
# #####################################################################
# #BEREKENING MEMBERSHIP (zonder weging)
# #####################################################################


#Maak een willekeurige opname aan (dezelfde zoals in de handleiding)

MyOpname <- data.frame(OPNAMECODE = 19,
                       SOORT = c("Zomereik", "Gewone braam", "Lelietje-van-dalen", "Wilde hyacint", "Es"),
                       BEDEKKING = c(50,5,5,2,60))

MyOpname <- merge(MyOpname, Soortenlijst[c("SPECIES_NR", "NAME_DUTCH")], all.x = TRUE, by.x = "SOORT", by.y = "NAME_DUTCH")
#De duplicaten eruit halen want door de synoniemen zijn er meerdere rijen in de soortenlijst die geldig zijn voor dezelfde rij in MyOpname
MyOpname <- MyOpname[!duplicated(MyOpname),,drop = FALSE]

#Klopt met de handleiding
result1 <- btyp_calculateAffinity(MyOpname, Scores, correct = FALSE)
result1

#Klopt met de handleiding
result2 <- btyp_calculateAffinity(MyOpname, Scores, correct = TRUE)
result2

btyp_plotAffinity(result2)


