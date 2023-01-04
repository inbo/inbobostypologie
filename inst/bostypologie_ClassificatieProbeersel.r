mydata <- expand.grid(Key = "1",
                      Spec = c("Spaanse aak", "Gewone esdoorn"))
mydata$Coverage <- c("2m",5)

reflist <- btyp_readReferenceDataFiles()

wdata <- btyp_prepareSampleData(mydata, "BrBl",
                  reflist$Conversion,
                  reflist$Species,
                  lang_sp = "NL", namecolumn = "Spec",
                  keycolumn = "Key",
                  coveragecolumn = "Coverage")

btyp_calculateAffinity(wdata, reflist$Reference, correct = TRUE, typology = "T1")
