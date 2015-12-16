SELECT
    user_id,
    SUM(revisions_3_to_4_weeks) AS revisions_3_to_4_weeks,
    SUM(revisions_1_to_2_months) AS revisions_1_to_2_months,
    SUM(revisions_2_to_6_months) AS revisions_2_to_6_months
FROM (
    (SELECT 
        user_id,
        SUM(
            rev_timestamp IS NOT NULL AND 
            DATEDIFF(rev_timestamp, user_registration) BETWEEN 21 AND 28
        ) AS revisions_3_to_4_weeks,
        SUM(
            rev_timestamp IS NOT NULL AND 
            DATEDIFF(rev_timestamp, user_registration) BETWEEN 30 AND 60
        ) AS revisions_1_to_2_months,
        SUM(
            rev_timestamp IS NOT NULL AND 
            DATEDIFF(rev_timestamp, user_registration) BETWEEN 60 AND 180
        ) AS revisions_2_to_6_months
    FROM staging.th2_experimental_user as user
    INNER JOIN user USING (user_id)
    LEFT JOIN revision ON 
        rev_user = user_id AND
        rev_timestamp >= DATE_FORMAT(
            DATE_ADD(user_registration, INTERVAL 21 DAY), 
            "%Y%m%d%H%i%S"
        )
    GROUP BY 1)
    UNION
    (SELECT 
        user_id,
        SUM(
            ar_timestamp IS NOT NULL AND 
            DATEDIFF(ar_timestamp, user_registration) BETWEEN 21 AND 28
        ) AS revisions_3_to_4_weeks,
        SUM(
            ar_timestamp IS NOT NULL AND 
            DATEDIFF(ar_timestamp, user_registration) BETWEEN 30 AND 60
        ) AS revisions_1_to_2_months,
        SUM(
            ar_timestamp IS NOT NULL AND 
            DATEDIFF(ar_timestamp, user_registration) BETWEEN 60 AND 180
        ) AS revisions_2_to_6_months
    FROM staging.th2_experimental_user AS user
    INNER JOIN user USING (user_id)
    LEFT JOIN archive ON 
        ar_user = user_id AND
        ar_timestamp >= DATE_FORMAT(
            DATE_ADD(user_registration, INTERVAL 21 DAY), 
            "%Y%m%d%H%i%S"
        )
    GROUP BY 1)
) user_span_revisions
GROUP BY user_id;
