source("env.R")
source("util.R")

load.experimental_users = tsv_loader(
	paste(DATA_DIR, "th_experimental_user.tsv", sep="/"),
	"EXPERIMENTAL_USERS"
)
