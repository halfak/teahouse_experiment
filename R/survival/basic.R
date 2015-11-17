source("loader/experimental_users.R")
source("loader/experimental_user_survival.R")

users = load.experimental_users(reload=T)
survival = load.experimental_user_survival(reload=T)

user_survival = merge(users, survival, by="user_id")

bucket.survival = user_survival[,
    list(
        revisions_3_to_4_weeks.k = sum(revisions_3_to_4_weeks > 0),
        revisions_1_to_2_months.k = sum(revisions_1_to_2_months > 0),
        revisions_2_to_6_months.k = sum(revisions_2_to_6_months > 0),
        n = length(user_id)
    ),
    list(bucket=sample_group)
]
bucket.survival$revisions_3_to_4_weeks.p = with(
    bucket.survival,
    revisions_3_to_4_weeks.k/n
)
bucket.survival$revisions_1_to_2_months.p = with(
    bucket.survival,
    revisions_1_to_2_months.k/n
)
bucket.survival$revisions_2_to_6_months.p = with(
    bucket.survival,
    revisions_2_to_6_months.k/n
)

prop.test(bucket.survival$revisions_3_to_4_weeks.k, bucket.survival$n)
prop.test(bucket.survival$revisions_1_to_2_months.k, bucket.survival$n)
prop.test(bucket.survival$revisions_2_to_6_months.k, bucket.survival$n)

bucket.survival5 = user_survival[,
    list(
        revisions_3_to_4_weeks.k = sum(revisions_3_to_4_weeks >= 5),
        revisions_1_to_2_months.k = sum(revisions_1_to_2_months >= 5),
        revisions_2_to_6_months.k = sum(revisions_2_to_6_months >= 5),
        n = length(user_id)
    ),
    list(bucket=sample_group)
]
bucket.survival5$revisions_3_to_4_weeks.p = with(
    bucket.survival5,
    revisions_3_to_4_weeks.k/n
)
bucket.survival5$revisions_1_to_2_months.p = with(
    bucket.survival5,
    revisions_1_to_2_months.k/n
)
bucket.survival5$revisions_2_to_6_months.p = with(
    bucket.survival5,
    revisions_2_to_6_months.k/n
)

wiki.table(bucket.survival5)

prop.test(bucket.survival5$revisions_3_to_4_weeks.k, bucket.survival5$n)
prop.test(bucket.survival5$revisions_1_to_2_months.k, bucket.survival5$n)
prop.test(bucket.survival5$revisions_2_to_6_months.k, bucket.survival5$n)
