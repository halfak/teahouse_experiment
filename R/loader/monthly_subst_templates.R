source("env.R")
source("util.R")

load.monthly_subst_templates = tsv_loader(
	paste(DATA_DIR, "th_monthly_subst_templates.tsv", sep="/"),
	"MONTHLY_SUBST_TEMPLATES",
  function(dt){
    old_month = dt$month
    dt$month = as.Date(paste(old_month, "01", sep="-"))
	dt
  }
)
