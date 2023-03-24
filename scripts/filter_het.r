options(scipen=999)

library(dplyr)
library(tidyr)

args = commandArgs(trailing = TRUE)
syri_file = args[1]
vari_file = args[2]
out_hap1_file = args[3]
out_hap2_file = args[4]


df = read.table(syri_file)
vari_list = readLines(vari_file)
df = df %>% filter(V11 %in% vari_list) %>%
	mutate_at(c("V2", "V3", "V7", "V8"), as.numeric) %>%
	mutate(tempstart1 = pmin(V2, V3), tempstop1 = pmax(V2, V3), tempstart2 = pmin(V7, V8), tempstop2 = pmax(V7, V8)) %>%
	mutate(V2 = tempstart1, V3 = tempstop1, V7 = tempstart2, V8 = tempstop2) %>%
	mutate(V2 = V2 -1, V7 = V7 - 1) %>%
	mutate_at(c("V1", "V6"), ~gsub("Chr", "chr", .))

df_hap1 = df %>% select(c(V1, V2, V3, V4, V5, V6, V7, V8, V9))
df_hap2 = df %>% select(c(V6, V7, V8, V5, V4, V1, V2, V3, V9))

write.table(df_hap1, out_hap1_file, quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")
write.table(df_hap2, out_hap2_file, quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")