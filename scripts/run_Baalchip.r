library(BaalChIP)
library(parallel)
library(doParallel)
library(dplyr)
library(mcmcr)
library(coda)


args = commandArgs(trailing = TRUE)
file = args[1]
out_path = args[2]
source_dir = args[3]
source(paste0(source_dir, "R/applyBayes.R"))
source(paste0(source_dir, "R/Bayes_report.R"))

df_count_with_RAF = read.csv(file)

df_count = df_count_with_RAF %>% select(c(ID, score, REF.counts, ALT.counts))
df_RAF = df_count_with_RAF %>% select(c(ID, RMbias, RAF))

Bayes_reports = list()
size = nrow(df_count)
batch_size = 2000
epoch = size %/% batch_size

for (i in 1:epoch){
 	print(i)
	start = 1 + batch_size * (i - 1)
	end = batch_size * i
	Bayes_report = runBayes(counts = df_count[start:end, ], bias = df_RAF[start:end, ], Iter = 5000, conf_level = 0.95, cores = 16)

	Bayes_report$Corrected.AR = rowMeans(Bayes_report[ , c("Bayes_lower", "Bayes_upper")])
	Bayes_report$isASB = ifelse(Bayes_report$Bayes_sig_A == 1 | Bayes_report$Bayes_sig_B == 1, "TRUE" , "FALSE")
	Bayes_report$RAF = df_count_with_RAF[start:end, ]$RAF
	Bayes_report$AR = df_count_with_RAF[start:end, ]$REF.counts / (df_count_with_RAF[start:end, ]$REF.counts + df_count_with_RAF[start:end, ]$ALT.counts)

	Bayes_reports[[i]] = Bayes_report
}

start = end + 1
Bayes_report = runBayes(counts = df_count[start:size, ], bias = df_RAF[start:size, ], Iter = 5000, conf_level = 0.95, cores = 16)

Bayes_report$Corrected.AR = rowMeans(Bayes_report[ , c("Bayes_lower", "Bayes_upper")])
Bayes_report$isASB = ifelse(Bayes_report$Bayes_sig_A == 1 | Bayes_report$Bayes_sig_B == 1, "TRUE" , "FALSE")
Bayes_report$RAF = df_count_with_RAF[start:size, ]$RAF
Bayes_report$AR = df_count_with_RAF[start:size, ]$REF.counts / (df_count_with_RAF[start:size, ]$REF.counts + df_count_with_RAF[start:size, ]$ALT.counts)
Bayes_reports[[i + 1]] = Bayes_report

Bayes_report_all = Bayes_reports %>% bind_rows()
write.table(file = out_path, Bayes_report_all, sep="\t", quote=F, row.names=F)