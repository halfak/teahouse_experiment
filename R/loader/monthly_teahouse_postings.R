source("env.R")
source("util.R")

load.monthly_teahouse_postings = tsv_loader(
	paste(DATA_DIR, "th_monthly_teahouse_postings.tsv", sep="/"),
	"MONTHLY_TEAHOUSE_POSTINGS",
  function(dt){
    old_month = dt$month
    dt$month = as.Date(paste(old_month, "01", sep="-"))
	dt
  }
)
