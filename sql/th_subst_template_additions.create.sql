CREATE TABLE th_subst_template_additions (
  page_id INT,
  page_namespace INT,
  page_title INT,
  rev_id INT,
  rev_timestamp VARBINARY(20),
  rev_comment VARBINARY(255),
  template VARBINARY(255),
  diff INT,
  PRIMARY KEY(rev_id, template)
);
