SELECT
  user_id,
  COUNT(rev_id) AS edits,
  SUM(page_namespace = 0) AS main_edits,
  SUM(page_namespace = 1) AS talk_edits,
  SUM(page_namespace = 2) AS user_edits,
  SUM(page_namespace = 3) AS user_talk_edits,
  SUM(page_namespace IN (4,5)) AS wp_edits,
  SUM(page_namespace > 5) AS other_edits
FROM th_retention_sample
LEFT JOIN th_retention_sample_preinvite_edits ON
  rev_user = user_id
GROUP BY user_id;
