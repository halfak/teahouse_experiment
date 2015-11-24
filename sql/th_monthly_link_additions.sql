SELECT
  LEFT(rev_timestamp, 7) AS month,
  SUBSTRING_INDEX(link, "#", 1) AS link,
  COUNT(DISTINCT rev_id) AS postings
FROM staging.th_link_additions
GROUP BY 1,2;
