SELECT
  LEFT(rev_timestamp, 7) AS month,
  template,
  COUNT(*) AS postings
FROM staging.th_subst_template_additions
GROUP BY 1,2;
