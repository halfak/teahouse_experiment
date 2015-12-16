host=enwiki.labsdb
user=u2041
my_db=u2041__thr

labsdb=-h $(host)
enwiki=enwiki_p


datasets/th2_experimental_user_survival.tsv: \
		datasets/th2_experimental_user.tsv
	cat sql/th2_experimental_user_survival.sql | \
	mysql $(labsdb) $(enwiki) > \
	datasets/th2_experimental_user_survival.tsv

datasets/th3_experimental_user_survival.tsv: \
		datasets/th3_experimental_user.tsv
	cat sql/th3_experimental_user_survival.sql | \
	mysql $(labsdb) $(enwiki) > \
	datasets/th3_experimental_user_survival.tsv

#datasets/th2_preinvite_edit_stats.tsv
#datasets/th2_preinvite_mobile_edits.tsv
#datasets/th2_preinvite_talk_flags.tsv
#datasets/th2_preinvite_talk.tsv
