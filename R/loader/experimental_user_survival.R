source("env.R")
source("util.R")

load.experimental_user_survival = tsv_loader(
	paste(DATA_DIR, "th_experimental_user_survival.tsv", sep="/"),
	"EXPERIMENTAL_USER_SURVIVAL"
)
