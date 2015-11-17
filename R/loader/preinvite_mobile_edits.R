source("env.R")
source("util.R")

load.preinvite_mobile_edits = tsv_loader(
	paste(DATA_DIR, "th_preinvite_mobile_edits.tsv", sep="/"),
	"PREINVITE_MOBILE_EDITS"
)
