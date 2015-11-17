source("env.R")
source("util.R")

load.preinvite_edit_stats = tsv_loader(
	paste(DATA_DIR, "th_preinvite_edit_stats.tsv", sep="/"),
	"PREINVITE_EDIT_STATS"
)
