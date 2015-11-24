CREATE TABLE th_link_additions (
  page_id INT,
  page_namespace INT,
  page_title INT,
  rev_id INT,
  rev_timestamp VARBINARY(20),
  rev_comment VARBINARY(255),
  link VARBINARY(255),
  diff INT,
  PRIMARY KEY(rev_id, link)
);
