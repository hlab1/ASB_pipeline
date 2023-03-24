library(dplyr)
library(tidyr)

args = commandArgs(trailing = TRUE)
input_sheet = args[1]
out_path = args[2]
df_lib = read.table(input_sheet, header = TRUE)
lib_group = unique(df_lib$group)

for (temp_group in lib_group) {
	print(temp_group)
	file.list = filter(df_lib, group == temp_group)$files
	df_count_list = list()

	for (file in file.list) {
		df_merge = read.csv(file)

		df_count = df_merge %>%
			count(ID, ref) %>%
			pivot_wider(names_from = ref, values_from = n, values_fill = 0) %>%
			rename(REF.counts = hap1, ALT.counts = hap2)

		df_count_list[[file]] = df_count
	}
	
	df_group_count = df_count_list %>%
		bind_rows() %>%
		aggregate(. ~ ID, ., sum)
	df_group_count$RAF = df_group_count$REF.counts / (df_group_count$REF.counts + df_group_count$ALT.counts)
	df_group_count$RMbias = rep(0.5, nrow(df_group_count))
	df_group_count = df_group_count %>% select(c(ID, RAF, RMbias))

	write.csv(df_group_count, paste0(out_path, temp_group, "_RAF.csv"), row.names = FALSE, quote = FALSE)
}