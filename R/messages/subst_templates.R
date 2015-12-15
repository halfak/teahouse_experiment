source("loader/monthly_subst_templates.R")
month_templates = load.monthly_subst_templates(reload=T)

top_templates = month_templates[,
    list(postings = sum(postings)),
    by=template
][
    order(postings, decreasing=T),
][1:100]

common_templates = month_templates[,
    list(postings = sum(postings)),
    by=template
][
    postings >= 100,
][order(postings, decreasing=T),]

warning_templates = common_templates[
    regexpr("^template:(uw-|3rr|drm|.*warning.*)", template) != -1,
]$template

month_warnings = month_templates[
    template %in% warning_templates,
    list(
        postings = sum(postings)
    ),
    month
]

svg("messages/plots/warning_posting.monthly.svg", height=5, width=7)
ggplot(
    month_warnings[month < "2015-09-01",],
    aes(x=month, y=postings)
) +
theme_bw() +
geom_area(fill="#EEAAAA") +
geom_line(color="#AA0000") +
scale_x_date(
    "Calendar month",
    limits=as.Date(c("2006-01-01", "2015-08-01"))
) +
scale_y_continuous("Warning posts (User_talk)")
dev.off()

teahouse_templates = common_templates[
    regexpr("teahouse", template) != -1,
]$template

month_th_invites = month_templates[
    template %in% teahouse_templates,
    list(
        postings = sum(postings)
    ),
    month
]

svg("messages/plots/teahouse_invitations.monthly.svg", height=5, width=7)
ggplot(
    month_th_invites[month < "2015-09-01",],
    aes(x=month, y=postings)
) +
theme_bw() +
geom_area(fill="#AAEEAA") +
geom_line(color="#00AA00") +
scale_x_date(
    "Calendar month",
    limits=as.Date(c("2006-01-01", "2015-08-01"))
) +
scale_y_continuous("Warning posts (User_talk)")
dev.off()
