source("loader/monthly_link_additions.R")
source("loader/monthly_teahouse_postings.R")
month_links = load.monthly_link_additions(reload=T)
month_postings = load.monthly_teahouse_postings(reload=T)

common_links = unique(month_links[
    month >= "2015-01-01" &
    postings > 100,
]$link)

svg("messages/plots/teahouse_links_additions.monthly.svg",
    height=5, width=7)
ggplot(
    month_links[link %in% common_links &
                month < "2015-09-01",],
    aes(x=month, y=postings)
) +
theme_bw() +
theme(legend.position="top") +
geom_line(
    aes(linetype=link),
    size=0.75
) +
scale_x_date(
    "Calendar month",
    limits=c(as.Date("2010-01-01"), as.Date("2015-08-01"))
) +
scale_y_continuous("Link postings (User_talk)")
dev.off()

svg("messages/plots/teahouse_postings.monthly.svg",
    height=5, width=7)
ggplot(
    month_postings[month < "2015-09-01",],
    aes(x=month, y=postings)
) +
theme_bw() +
theme(legend.position="top") +
geom_area(fill="#DDDDDD") +
geom_line() +
scale_x_date(
    "Calendar month",
    limits=c(as.Date("2010-01-01"), as.Date("2015-08-01"))
) +
scale_y_continuous("Link postings (User_talk)")
dev.off()
