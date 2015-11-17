source("loader/experimental_users.R")
source("loader/experimental_user_survival.R")
source("loader/preinvite_talk_flags.R")
source("loader/preinvite_edit_stats.R")
source("loader/preinvite_mobile_edits.R")

users = load.experimental_users(reload=T)
survival = load.experimental_user_survival(reload=T)
talk_flags = load.preinvite_talk_flags(reload=T)
edit_stats = load.preinvite_edit_stats(reload=T)
mobile_edits = load.preinvite_mobile_edits(reload=T)

user_info = merge(
    merge(users,
          merge(survival, mobile_edits, by="user_id"),
          by="user_id"),
    merge(edit_stats, talk_flags, by="user_id", all=T)
)
user_info$mobile_editor = (user_info$mobile_edits / user_info$edits) >= 0.9

# Clean up NAs in talk_flags
for(col in names(user_info)){
    set(user_info,which(is.na(user_info[[col]])),col,F)
}

for(col in names(user_info)){
    print(col)
    if(is.numeric(user_info[[col]])){
        invited.vals = user_info[sample_group=="invited",][[col]]
        control.vals = user_info[sample_group=="control",][[col]]
        model = wilcox.test(invited.vals, control.vals)

        print(paste(
            col,
            paste("control", paste(quantile(control.vals), collapse="-"), sep="="),
            paste("invited", paste(quantile(invited.vals), collapse="-"), sep="="),
            paste("W", model$statistic, sep="="),
            paste("p", round(model$p.value, 3), sep="=")
        ))
    }else if(is.logical(user_info[[col]])){
        invited.k = sum(user_info[sample_group=="invited",][[col]])
        control.k = sum(user_info[sample_group=="control",][[col]])
        invited.n = length(user_info[sample_group=="invited",][[col]])
        control.n = length(user_info[sample_group=="control",][[col]])
        model = prop.test(c(invited.k, control.k), c(invited.n, control.n))
        print(paste(
            col,
            paste("control", round(control.k/control.n, 3), sep="="),
            paste("invited", round(invited.k/invited.n, 3), sep="="),
            paste("X-squared", round(model$statistic, 3), sep="="),
            paste("p", round(model$p.value, 3), sep="=")
        ))
    }

}


survival_ranges = data.table()
for(range in c("3_to_4_weeks", "1_to_2_months", "2_to_6_months")){
    for(threshold in c(1, 5)){
        survival_ranges = rbind(
            survival_ranges,
            with(
                user_info[mobile_editor == F,],
                data.table(
                    range=range,
                    threshold=threshold,
                    user_id,
                    grp = sample_group,
                    survival = user_info[mobile_editor == F,][[paste("revisions", range, sep="_")]] >= threshold,
                    edits,
                    main_edits,
                    main_edits_prop = main_edits / edits,
                    talk_edits,
                    talk_edits_prop = talk_edits / edits,
                    user_edits,
                    user_edits_prop = user_edits / edits,
                    user_talk_edits,
                    user_talk_edits_prop = user_talk_edits / edits,
                    wp_edits,
                    wp_edits_prop = wp_edits / edits,
                    other_edits,
                    other_edits_prop = other_edits / edits,
                    vandal_warning,
                    spam_warning,
                    copyright_warning,
                    general_warning,
                    block,
                    csd,
                    deletion
                )
            )
        )
    }
}

model = glm(
    survival ~
        grp +
        log(edits+1) +
        log(main_edits+1) +
        log(talk_edits+1) +
        log(user_edits+1) +
        log(user_talk_edits+1) +
        log(wp_edits+1) +
        grp * (log(edits+1) + general_warning + csd + deletion),
    data = survival_ranges[range == "3_to_4_weeks" & threshold == 1,],
    family = "binomial")
summary(model)

model = glm(
    survival ~
        grp,
    data = survival_ranges[range == "3_to_4_weeks" & threshold == 1,],
    family = "binomial")
summary(model)

model = glm(
    survival ~
        grp +
        log(edits+1) +
        log(main_edits+1) +
        log(talk_edits+1) +
        log(user_edits+1) +
        log(user_talk_edits+1) +
        log(wp_edits+1) +
        grp * (log(edits+1) + general_warning + csd + deletion),
    data = survival_ranges[range == "1_to_2_months" & threshold == 1,],
    family = "binomial")
summary(model)

model = glm(
    survival ~
        grp +
        log(edits+1) +
        log(main_edits+1) +
        log(talk_edits+1) +
        log(user_edits+1) +
        log(user_talk_edits+1) +
        log(wp_edits+1) +
        grp * (log(edits+1) + general_warning + csd + deletion),
    data = survival_ranges[range == "2_to_6_months" & threshold == 1,],
    family = "binomial")
summary(model)

############################################# Threshold = 5 edits

model = glm(
    survival ~
        grp +
        log(edits+1) +
        log(main_edits+1) +
        log(talk_edits+1) +
        log(user_edits+1) +
        log(user_talk_edits+1) +
        log(wp_edits+1) +
        grp * (log(edits+1) + general_warning + csd + deletion),
    data = survival_ranges[range == "3_to_4_weeks" & threshold == 5,],
    family = "binomial")
summary(model)

model = glm(
    survival ~
        grp +
        log(edits+1) +
        log(main_edits+1) +
        log(talk_edits+1) +
        log(user_edits+1) +
        log(user_talk_edits+1) +
        log(wp_edits+1) +
        grp * (log(edits+1) + general_warning + deletion),
    data = survival_ranges[range == "1_to_2_months" & threshold == 5,],
    family = "binomial")
summary(model)

model = glm(
    survival ~
        grp,
    data = survival_ranges[range == "2_to_6_months" & threshold == 5,],
    family = "binomial")
summary(model)

model = glm(
    survival ~
        grp +
        log(edits+1) +
        log(main_edits+1) +
        log(talk_edits+1) +
        log(user_edits+1) +
        log(user_talk_edits+1) +
        log(wp_edits+1) +
        grp * (log(edits+1) + general_warning + deletion),
    data = survival_ranges[range == "2_to_6_months" & threshold == 5,],
    family = "binomial")
summary(model)
