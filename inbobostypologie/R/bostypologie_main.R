#
#
# Opnames <- expand.grid(SOORT = rep(c("Struikhei", "Grove den", "Bochtige smele", "Ruwe berk",
#                                      "Blauwe bosbes", "Zomereik", "Gewone braam", "Lelietje-van-dalen",
#                                      "Beuk", "Haagbeuk", "Wilde hyacint", "Gele dovenetel",
#                                      "Es", "Slanke sleutelbloem", "Speenkruid", "Bosveldkers")),
#                        BostypeCode = c(rep("a",6), rep("b", 6), rep("c", 6))
# )
# Opnames$SPECIES_NR <- c(186,943,398,140,
#                         1329,1037,1634,349,
#                         513,270,1151,702,
#                         531,1014,2402,202)
# Opnames$OPNAMECODE <- rep(c(17,14,12,18,6,1,4,11,3,7,2,8,5,9,15,10,13,16), c(rep(16, 18)))
# Opnames$BEDEKKING <- c(
#     #type a
#     2,68,68,15,NA,3,2,rep(NA,9),
#     NA,NA,15,15,38,88,3,1, rep(NA,8),
#     1,88,NA,1,NA,1,rep(NA,10),
#     NA,38,15,15,NA,38,2, rep(NA,9),
#     15,NA,1,68,rep(NA,12),
#     NA,68,88,2,1, rep(NA, 11),
#     #type b
#     rep(NA,6),15,3,88,68,68,2, rep(NA,4),
#     rep(NA,5),68,38,NA,15,NA,88,NA,2,rep(NA,3),
#     rep(NA,5),68,1,NA,NA,38,15,38,rep(NA,4),
#     rep(NA,5),15,NA,NA,88,NA,38,2,rep(NA,4),
#     rep(NA,3),2,NA,88,68,NA,15,NA,15, rep(NA,5),
#     rep(NA,5),68, rep(NA,4),3,38,1,rep(NA,3),
#     #type c
#     rep(NA,5),1,2,rep(NA,4), 15,88,2,15,2,
#     rep(NA,5),1,2,rep(NA,2), 1, rep(NA,2), 68,2,68,NA,
#     rep(NA,5),68,rep(NA,5),1,2,1,38,3,
#     rep(NA,8),1,rep(NA,2),88,68,NA,15,1,
#     rep(NA,5),38,2,rep(NA,5),68,1,2,3,
#     rep(NA,5),88,1,rep(NA,5),1,NA,88,2
# )
# Opnames <- na.omit(Opnames)
#
#
# library(reshape2)
# OpnamesWide <- dcast(Opnames, SOORT ~ OPNAMECODE, value.var = "BEDEKKING", fun = mean)
#
#
# ######################################################################
# # BEREKENING INDVAL CONFIG
# #####################################################################
# library("RODBC")
# conn <- odbcConnectAccess("BostypologieApplicatieDB.mdb")
# sqlTables(conn)
# Soortenlijst <- sqlFetch(conn, "tblSoort")
# odbcClose(conn)
#
# Referentielijst <- readReferenceDataFiles()
#
#
#
#
# Scores <- berekenIndValConfig(Opnames)
#
# ScoresToCheck <- merge(Scores, Soortenlijst[c("SPECIES_NR", "NAME")], all.x = TRUE, by = "SPECIES_NR")
#
# ScoresToCheck <- ScoresToCheck[order(ScoresToCheck$BostypeCode, ScoresToCheck$NAME), ]
#
# #
# # #####################################################################
# # #BEREKENING MEMBERSHIP (zonder weging)
# # #####################################################################
# #
# #
# MyOpname <- data.frame(OPNAMECODE = 19,
#                        SOORT = c("Zomereik", "Gewone braam", "Lelietje-van-dalen", "Wilde hyacint", "Es"),
#                        BEDEKKING = c(50,5,5,2,60))
# MyOpname <- merge(MyOpname, Soortenlijst[c("SPECIES_NR", "NAME")], all.x = TRUE, by.x = "SOORT", by.y = "NAME")
#
#
#
#
# verwantschap_no_corr <- berekenVerwantschap(MyOpname, Scores, correctie = FALSE)
#
# verwantschap <- berekenVerwantschap(MyOpname, Scores, correctie = TRUE)
#
# plotVerwantschap(verwantschap)
#
#
