sampInfo <- read_tsv("./brown_data_overview.txt", col_names = T)
paired_pats <- c(10, 11, 14, 2, 21, 22, 23, 3, 4, 5, 7, 8, 9)
sampInfo %<>% filter(Patient %in% paired_pats) %>% select(Run, Type,Patient)
sampInfo$Type <- as.factor(sampInfo$Type)
sampInfo %<>% lapply(., function(x) { if ( is.factor(x) ) gsub("Sputum\\s*", "sputum", x) else x }) %>% data.frame
sampInfo %<>% lapply(., function(x) { if ( is.factor(x) ) gsub("Culture\\s*", "culture", x) else x }) %>% data.frame
write.table(sampInfo, file = "./scripts/perlscripts/Fst/sampleInfo_fst_calcs.txt", sep = "\t", col.names = F, row.names = F, quote = F)
