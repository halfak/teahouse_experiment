source("env.R")
source("util.R")

load.preinvite_talk_flags = tsv_loader(
	paste(DATA_DIR, "th_preinvite_talk_flags.tsv", sep="/"),
	"PREINVITE_TALK_FLAGS",
	function(dt){
		with(dt,
			data.table(
				user_id,
				vandal_warning = dt$vandal_warning == "True",
				spam_warning = dt$spam_warning == "True",
				copyright_warning = dt$copyright_warning == "True",
				general_warning = dt$general_warning == "True",
				block = dt$block == "True",
				welcome = dt$welcome == "True",
				csd = dt$csd == "True",
				deletion = dt$deletion == "True",
				afc = dt$afc == "True",
				teahouse = dt$teahouse == "True"
			)
		)
	}
)
