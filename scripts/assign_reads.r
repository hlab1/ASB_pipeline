library(dplyr)
library(tidyr)

args = commandArgs(trailing = TRUE)
input_hap1_dir = args[1]
input_hap1_pattern = args[2]
input_hap2_dir = args[3]
input_hap2_pattern = args[4]
out_merged_dir = args[5]
out_meta_dir = args[6]

hap1.list.files = list.files(input_hap1_dir, pattern = input_hap1_pattern)
hap2.list.files = list.files(input_hap2_dir, pattern = input_hap2_pattern)
df_input_files = cbind(hap1.list.files, hap2.list.files)
df_input_files

df_meta <- data.frame(nreads_pre_hap1 = integer(),
	nreads_pre_hap2 = integer(),
	nreads_post_hap1 = integer(),
	nreads_post_hap2 = integer(),
	nreads_post_total = integer())

for (i in 1:nrow(df_input_files)) {
	hap1.file = df_input_files[i, "hap1.list.files"]
	hap2.file = df_input_files[i, "hap2.list.files"]
	hap1_file_path = paste0(input_hap1_dir, hap1.file)
	hap2_file_path = paste0(input_hap2_dir, hap2.file)
	merged_file_out_path = paste0(out_merged_dir, hap1.file, ".merged.csv")

	df_hap1 = read.table(hap1_file_path)
	names(df_hap1) = c("read_chr", "read_start", "read_end", "QNAME", "MAPQ", "seq", "mismatch",
		"hap1_vari_chr", "hap1_vari_start", "hap1_vari_end",
		"hap1_vari_seq", "hap2_vari_seq",
		"hap2_vari_chr", "hap2_vari_start", "hap2_vari_end",
		"ID", "length")
	df_hap1$mismatch = gsub("XM:i:", "", df_hap1$mismatch)
	df_hap1 = df_hap1 %>% select(-length)
	df_hap1$ref = rep("hap1", nrow(df_hap1))
	nreads_pre_hap1 = nrow(unique(df_hap1[c("ID","QNAME")]))

	df_hap2 = read.table(hap2_file_path)
	names(df_hap2) = c("read_chr", "read_start", "read_end", "QNAME", "MAPQ", "seq", "mismatch",
		"hap2_vari_chr", "hap2_vari_start", "hap2_vari_end",
		"hap2_vari_seq", "hap1_vari_seq",
		"hap1_vari_chr", "hap1_vari_start", "hap1_vari_end",
		"ID", "length")
	df_hap2$mismatch = gsub("XM:i:", "", df_hap2$mismatch)
	df_hap2 = df_hap2 %>% select(c("read_chr", "read_start", "read_end", "QNAME", "MAPQ", "seq", "mismatch",
		"hap1_vari_chr", "hap1_vari_start", "hap1_vari_end",
		"hap1_vari_seq", "hap2_vari_seq",
		"hap2_vari_chr", "hap2_vari_start", "hap2_vari_end",
		"ID"))
	df_hap2$ref = rep("hap2", nrow(df_hap2))
	nreads_pre_hap2 = nrow(unique(df_hap2[c("ID","QNAME")]))


	df_merge = rbind(df_hap1, df_hap2)

	## If a read has higher mapping quality for either of the haplotypes it is assigned to that haplotype. If the mapping quality is the same, we look at the number of mismatches and assigned the read to the haplotype for which the read is aligned with least number of mismatches. If both metrics are equivalent, we deem the read as commonly mapping to both haplotypes.

	df_merge = df_merge %>%
	 	dplyr::group_by(ID, QNAME) %>%
		slice_max(MAPQ, n = 1) %>%
		slice_min(mismatch, n = 1) %>%
		arrange(.by_group=TRUE)

	write.csv(df_merge, merged_file_out_path, row.names = FALSE, quote = FALSE)
	nreads_post_hap1 = nrow(unique((df_merge %>% filter(ref == "hap1"))[c("ID","QNAME")]))
	nreads_post_hap2 = nrow(unique((df_merge %>% filter(ref == "hap2"))[c("ID","QNAME")]))
	nreads_post_total = nrow(unique(df_merge[c("ID","QNAME")]))

	new_meta_row = c(nreads_pre_hap1, nreads_pre_hap2, nreads_post_hap1, nreads_post_hap2, nreads_post_total)
	df_meta = rbind(df_meta, new_meta_row)
}

names(df_meta) = c("nreads_pre_hap1", "nreads_pre_hap2", "nreads_post_hap1", "nreads_post_hap2", "nreads_post_total")
write.csv(df_meta, paste0(out_meta_dir, input_hap1_pattern, "_meta.csv"), row.names = FALSE, quote = FALSE)