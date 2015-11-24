SELECT
  LEFT(rev_timestamp, 7) AS month,
  COUNT(DISTINCT rev_id) AS postings
FROM th_link_additions
GROUP BY 1;
