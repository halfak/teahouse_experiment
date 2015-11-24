source("env.R")
source("util.R")

load.monthly_link_additions = tsv_loader(
	paste(DATA_DIR, "th_monthly_link_additions.tsv", sep="/"),
	"MONTHLY_LINK_ADDITIONS",
  function(dt){
    old_month = dt$month
    dt$month = as.Date(paste(old_month, "01", sep="-"))
	dt
  }
)
